import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPage extends StatefulWidget {
  final String videoPath;

  const FullScreenVideoPage({Key? key, required this.videoPath})
      : super(key: key);

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  double _videoHeight = 0;
  bool _isPlaying = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    Uri url = Uri.parse(widget.videoPath);
    _controller = VideoPlayerController.networkUrl(url)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
        _controller.addListener(() {
          if (_controller.value.isPlaying) {
            setState(() {
              _isPlaying = true;
            });
          } else {
            setState(() {
              _isPlaying = false;
            });
          }
        });
      });
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  void _calculateVideoHeight() {
    final Size screenSize = MediaQuery.of(context).size;
    final double videoWidth = screenSize.width;
    final double videoAspectRatio = _controller.value.aspectRatio;
    setState(() {
      _videoHeight = videoWidth / videoAspectRatio;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _animationController.forward();
      } else {
        _controller.play();
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoHeight = MediaQuery.of(context).size.height - 100;
    return Stack(
      children: [
        GestureDetector(
          onTap: _togglePlayPause,
          child: _controller.value.isInitialized
              ? SizedBox(
            width: double.maxFinite,
            height: videoHeight,
            child: Stack(
              children: [
                VideoPlayer(_controller),
                Center(
                  child: ScaleTransition(
                    scale: _animation,
                    child: Icon(
                      Icons.play_arrow,
                      size: 100,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          )
              : const Center(child: CircularProgressIndicator()),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 8.0,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF00E050)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          right: 8.0,
          child: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: const IconThemeData(color: Color(0xFF00E050)),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz, color: Color(0xFF00E050)),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                side: BorderSide(color: Color(0xFF00E050)),
              ),
              color: const Color(0xff3B3B3B),
              onSelected: (String result) {},
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                    child: Text('Borrar',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontStyle: FontStyle.italic)),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'destacar',
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                    child: Text('Destacar',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontStyle: FontStyle.italic)),
                  ),
                ),
                const PopupMenuItem<String>(
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                    child: Text('Editar',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontStyle: FontStyle.italic)),
                  ),
                ),
                const PopupMenuItem<String>(
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                    child: Text('Guardar',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontStyle: FontStyle.italic)),
                  ),
                ),
                const PopupMenuItem<String>(
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                    child: Text('Ocultar',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontStyle: FontStyle.italic)),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: MediaQuery.of(context).size.width / 2 - 52,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: SvgPicture.asset(
              'assets/icons/Logo.svg',
              fit: BoxFit.fitWidth,
              width: 104,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).size.height - videoHeight - 2,
          child: VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            padding: const EdgeInsets.symmetric(vertical: 0),
            colors: const VideoProgressColors(
              playedColor: Color(0xFF00E050),
              bufferedColor: Colors.white60,
              backgroundColor: Colors.white24,
            ),
          ),
        ),
      ],
    );
  }
}
