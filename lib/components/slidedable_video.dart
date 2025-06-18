import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SlidableVideo extends StatefulWidget {
  final VideoPlayerController controller;

  const SlidableVideo({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<SlidableVideo> createState() => _SlidableVideoState();
}

class _SlidableVideoState extends State<SlidableVideo> {
  bool _showPauseIcon = false;

  void _showPauseIconForAMoment() {
    setState(() {
      _showPauseIcon = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showPauseIcon = false;
      });
    });
  }

  void _togglePlayPause() {
    if (widget.controller.value.isPlaying) {
      widget.controller.pause();
    } else {
      widget.controller.play();
      _showPauseIconForAMoment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.controller.value.isInitialized
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: widget.controller.value.size.width,
                      height: widget.controller.value.size.height,
                      child: VideoPlayer(widget.controller),
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                  ),
                ),
          VideoProgressIndicator(
            widget.controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Color(0xFF00E050),
              bufferedColor: Colors.white,
              backgroundColor: Colors.grey,
            ),
          ),
          AnimatedOpacity(
            opacity: _showPauseIcon ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Center(
              child: Icon(
                Icons.pause_circle_filled,
                color: widget.controller.value.isPlaying
                    ? const Color.fromARGB(142, 255, 255, 255)
                    : Colors.white,
                size: 64,
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _showPauseIcon || !widget.controller.value.isPlaying
                ? 1.0
                : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Center(
              child: Icon(
                widget.controller.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
                color: widget.controller.value.isPlaying
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
