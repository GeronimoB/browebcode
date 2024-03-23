import 'dart:convert';

import 'package:bro_app_to/Screens/MatchProfile.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:bro_app_to/utils/initial_video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

class InicioPage extends StatefulWidget {
  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  double _xOffset = 0.0;
  double _rotation = 0.0;
  int _currentIndex = 0;
  List<InitialVideoModel> _videoUrls = [];
  List<VideoPlayerController?> _controllers = [];
  bool _showPauseIcon = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls(); // Llamada a la función para obtener las URLs de los videos
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  void _showPauseIconForAMoment() {
    setState(() {
      _showPauseIcon = true;
    });
    // Después de 2 segundos, ocultar el ícono de pausa
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _showPauseIcon = false;
      });
    });
  }

  Future<void> _fetchVideoUrls() async {
    try {
      final response = await ApiClient().post('auth/random-videos', {"a": "a"});
      if (response.statusCode == 200) {
        final videos = jsonDecode(response.body)["video"];
        final List<InitialVideoModel> videosA = mapListToInitialVideos(videos);
        setState(() {
          _videoUrls = videosA;
          _controllers = List.generate(_videoUrls.length, (index) => null);
          _initializeController(_currentIndex);
        });
      } else {
        throw Exception('Error al obtener las URLs de los videos');
      }
    } catch (error) {
      print('Error al obtener las URLs de los videos: $error');
      // Manejar el error, mostrar un mensaje de error, etc.
    }
  }

  void _initializeController(int index) {
    final int previousIndex =
        _currentIndex == 0 ? _controllers.length - 1 : _currentIndex - 1;
    final int nextIndex = (_currentIndex + 1) % _controllers.length;

    if (_controllers[_currentIndex] == null) {
      // ignore: deprecated_member_use
      _controllers[_currentIndex] =
          VideoPlayerController.network(_videoUrls[_currentIndex].url)
            ..initialize().then((_) {
              setState(() {});
              if (_controllers[_currentIndex] != null &&
                  _currentIndex == index) {
                _controllers[_currentIndex]!.play();
              }
            });
    }
    if (_controllers[previousIndex] == null) {
      // ignore: deprecated_member_use
      _controllers[previousIndex] =
          VideoPlayerController.network(_videoUrls[previousIndex].url)
            ..initialize();
    }

    // Cargar el controlador para el siguiente video
    if (_controllers[nextIndex] == null) {
      // ignore: deprecated_member_use
      _controllers[nextIndex] =
          VideoPlayerController.network(_videoUrls[nextIndex].url)
            ..initialize();
    }
  }

  void _managePlayback(int newIndex) {
    for (int i = 0; i < _controllers.length; i++) {
      if (i == newIndex || i == _currentIndex) {
        _controllers[i]?.play();
      } else {
        _controllers[i]?.pause();
      }
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _xOffset += details.primaryDelta!;
      _rotation = _xOffset / 1000;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_xOffset > 100) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _controllers.length;
        _initializeController(_currentIndex);
        _managePlayback(_currentIndex);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MatchProfile(userId: _videoUrls[_currentIndex].userId)),
      );
      print('Deslizado hacia la derecha');
    } else if (_xOffset < -100) {
      setState(() {
        _currentIndex =
            _currentIndex == 0 ? _controllers.length - 1 : _currentIndex - 1;
        _initializeController(_currentIndex);
        _managePlayback(_currentIndex);
      });
      print('Deslizado hacia la izquierda');
    }
    setState(() {
      _xOffset = 0;
      _rotation = 0;
    });
  }

  void _togglePlayPause() {
    if (_controllers[_currentIndex]?.value.isPlaying ?? false) {
      _controllers[_currentIndex]?.pause();
    } else {
      _controllers[_currentIndex]?.play();
      _showPauseIconForAMoment();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1 - (_xOffset.abs() * 0.001);
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.9,
      child: GestureDetector(
        onTap: _togglePlayPause,
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
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        if (_controllers.isNotEmpty) ...[
                          _controllers[_currentIndex]!.value.isInitialized
                              ? VideoPlayer(_controllers[_currentIndex]!)
                              : const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.green), // Color del loader
                                  ),
                                ),
                          VideoProgressIndicator(
                            _controllers[_currentIndex]!,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Color(0xFF00E050),
                              bufferedColor: Colors.white,
                              backgroundColor: Colors.grey,
                            ),
                          ),
                          if (_showPauseIcon)
                            const AnimatedOpacity(
                              opacity: 1.0,
                              duration: Duration(milliseconds: 300),
                              child: Center(
                                child: Icon(
                                  Icons.pause_circle_filled,
                                  color: Colors.white,
                                  size: 64,
                                ),
                              ),
                            ),
                          if (!_controllers[_currentIndex]!.value.isPlaying)
                            const AnimatedOpacity(
                              opacity: 1.0,
                              duration: Duration(milliseconds: 300),
                              child: Center(
                                child: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 64,
                                ),
                              ),
                            ),
                        ],
                        if (_controllers.isEmpty)
                          const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.green), // Color del loader
                            ),
                          ),
                      ],
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
