import 'dart:convert';

import 'package:bro_app_to/Screens/agent/match_profile.dart';
import 'package:bro_app_to/providers/agent_provider.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:bro_app_to/utils/initial_video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/slidedable_video.dart';

class InicioPage extends StatefulWidget {
  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  double _xOffset = 0.0;
  double _rotation = 0.0;
  int _currentIndex = 0;
  final List<InitialVideoModel> _videoUrls = [];
  late VideoPlayerController? currentController;
  late VideoPlayerController? nextController;
  bool _isLoading = false;
  String currentUserId = '0';

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
  }

  Future<void> _fetchVideoUrls() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final id = userProvider.getCurrentUser().userId;
      final response =
          await ApiClient().post('auth/random-videos', {"userId": id});

      final videos = jsonDecode(response.body)["video"];
      final List<InitialVideoModel> videosA = mapListToInitialVideos(videos);
      setState(() {
        currentUserId = id;
        _videoUrls.clear();
        _videoUrls.addAll(videosA);
        _isLoading = false;
      });

      if (_videoUrls.isNotEmpty) {
        _initializeVideoPlayer(_currentIndex);
        _initializeNextVideoPlayer(_currentIndex + 1);
      }
    } catch (error) {
      print(error);
      throw Exception('Error al obtener las URLs de los videos');
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _xOffset += details.primaryDelta!;
      _rotation = -_xOffset / 2000;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) async {
    final userId = _videoUrls[_currentIndex].userId;
    if (_xOffset > 100) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MatchProfile(userId: userId)),
      );
    } else if (_xOffset < -100) {
      _writeRejectionData(userId, currentUserId);
      currentController!.dispose();
      currentController = nextController;
      _currentIndex = (_currentIndex + 1) % _videoUrls.length;
      _initializeNextVideoPlayer((_currentIndex + 1) % _videoUrls.length);
      currentController!.play();
    }
    setState(() {
      _xOffset = 0;
      _rotation = 0;
    });
  }

  void _initializeVideoPlayer(int index) {
    Uri url = Uri.parse(_videoUrls[index].url);
    currentController = VideoPlayerController.networkUrl(url)
      ..initialize().then((_) {
        setState(() {});
        currentController!.setLooping(true);
        currentController!.play();
      });
  }

  void _initializeNextVideoPlayer(int index) {
    if (_videoUrls.isNotEmpty) {
      Uri nextUrl = Uri.parse(_videoUrls[index].url);
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

  @override
  Widget build(BuildContext context) {
    //double scale = 1 - (_xOffset.abs() * 0.001);
    double scale = 1;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.9,
      child: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Stack(
          children: <Widget>[
            _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF05FF00))),
                        SizedBox(height: 20),
                        Text('Cargando videos...'),
                      ],
                    ),
                  )
                : _videoUrls.isEmpty
                    ? Column(
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
                      )
                    : Positioned.fill(
                        child: Transform.scale(
                          scale: scale,
                          child: Transform.rotate(
                            angle: _rotation,
                            child: Transform.translate(
                              offset: Offset(_xOffset, 0),
                              child: SlidableVideo(
                                controller: currentController!,
                              ),
                            ),
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
    );
  }
}
