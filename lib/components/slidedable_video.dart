import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SlidableVideo extends StatefulWidget {
  final VideoPlayerController controller;
  const SlidableVideo({Key? key, required this.controller}) : super(key: key);

  @override
  State<SlidableVideo> createState() => _SlidableVideoState();
}

class _SlidableVideoState extends State<SlidableVideo> {
  late VideoPlayerController _controller;
  VideoPlayerController? _nextController;

  bool _showPauseIcon = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _initializeVideoPlayer();
  //   _initializeNextVideoPlayer(); // Inicializar el controlador del próximo video si hay una URL proporcionada
  // }

  // @override
  // void didUpdateWidget(covariant SlidableVideo oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.videoUrl != oldWidget.videoUrl) {
  //     _controller.dispose();
  //     _initializeVideoPlayer();
  //   }
  //   if (widget.nextVideoUrl != oldWidget.nextVideoUrl) {
  //     _nextController?.dispose(); // Dispose del controlador anterior si existe
  //     _initializeNextVideoPlayer(); // Inicializar el controlador del próximo video si hay una URL proporcionada
  //   }
  // }

  // void _initializeVideoPlayer() {
  //   Uri url = Uri.parse(widget.videoUrl);
  //   _controller = VideoPlayerController.networkUrl(url)
  //     ..initialize().then((_) {
  //       setState(() {});
  //       //_controller.play();
  //       _controller.setLooping(true);
  //     });
  // }

  // void _initializeNextVideoPlayer() {
  //   if (widget.nextVideoUrl != null) {
  //     Uri nextUrl = Uri.parse(widget.nextVideoUrl!);
  //     _nextController = VideoPlayerController.networkUrl(nextUrl)
  //       ..initialize().then((_) {
  //         setState(() {
  //           _nextController!.setLooping(true);
  //         });
  //       });
  //   }
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  //   _nextController
  //       ?.dispose(); // Dispose del controlador del próximo video si existe
  // }

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
    if (widget.controller.value.isPlaying) {
      widget.controller.pause();
    } else {
      widget.controller.play();
      _showPauseIconForAMoment();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(widget.controller.value);
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.controller.value.isInitialized
              ? VideoPlayer(widget.controller)
              : const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.green), // Color del loader
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
          if (_showPauseIcon || !widget.controller.value.isPlaying)
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
