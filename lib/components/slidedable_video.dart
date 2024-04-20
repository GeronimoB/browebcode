import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class SlidableVideo extends StatefulWidget {
  final VideoPlayerController controller;
  final String username;
  final String description;
  const SlidableVideo(
      {Key? key,
      required this.controller,
      required this.username,
      required this.description})
      : super(key: key);

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
              ? VideoPlayer(widget.controller)
              : const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                  ),
                ),
          Positioned(
            left: 10,
            bottom: 45,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    height: 1,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    height: 1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
