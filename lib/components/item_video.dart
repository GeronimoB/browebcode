import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../utils/initial_video_model.dart';

class ItemVideo extends StatefulWidget {
  final InitialVideoModel video;
  final bool isFirstVideo;
  final VoidCallback updateFirstVideo;

  const ItemVideo({
    Key? key,
    required this.video,
    required this.isFirstVideo,
    required this.updateFirstVideo,
  }) : super(key: key);

  @override
  State<ItemVideo> createState() => _ItemVideoState();
}

class _ItemVideoState extends State<ItemVideo> {
  bool _showPauseIcon = false;
  late VideoPlayerController _controller;

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
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
      _showPauseIconForAMoment();
    }
  }

  @override
  void initState() {
    Uri url = Uri.parse(widget.video.shareUrl ?? '');
    _controller = VideoPlayerController.networkUrl(url)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        if (!widget.isFirstVideo) {
          _controller.play();
        } else {
          widget.updateFirstVideo.call();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_controller);
    return FittedBox(
      fit: BoxFit.fill,
      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: GestureDetector(
          onTap: _togglePlayPause,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _controller.value.isInitialized
                  ? VideoPlayer(_controller)
                  : const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
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
              AnimatedOpacity(
                opacity: _showPauseIcon ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Center(
                  child: Icon(
                    Icons.pause_circle_filled,
                    color: _controller.value.isPlaying
                        ? const Color.fromARGB(142, 255, 255, 255)
                        : Colors.white,
                    size: 64,
                  ),
                ),
              ),
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
              Positioned(
                left: 0,
                right: 0,
                bottom: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  color: Colors.black.withOpacity(0.6),
                  width: MediaQuery.of(context).size.width - 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.video.user,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              height: 1,
                              decoration: TextDecoration.none,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          if (!widget.video.verificado)
                            const Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 24,
                            ),
                        ],
                      ),
                      if (widget.video.description.isNotEmpty) ...[
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.video.description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            height: 1,
                            decoration: TextDecoration.none,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
