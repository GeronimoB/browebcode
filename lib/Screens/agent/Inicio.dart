import 'dart:convert';

import 'package:bro_app_to/Screens/agent/match_profile.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:bro_app_to/utils/initial_video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/custom_dropdown.dart';
import '../../components/slidedable_video.dart';
import '../../utils/current_state.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  InicioPageState createState() => InicioPageState();
}

class InicioPageState extends State<InicioPage> {
  double _xOffset = 0.0;
  double _rotation = 0.0;
  int _currentIndex = 0;
  final List<InitialVideoModel> _videosRandom = [];
  late VideoPlayerController? currentController;
  late VideoPlayerController? nextController;
  late UserProvider userProvider;
  String currentUserId = '';
  OverlayEntry? _overlayEntry;
  late TextEditingController selectedCountry;
  late TextEditingController selectedState;
  late TextEditingController selectedHeight;
  late TextEditingController foot;
  late TextEditingController selection;
  late TextEditingController catSelection;
  late TextEditingController position;
  late TextEditingController category;
  late TextEditingController date;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    currentUserId = userProvider.getCurrentUser().userId;
    selectedCountry = TextEditingController();
    selectedState = TextEditingController();
    selectedHeight = TextEditingController();
    foot = TextEditingController();
    catSelection = TextEditingController();
    selection = TextEditingController();
    position = TextEditingController();
    category = TextEditingController();
    date = TextEditingController();
    _fetchVideoUrls();
  }

  Future<void> _fetchVideoUrls() async {
    setState(() {
      isLoading = true;
    });
    try {
      final filters = jsonEncode({
        "pais": selectedCountry.text,
        "provincia": selectedState.text,
        "altura": selectedHeight.text,
        "pie_dominante": foot.text,
        "categoria_seleccion": catSelection.text,
        "seleccion_nacional": selection.text,
        "posicion_jugador": position.text,
        "categoria": category.text,
        "fecha": date.text
      });
      final response = await ApiClient().post(
          'auth/random-videos', {"userId": currentUserId, "filters": filters});

      final videos = jsonDecode(response.body)["video"];
      List<InitialVideoModel> videosMapeados = mapListToInitialVideos(videos);
      setState(() {
        _videosRandom.clear();
        _videosRandom.addAll(videosMapeados);
      });

      if (videosMapeados.isNotEmpty) {
        _initializeVideoPlayer(_currentIndex);
        _initializeNextVideoPlayer(_currentIndex + 1);
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Error al obtener las URLs de los videos ${error}');
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _xOffset += details.primaryDelta!;
      _rotation = -_xOffset / 2000;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) async {
    if (_xOffset > 100) {
      matchFunction();
    } else if (_xOffset < -100) {
      rejectFunction();
    }
    setState(() {
      _xOffset = 0;
      _rotation = 0;
    });
  }

  void _initializeVideoPlayer(int index) {
    Uri url = Uri.parse(_videosRandom[index].url);
    currentController = VideoPlayerController.networkUrl(url)
      ..initialize().then((_) {
        setState(() {});
        currentController!.setLooping(true);
        currentController!.play();
      });
  }

  void _initializeNextVideoPlayer(int index) {
    if (_videosRandom.isNotEmpty) {
      Uri nextUrl = Uri.parse(_videosRandom[index].url);
      print(nextUrl);
      nextController = VideoPlayerController.networkUrl(nextUrl)
        ..initialize().then((_) {
          nextController!.setLooping(true);
        });
    }
  }

  @override
  void dispose() {
    currentController?.dispose();
    nextController?.dispose();
    selectedCountry.dispose();
    selectedState.dispose();
    selectedHeight.dispose();
    catSelection.dispose();
    selection.dispose();
    foot.dispose();
    position.dispose();
    category.dispose();
    date.dispose();
    super.dispose();
  }

  void _writeRejectionData(int userId, String currentUserId) async {
    FirebaseFirestore.instance
        .collection('Rejects')
        .doc('agente-$currentUserId')
        .collection('AgentRejects')
        .doc('jugador-$userId')
        .set({});
  }

  void _showCustomMenu(BuildContext context) {
    _overlayEntry?.remove();
    _overlayEntry = createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void matchFunction() {
    final userId = _videosRandom[_currentIndex].userId;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MatchProfile(userId: userId)),
    );
  }

  void rejectFunction() {
    //_writeRejectionData(userId, currentUserId);
    currentController!.dispose();
    currentController = nextController;
    _currentIndex = (_currentIndex + 1) % _videosRandom.length;
    _initializeNextVideoPlayer((_currentIndex + 1) % _videosRandom.length);
    print("cindex $_currentIndex");
    currentController!.play();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1;
    double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: height * 0.85,
          child: GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: Stack(
              children: <Widget>[
                isLoading
                    ? loadingWidget()
                    : _videosRandom.isEmpty
                        ? emptyWidget()
                        : Positioned.fill(
                            child: Transform.scale(
                              scale: scale,
                              child: Transform.rotate(
                                angle: _rotation,
                                child: Transform.translate(
                                  offset: Offset(_xOffset, 0),
                                  child: SlidableVideo(
                                    controller: currentController!,
                                    username: _videosRandom[_currentIndex].user,
                                    description: _videosRandom[_currentIndex]
                                        .description,
                                    verificado: _videosRandom[_currentIndex]
                                        .verificado,
                                  ),
                                ),
                              ),
                            ),
                          ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  right: 15,
                  child: GestureDetector(
                    onTap: () => _showCustomMenu(context),
                    child: SvgPicture.asset(
                      'assets/icons/filter.svg',
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                      color: const Color(0xFF00E050),
                    ),
                  ),
                ),
                if (_xOffset > 0)
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2 - 50,
                    right: 0,
                    child: SvgPicture.asset(
                      'assets/icons/Matchicon.svg',
                      width: 200,
                      height: 200,
                    ),
                  ),
                if (_xOffset < 0)
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2 - 50,
                    left: 5,
                    child: SvgPicture.asset(
                      'assets/icons/No Match.svg',
                      width: 200,
                      height: 200,
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: height * 0.09,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => rejectFunction(),
                child: const Icon(
                  Icons.close_rounded,
                  size: 80,
                  color: Color(0xFF00E050),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () => matchFunction(),
                child: const Icon(
                  Icons.favorite,
                  size: 65,
                  color: Color(0xFF00E050),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget loadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05FF00))),
          SizedBox(height: 20),
          Text('Cargando videos...'),
        ],
      ),
    );
  }

  Widget errorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              _fetchVideoUrls();
            },
            icon: const Icon(
              Icons.refresh,
              size: 48,
              color: Color(0xffffffff),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Error al cargar los videos!',
            style: const TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget emptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              _fetchVideoUrls();
            },
            icon: const Icon(
              Icons.refresh,
              size: 48,
              color: Color(0xffffffff),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Has llegado al final de los videos!',
            style: const TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  OverlayEntry createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: offset.dx + size.width - 305,
            top: offset.dy + 105,
            width: 300,
            child: Material(
              borderRadius: BorderRadius.circular(15),
              elevation: 5.0,
              shadowColor: Colors.black.withOpacity(0.4),
              color: const Color(0xFF3B3B3B),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xff3B3B3B),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(5, 4),
                    ),
                  ],
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => setState(() {
                          cleanFilters();
                          _fetchVideoUrls();
                          _overlayEntry?.remove();
                          _overlayEntry = null;
                        }),
                        child: Text(
                          translations!['clean'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    filterTile(
                      translations!['age_label'],
                      date,
                      anos,
                    ),
                    filterTile(
                      translations!['country_label'],
                      selectedCountry,
                      countries,
                    ),
                    filterTile(
                      translations!['state_label'],
                      selectedState,
                      provincesByCountry[selectedCountry.text != ''
                          ? selectedCountry.text
                          : 'Spain'],
                    ),
                    filterTile(
                      translations!['dominant_feet'],
                      foot,
                      piesDominantes,
                    ),
                    filterTile(
                      translations!['height_label'],
                      selectedHeight,
                      alturas,
                    ),
                    filterTile(
                      translations!['national_selection_short'],
                      selection,
                      selecciones,
                    ),
                    filterTile(
                      translations!['national_category'],
                      catSelection,
                      nationalCategories[
                          selection.text != '' ? selection.text : 'Masculina'],
                    ),
                    filterTile(
                      translations!['position_label'],
                      position,
                      posiciones,
                    ),
                    filterTile(
                      translations!['category_label_short'],
                      category,
                      categorias,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void cleanFilters() {
    setState(() {
      selectedCountry.text = '';
      selectedState.text = '';
      selectedHeight.text = '';
      catSelection.text = '';
      selection.text = '';
      foot.text = '';
      position.text = '';
      category.text = '';
      date.text = '';
    });
  }

  Widget filterTile(
      String label, TextEditingController value, List<String> items) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 18,
          ),
        ),
        const SizedBox(width: 10),
        DropdownWidget<String>(
          value: value.text,
          items: items,
          onChanged: (String? newValue) {
            setState(() {
              value.text = newValue!;
            });
            _fetchVideoUrls();
          },
          itemBuilder: (String item) {
            return item;
          },
          width: 125,
        ),
      ],
    );
  }
}
