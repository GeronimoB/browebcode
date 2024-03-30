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
  List<InitialVideoModel> _videoUrls = [];
  late VideoPlayerController? currentController;
  late VideoPlayerController? nextController;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
  }

  Future<void> _fetchVideoUrls() async {
    try {
      final response = await ApiClient().post('auth/random-videos', {"a": "a"});
      if (response.statusCode == 200) {
        final videos = jsonDecode(response.body)["video"];
        final List<InitialVideoModel> videosA = mapListToInitialVideos(videos);
        setState(() {
          _videoUrls.addAll(videosA);
        });
        _initializeVideoPlayer(_currentIndex);
        _initializeNextVideoPlayer(_currentIndex + 1);
      } else {
        throw Exception('Error al obtener las URLs de los videos');
      }
    } catch (error) {
      print('Error al obtener las URLs de los videos: $error');
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _xOffset += details.primaryDelta!;
      _rotation = _xOffset / 1000;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) async {
    if (_xOffset > 100) {
      final userId = _videoUrls[_currentIndex].userId;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MatchProfile(userId: userId)),
      );
    } else if (_xOffset < -100) {
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

  @override
  Widget build(BuildContext context) {
    double scale = 1 - (_xOffset.abs() * 0.001);
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.9,
      child: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Transform.scale(
                scale: scale,
                child: Transform.rotate(
                  angle: _rotation,
                  child: Transform.translate(
                    offset: Offset(_xOffset, 0),
                    child: _videoUrls.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 20),
                                Text('Cargando videos...'),
                              ],
                            ),
                          )
                        : SlidableVideo(
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
