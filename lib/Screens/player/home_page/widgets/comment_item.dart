import 'dart:convert';

import 'package:bro_app_to/Screens/player/home_page/models/comments_model.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:bro_app_to/utils/global_video_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/player_helper.dart';
import '../../../../providers/user_provider.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final bool isReply;
  final GlobalVideoModel video;
  final ValueChanged<Comment> onUpdateLike;
  final ValueChanged<int> onReplyPressed;
  const CommentItem({
    required this.comment,
    required this.video,
    required this.onUpdateLike,
    required this.onReplyPressed,
    this.isReply = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: isReply ? 40.0 : 0.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => PlayerHelper.navigateToFriendProfile(
                      comment.userId.toString(),
                      context,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            comment.username,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        if (video.verificado)
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(Icons.verified,
                                color: Colors.black, size: 20),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    timeAgo(comment.createdAt),
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 10.0),
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 16.0),
                            children: _highlightMentions(comment.comment),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: const Text(
                      "Responder",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () =>
                        onReplyPressed(isReply ? comment.parentId : comment.id),
                  ),
                ],
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Icon(
                    comment.isLikedByCurrentUser
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: comment.isLikedByCurrentUser
                        ? Colors.red
                        : Colors.black,
                  ),
                  onTap: () => _toggleLikeComment(comment, context),
                ),
                Text(
                  "${comment.likes}",
                  style: const TextStyle(color: Colors.black54, fontSize: 10),
                ),
              ],
            ),
          ),
          if (comment.replies.isNotEmpty)
            Column(
              children: List.generate(comment.replies.length, (i) {
                return CommentItem(
                  comment: comment.replies[i],
                  isReply: true,
                  video: video,
                  onUpdateLike: onUpdateLike,
                  onReplyPressed: onReplyPressed,
                );
              }),
            ),
        ],
      ),
    );
  }

  String timeAgo(DateTime date) {
    final Duration difference = DateTime.now().difference(date);

    if (difference.inSeconds < 60) {
      return 'hace ${difference.inSeconds} s';
    } else if (difference.inMinutes < 60) {
      return 'hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'hace ${difference.inHours} h';
    } else if (difference.inDays < 30) {
      return 'hace ${difference.inDays} d';
    } else if (difference.inDays < 365) {
      return 'hace ${difference.inDays ~/ 30} meses';
    } else {
      return 'hace ${difference.inDays ~/ 365} años';
    }
  }

  List<TextSpan> _highlightMentions(String text) {
    final mentionRegex = RegExp(r'@(\w+)');
    final matches = mentionRegex.allMatches(text);

    if (matches.isEmpty) {
      return [TextSpan(text: text)];
    }

    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      spans.add(
        TextSpan(
          text: match.group(0),
          style: const TextStyle(
            color: Color(0xFF00F056),
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return spans;
  }

  Future<void> _toggleLikeComment(Comment comment, BuildContext context) async {
    final userId = Provider.of<UserProvider>(context, listen: false)
        .getCurrentUser()
        .userId;

    try {
      final response = await ApiClient().post(
        'security_filter/v1/api/social/toggle-like-comments',
        {
          'userId': userId,
          'commentId': comment.id.toString(),
        },
      );
      final data = jsonDecode(response.body);
      if (data['ok']) {
        onUpdateLike(comment);
      }
    } catch (e) {
      print("Error al dar like: $e");
    }
  }
}
