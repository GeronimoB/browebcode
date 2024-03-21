import 'package:bro_app_to/Screens/MatchProfile.dart';
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
  final List<String> _videoUrls = [
    'https://bro-app-bucket.s3.eu-west-3.amazonaws.com/videos_jugadores/1710979446140-ddbf5eaa.mp4',
  ];
  List<VideoPlayerController?> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_videoUrls.length, (index) => null);
    _initializeController(_currentIndex);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  void _initializeController(int index) {
    final int previousIndex = _currentIndex == 0 ? _controllers.length - 1 : _currentIndex - 1;
    final int nextIndex = (_currentIndex + 1) % _controllers.length;

    if (_controllers[_currentIndex] == null) {
      // ignore: deprecated_member_use
      _controllers[_currentIndex] = VideoPlayerController.network(_videoUrls[_currentIndex])
        ..initialize().then((_) {
          setState(() {});
          if (_controllers[_currentIndex] != null && _currentIndex == index) {
            _controllers[_currentIndex]!.play();
          }
        });
    }
    if (_controllers[previousIndex] == null) {
      // ignore: deprecated_member_use
      _controllers[previousIndex] = VideoPlayerController.network(_videoUrls[previousIndex])
        ..initialize();
    }

    // Cargar el controlador para el siguiente video
    if (_controllers[nextIndex] == null) {
      // ignore: deprecated_member_use
      _controllers[nextIndex] = VideoPlayerController.network(_videoUrls[nextIndex])
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
        MaterialPageRoute(builder: (context) => MatchProfile()),
      );
      print('Deslizado hacia la derecha');
    } else if (_xOffset < -100) {
      setState(() {
        _currentIndex = _currentIndex == 0 ? _controllers.length - 1 : _currentIndex - 1;
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
    }
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
            if (_controllers.any((controller) => controller != null && controller!.value.isInitialized))
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
                          VideoPlayer(_controllers[_currentIndex]!),
                          VideoProgressIndicator(
                            _controllers[_currentIndex]!,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Color(0xFF00E050), 
                              bufferedColor: Colors.white,
                              backgroundColor: Colors.grey, 
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
