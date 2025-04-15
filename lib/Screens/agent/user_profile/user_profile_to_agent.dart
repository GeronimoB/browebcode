import 'dart:convert';

import 'package:bro_app_to/Screens/player/full_screen_video_page.dart';
import 'package:bro_app_to/components/avatar_placeholder.dart';
import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as provider;

import '../../../components/custom_text_button.dart';
import '../../../components/i_field.dart';
import '../../../components/snackbar.dart';
import '../../../src/auth/data/models/user_model.dart';
import '../../chat_page.dart';
import 'player_provider_usecase.dart';

class PlayerProfileToAgent extends ConsumerStatefulWidget {
  final String userId;

  const PlayerProfileToAgent({super.key, required this.userId});

  @override
  ConsumerState<PlayerProfileToAgent> createState() =>
      _PlayerProfileToAgentState();
}

class _PlayerProfileToAgentState extends ConsumerState<PlayerProfileToAgent> {
  double gridSpacing = 2.0;
  bool _isExpanded = false;
  OverlayEntry? _overlayEntry;
  String selectedReason = '';
  late TextEditingController additionalComments;
  String currentUserId = '';

  final List<String> reportReasons = [
    'No me gusta',
    'Bullying o contacto no deseado',
    'Suicidio, autolesión o trastornos alimenticios',
    'Violencia, odio o explotación',
    'Vende o promociona artículos restringidos',
    'Desnudos o actividad sexual',
    'Estafas, fraudes o spam',
    'Información falsa',
  ];

  @override
  void initState() {
    super.initState();
    additionalComments = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentUserId = provider.Provider.of<UserProvider>(context, listen: false)
          .getCurrentUser()
          .userId;
    });
  }

  @override
  void dispose() {
    additionalComments.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerAsync = ref.watch(playerProvider(
      PlayerInfoParams(userId: widget.userId, currentUserId: currentUserId),
    ));
    final videosAsync = ref.watch(videosProvider(widget.userId));
    final widthVideo = MediaQuery.of(context).size.width / 3;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 530),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2C2C2C), Color(0xFF000000)],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                scrolledUnderElevation: 0,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF00E050),
                    size: 32,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon:
                        const Icon(Icons.more_horiz, color: Color(0xFF00E050)),
                    onPressed: () {
                      _showCustomMenu(context);
                    },
                  ),
                ],
              ),
              extendBody: true,
              body: playerAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (data) {
                  DateTime? birthDate = data?.player.birthDate;

                  String formattedDate = birthDate != null
                      ? DateFormat('dd-MM-yyyy').format(birthDate)
                      : '';
                  String province = provincesByCountry[data?.player.pais]
                          ?[data?.player.provincia] ??
                      'Provincia desconocida';
                  String country =
                      countries[data?.player.pais] ?? 'País desconocido';

                  String shortInfo =
                      '$province, $country\n${translations!["birthdate"]}: $formattedDate';
                  String fullInfo = '$province, $country\n'
                      '${translations!["birthdate"]}: $formattedDate\n'
                      '${translations!["Categorys"]}: ${categorias[data?.player.categoria] ?? "Categoría desconocida"}\n'
                      '${translations!["position_label"]}: ${posiciones[data?.player.position] ?? "Posición desconocida"}\n';

                  if (data?.player.club != null &&
                      (data?.player.club?.isNotEmpty ?? false)) {
                    fullInfo +=
                        '${translations!["club_label"]}: ${data?.player.club}\n';
                  }
                  final seleccion =
                      selecciones[data?.player.seleccionNacional] ??
                          "Selección desconocida";
                  final categoriaSeleccion = (data?.player.seleccionNacional !=
                              null &&
                          nationalCategories
                              .containsKey(data?.player.seleccionNacional) &&
                          data?.player.categoriaSeleccion != null &&
                          nationalCategories[data?.player.seleccionNacional]!
                              .containsKey(data?.player.categoriaSeleccion))
                      ? nationalCategories[data?.player.seleccionNacional]![
                          data?.player.categoriaSeleccion]!
                      : "Categoría desconocida";

                  final pie = piesDominantes[data?.player.pieDominante] ??
                      "Desconocido";

                  fullInfo +=
                      '${translations!["national_selection_short"]}: $seleccion $categoriaSeleccion\n'
                      '${translations!["dominant_feet"]}: $pie\n'
                      '${translations!["height_label"]}: ${data?.player.altura}\n';

                  if (data?.player.logrosIndividuales != null &&
                      (data?.player.logrosIndividuales!.isNotEmpty ?? false)) {
                    fullInfo +=
                        '${translations!["Achievements2"]}: ${data?.player.logrosIndividuales}\n';
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (data?.player.userImage!.isNotEmpty ?? false)
                        ClipOval(
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                AvatarPlaceholder(80),
                            errorWidget: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/fot.png',
                                fit: BoxFit.fill,
                                width: 95,
                                height: 95,
                              );
                            },
                            imageUrl: data?.player.userImage ?? '',
                            fit: BoxFit.fill,
                            width: 95,
                            height: 95,
                          ),
                        ),
                      if (data?.player.userImage!.isEmpty ?? true)
                        ClipOval(
                          child: Image.asset(
                            'assets/images/fot.png',
                            width: 95,
                            height: 95,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${data?.player.name} ${data?.player.lastName}',
                            style: const TextStyle(
                              color: Color(0xFF00E050),
                              fontSize: 22.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (data?.player.verificado ?? false) ...[
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.verified,
                              color: Color(0xFF00E050),
                              size: 24,
                            ),
                          ]
                        ],
                      ),
                      Text(
                        '@${data?.player.username}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                data?.followers.toString() ?? '0',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Montserrat',
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const Text(
                                'Seguidores',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Montserrat',
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(width: 12),
                          Column(
                            children: [
                              Text(
                                data?.following.toString() ?? '0',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Montserrat',
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const Text(
                                'Seguidos',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Montserrat',
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        _isExpanded ? fullInfo : shortInfo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Montserrat',
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Text(
                          _isExpanded
                              ? translations!['seeLess']
                              : translations!['seeMore'],
                          style: const TextStyle(
                              color: Color(0xFF05FF00),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextButton(
                            onTap: () async {
                              final status = data?.status ?? 'undefined';

                              switch (status) {
                                case 'undefined':
                                  final isPublic =
                                      data?.player.isPublicAccount ?? false;

                                  await followUser(widget.userId, isPublic);

                                  break;

                                case 'accepted':
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(23)),
                                      contentPadding: const EdgeInsets.all(25),
                                      backgroundColor: const Color(0xFF3B3B3B),
                                      title: const Text(
                                        '¿Dejar de seguir?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      content: const Text(
                                        '¿Estás seguro de que quieres dejar de seguir a este jugador?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancelar'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                        ),
                                        TextButton(
                                          child:
                                              const Text('Sí, dejar de seguir'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    await unfollowUser(widget.userId);
                                  }
                                  break;

                                case 'pending':
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(23)),
                                      contentPadding: const EdgeInsets.all(25),
                                      backgroundColor: const Color(0xFF3B3B3B),
                                      title: const Text(
                                        'Cancelar solicitud',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      content: const Text(
                                        '¿Estás seguro de que quieres cancelar la solicitud?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('No'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                        ),
                                        TextButton(
                                          child: const Text('Sí'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    await unfollowUser(widget.userId);
                                  }
                                  break;
                                case 'rejected':
                                  break;
                              }
                            },
                            text: translations![data?.status ?? 'undefined'],
                            buttonPrimary: true,
                            width: 180,
                            height: 35,
                          ),
                          const SizedBox(width: 15),
                          CustomTextButton(
                            onTap: () {
                              final friend = UserModel.fromPlayer(
                                data!.player,
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    friend: friend,
                                  ),
                                ),
                              );
                            },
                            text: 'Enviar mensaje',
                            buttonPrimary: false,
                            width: 180,
                            height: 35,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 15),
                        height: 4.0,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Color(0xFF00E050),
                            boxShadow: [
                              CustomBoxShadow(
                                  color: Color(0xFF05FF00), blurRadius: 4)
                            ]),
                      ),
                      videosAsync.when(
                        loading: () => const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF05FF00)),
                            ),
                          ),
                        ),
                        error: (err, stack) => Expanded(
                          child: Center(
                            child: Text('Error: $err'),
                          ),
                        ),
                        data: (videos) {
                          if (videos.isEmpty) {
                            return Expanded(
                              child: Center(
                                child: Text(
                                  translations!["NoVideosYet!"],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                ),
                              ),
                            );
                          }
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: GridView.builder(
                                padding: const EdgeInsets.all(0),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: gridSpacing,
                                  mainAxisSpacing: gridSpacing,
                                  childAspectRatio: 1,
                                ),
                                itemCount: videos.length,
                                itemBuilder: (context, index) {
                                  final video = videos[index];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FullScreenVideoPage(
                                            video: video,
                                            index: index,
                                            showOptions: false,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          placeholder: (context, url) {
                                            return AspectRatio(
                                              aspectRatio: 1,
                                              child: Image.asset(
                                                'assets/images/video_placeholder.jpg',
                                                width: widthVideo,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                          errorWidget:
                                              (context, error, stackTrace) {
                                            return AspectRatio(
                                              aspectRatio: 1,
                                              child: Image.asset(
                                                'assets/images/video_placeholder.jpg',
                                                width: widthVideo,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                          imageUrl: video.imageUrl ?? "",
                                          width: widthVideo,
                                          fit: BoxFit.cover,
                                        ),
                                        if (video.isFavorite)
                                          const Positioned(
                                            top: 8.0,
                                            right: 8.0,
                                            child: Icon(
                                              Icons.star,
                                              color: Color(0xFF05FF00),
                                              size: 24.0,
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> followUser(String followedId, bool isPublic) async {
    try {
      final response = await ApiClient().post(
        'security_filter/v1/api/social/follow',
        {
          'followerId': currentUserId,
          'followedId': followedId,
          'isPublic': isPublic,
        },
      );
      final data = jsonDecode(response.body);
      if (data['ok']) {
        showSucessSnackBar(context, data['message']);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                PlayerProfileToAgent(userId: followedId),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    } catch (e) {
      showErrorSnackBar(context, translations!['ErrorOccurredMessage']);
    }
  }

  Future<void> unfollowUser(String followedId) async {
    try {
      final response = await ApiClient().delete(
        'security_filter/v1/api/social/follow',
        {
          'followerId': currentUserId,
          'followedId': followedId,
        },
      );

      final data = jsonDecode(response.body);
      if (data['ok']) {
        showSucessSnackBar(context, data['message']);

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                PlayerProfileToAgent(userId: followedId),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      } else {
        showErrorSnackBar(context, data['error']);
      }
    } catch (e) {
      showErrorSnackBar(context, translations!['ErrorOccurredMessage']);
    }
  }

  void _showCustomMenu(BuildContext context) {
    _overlayEntry?.remove();
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    double sizeWidth = size.width > 530 ? 530 : size.width;
    double sizeWidth2 =
        size.width > 530 ? ((size.width - 530) / 2 + 530) : size.width;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
            child: Container(
              width: sizeWidth,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: offset.dx + sizeWidth2 - 230,
            top: offset.dy + 35,
            width: 220,
            child: Material(
              borderRadius: BorderRadius.circular(15),
              elevation: 5.0,
              shadowColor: Colors.black.withOpacity(0.4),
              color: const Color(0xFF3B3B3B),
              child: Container(
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
                    ListTile(
                      title: const Text(
                        'Denunciar',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontStyle: FontStyle.italic),
                      ),
                      onTap: () {
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                        _showReportModal();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: const Color.fromARGB(255, 44, 44, 44),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Denunciar',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    height: 2,
                    color: Colors.white.withOpacity(0.25),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '¿Por qué quieres denunciar esta publicación?',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Opciones
                  ...reportReasons.map((reason) => ListTile(
                        title: Text(
                          reason,
                          style: TextStyle(
                              color: selectedReason == reason
                                  ? const Color.fromARGB(255, 0, 224, 80)
                                  : Colors.white),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: selectedReason == reason
                              ? const Color.fromARGB(255, 0, 224, 80)
                              : Colors.grey,
                        ),
                        selectedTileColor:
                            const Color.fromARGB(255, 0, 224, 80),
                        onTap: () {
                          setModalState(() {
                            selectedReason = reason;
                          });
                        },
                      )),
                  const SizedBox(height: 10),
                  iField(additionalComments, 'Comentarios (opcional):'),
                  const SizedBox(height: 15),
                  CustomTextButton(
                    onTap: () async {
                      print(selectedReason);

                      Navigator.of(context).pop();
                      final response =
                          await ApiClient().post('auth/reports/report', {
                        "userId": context
                            .read<UserProvider>()
                            .getCurrentUser()
                            .userId
                            .toString(),
                        "reportedUserId": widget.userId,
                        "reason": selectedReason,
                        "comments": additionalComments.text,
                      });

                      if (response.statusCode == 200) {
                        showSucessSnackBar(context,
                            'Tu reporte se ha enviado, lo revisaremos y te daremos noticias pronto.');
                      } else {
                        showErrorSnackBar(
                            context, 'Ocurrio un error, intentalo de nuevo.');
                      }
                    },
                    text: 'Enviar',
                    buttonPrimary: true,
                    width: 116,
                    height: 39,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
