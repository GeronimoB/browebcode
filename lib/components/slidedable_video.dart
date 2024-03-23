import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SlidableVideo extends StatefulWidget {
  final String videoUrl;
  const SlidableVideo({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<SlidableVideo> createState() => _SlidableVideoState();
}

class _SlidableVideoState extends State<SlidableVideo> {
  late VideoPlayerController _controller;
  bool _showPauseIcon = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void didUpdateWidget(covariant SlidableVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoUrl != oldWidget.videoUrl) {
      _controller.dispose();
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    Uri url = Uri.parse(widget.videoUrl);
    _controller = VideoPlayerController.networkUrl(url)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showPauseIconForAMoment() {
    setState(() {
      _showPauseIcon = true;
    });
    // Después de 1 segundo, ocultar el ícono de pausa
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showPauseIcon = false;
      });
    });
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
      _showPauseIconForAMoment();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _controller.value.isInitialized
              ? VideoPlayer(_controller)
              : const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.green), // Color del loader
                  ),
                ),
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Color(0xFF00E050),
              bufferedColor: Colors.white,
              backgroundColor: Colors.grey,
            ),
          ),
          if (_showPauseIcon || !_controller.value.isPlaying)
            AnimatedOpacity(
              opacity:
                  _showPauseIcon || !_controller.value.isPlaying ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Center(
                child: Icon(
                  _controller.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: _controller.value.isPlaying
                      ? const Color.fromARGB(142, 255, 255, 255)
                      : Colors.white,
                  size: 64,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
