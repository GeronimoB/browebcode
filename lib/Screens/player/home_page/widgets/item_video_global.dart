import 'dart:convert';

import 'package:bro_app_to/Screens/player/home_page/widgets/comments_modal.dart';
import 'package:bro_app_to/Screens/player/home_page/widgets/search_users_result.dart';
import 'package:bro_app_to/common/player_helper.dart';
import 'package:bro_app_to/components/i_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../../../common/base_encode_helper.dart';
import '../../../../providers/user_provider.dart';
import '../../../../utils/api_client.dart';
import '../../../../utils/global_video_model.dart';
import '../../../agent/user_profile/user_profile_to_agent.dart';
import '../../bottom_navigation_bar_player.dart';
import '../models/user_in_filter.dart';

class ItemVideoGlobal extends StatefulWidget {
  final GlobalVideoModel video;
  final bool isFirstVideo;
  final VoidCallback updateFirstVideo;

  const ItemVideoGlobal({
    Key? key,
    required this.video,
    required this.isFirstVideo,
    required this.updateFirstVideo,
  }) : super(key: key);

  @override
  State<ItemVideoGlobal> createState() => _ItemVideoGlobalState();
}

class _ItemVideoGlobalState extends State<ItemVideoGlobal> {
  bool _showPauseIcon = false;
  late VideoPlayerController _controller;
  late TextEditingController player;
  bool showTextField = false;
  bool showContainerResult = false;
  List<UserInFilter> usuariosFiltrados = [];
  OverlayEntry? _overlayEntry;
  int commentCount = 0;

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
      setState(() {});
    } else {
      _controller.play();
      _showPauseIconForAMoment();
    }
  }

  void _toggleLike() async {
    final userId = Provider.of<UserProvider>(context, listen: false)
        .getCurrentUser()
        .userId;

    _updateLikeState();

    try {
      final response = await ApiClient().post(
        'security_filter/v1/api/social/toggle-like',
        {
          'userId': userId,
          'videoId': widget.video.videoId.toString(),
        },
      );

      final data = jsonDecode(response.body);

      if (!data['ok']) {
        _updateLikeState();
      }
    } catch (e) {
      print("Error al hacer like: $e");

      _updateLikeState();
    }
  }

  void _updateLikeState() {
    setState(() {
      widget.video.isLiked = !widget.video.isLiked;
      widget.video.likesCount += widget.video.isLiked ? 1 : -1;
    });
  }

  void _showCommentsModal() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(245, 255, 255, 255),
      builder: (context) => CommentsModal(
        video: widget.video,
        onCommentsUpdated: (newCount) {
          setState(() {
            widget.video.commentsCount = newCount;
          });
        },
      ),
    );
  }

  Future<void> _shareVideo() async {
    final encodedId = Base64Helper.encode(widget.video.videoId.toString());
    final videoUrl = 'https://app.bro.futbol/home/videos/$encodedId';
    Share.share('Mira este video increíble: $videoUrl');
  }

  @override
  void initState() {
    super.initState();
    player = TextEditingController();
    Uri url = Uri.parse(widget.video.url);
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

    commentCount = widget.video.commentsCount;
  }

  @override
  void dispose() {
    _controller.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 530
        ? 530
        : MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _controller.value.isInitialized
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: _controller.value.isPlaying
                        ? VideoPlayer(_controller)
                        : Image.network(
                            widget.video.imageUrl ?? " ",
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
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
          opacity: _showPauseIcon || !_controller.value.isPlaying ? 1.0 : 0.0,
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
        Positioned.fill(
          child: GestureDetector(
            onTap: _togglePlayPause,
            behavior: HitTestBehavior.opaque,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 70,
          child: VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Color(0xFF00E050),
              bufferedColor: Colors.white,
              backgroundColor: Colors.grey,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 74,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            height: widget.video.description.isNotEmpty ? 60 : 38,
            color: Colors.black.withAlpha(100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => PlayerHelper.navigateToFriendProfile(
                    widget.video.userId.toString(),
                    context,
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.video.fullName.trimRight(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            height: 1,
                            decoration: TextDecoration.none,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (widget.video.verificado) ...[
                        const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 5),
                      ],
                      Flexible(
                        child: Text(
                          '@${widget.video.user}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1,
                            decoration: TextDecoration.none,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.video.description.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    widget.video.description,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
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
        Positioned(
          right: 10,
          bottom: 162,
          child: Column(
            children: [
              GestureDetector(
                onTap: _toggleLike,
                child: Icon(
                  widget.video.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              Text(
                widget.video.likesCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  height: 1,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _showCommentsModal,
                child: const Icon(
                  Icons.mode_comment_outlined,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              Text(
                widget.video.commentsCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  height: 1,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _shareVideo,
                child: const Icon(
                  Icons.ios_share,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          child: Container(
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: showTextField
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: showTextField
                        ? Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(56, 1, 1, 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: iField(player, 'Usuario',
                                    onChanged: (value) {
                                  if (value.length >= 3) {
                                    setState(() {
                                      showContainerResult = true;
                                    });
                                    filterUsers(value);
                                  }
                                }),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              if (showContainerResult)
                                SearchUsersResult(
                                  context,
                                  usuariosFiltrados,
                                ),
                            ],
                          )
                        : null,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (showTextField) {
                        showContainerResult = false;
                        player.clear();
                      }

                      showTextField = !showTextField;
                    });
                  },
                  child: Icon(
                    showTextField ? Icons.close : Icons.search_outlined,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void filterUsers(String name) async {
    try {
      final response = await ApiClient()
          .get('security_filter/v1/api/social/users?query=$name');
      final data = jsonDecode(response.body);
      if (data['ok']) {
        setState(() {
          usuariosFiltrados = List<UserInFilter>.from(
              data['users'].map((user) => UserInFilter.fromJson(user)));
        });
      }
    } catch (e) {
      print("Error al obtener usuarios: $e");
    }
  }
}
