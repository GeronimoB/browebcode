import 'dart:convert';

import 'package:bro_app_to/Screens/player/home_page/models/comments_model.dart';
import 'package:bro_app_to/Screens/player/home_page/models/user_in_filter.dart';
import 'package:bro_app_to/Screens/player/home_page/widgets/comment_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/i_field.dart';
import '../../../../providers/user_provider.dart';
import '../../../../utils/api_client.dart';
import '../../../../utils/global_video_model.dart';

class CommentsModal extends StatefulWidget {
  final GlobalVideoModel video;
  final Function(int) onCommentsUpdated;

  const CommentsModal(
      {Key? key, required this.video, required this.onCommentsUpdated})
      : super(key: key);

  @override
  State<CommentsModal> createState() => _CommentsModalState();
}

class _CommentsModalState extends State<CommentsModal>
    with WidgetsBindingObserver {
  List<Comment> comments = [];
  final TextEditingController _commentController = TextEditingController();
  bool isLoading = false;
  int? replyingToCommentId;
  List<UserInFilter> users = [];
  OverlayEntry? overlayEntry;
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _textFieldKey = GlobalKey();
  List<int> mentionedUserIds = [];
  Map<int, String> mentionedUsers = {};

  Future<void> _fetchComments() async {
    setState(() => isLoading = true);

    try {
      final userId = Provider.of<UserProvider>(context, listen: false)
          .getCurrentUser()
          .userId;

      final response = await ApiClient().get(
        'security_filter/v1/api/social/get-comments/${widget.video.videoId}?userId=$userId',
      );
      final data = jsonDecode(response.body);
      if (data['ok']) {
        setState(() {
          comments = List<Comment>.from(
            data['comments'].map((comment) => Comment.fromJson(comment)),
          );

          int totalComments = comments.fold(
            comments.length,
            (sum, comment) => sum + comment.replies.length,
          );

          widget.onCommentsUpdated(totalComments);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error al obtener comentarios: $e");
    }
  }

  Future<void> _postComment({int? parentCommentId}) async {
    final userId = Provider.of<UserProvider>(context, listen: false)
        .getCurrentUser()
        .userId;
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    try {
      final response = await ApiClient().post(
        'security_filter/v1/api/social/post-comment',
        {
          'userId': userId,
          'videoId': widget.video.videoId.toString(),
          'comment': commentText,
          'parentCommentId': parentCommentId?.toString(),
          'mentionedUserIds': mentionedUserIds,
        },
      );
      final data = jsonDecode(response.body);
      if (data['ok']) {
        _commentController.clear();
        setState(() {
          replyingToCommentId = null;
          mentionedUserIds.clear();
          mentionedUsers.clear();
        });
        await _fetchComments();
      }
    } catch (e) {
      print("Error al enviar comentario: $e");
    }
  }

  void toggleLikeComment(Comment comment) {
    setState(() {
      int commentIndex = comments.indexWhere((c) => c.id == comment.id);

      if (commentIndex != -1) {
        comments[commentIndex] = comments[commentIndex].copyWith(
          isLikedByCurrentUser: !comments[commentIndex].isLikedByCurrentUser,
          likes: comments[commentIndex].isLikedByCurrentUser
              ? comments[commentIndex].likes - 1
              : comments[commentIndex].likes + 1,
        );
      } else {
        for (var parentComment in comments) {
          int replyIndex =
              parentComment.replies.indexWhere((r) => r.id == comment.id);
          if (replyIndex != -1) {
            parentComment.replies[replyIndex] =
                parentComment.replies[replyIndex].copyWith(
              isLikedByCurrentUser:
                  !parentComment.replies[replyIndex].isLikedByCurrentUser,
              likes: parentComment.replies[replyIndex].isLikedByCurrentUser
                  ? parentComment.replies[replyIndex].likes - 1
                  : parentComment.replies[replyIndex].likes + 1,
            );
            break;
          }
        }
      }
    });
  }

  void onReplyPressed(int id) => setState(() {
        replyingToCommentId = id;
      });

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        width: 530,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                      ),
                    )
                  : comments.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: comments.length,
                          itemBuilder: (context, index) => CommentItem(
                            comment: comments[index],
                            video: widget.video,
                            onUpdateLike: toggleLikeComment,
                            onReplyPressed: onReplyPressed,
                          ),
                        )
                      : const Center(
                          child: Text(
                            "No hay comentarios",
                            style: TextStyle(
                              color: Colors.black38,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
            ),
            if (replyingToCommentId != null)
              const Text(
                "Respondiendo a un comentario...",
                style: TextStyle(color: Colors.black38),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: iField(
                      _commentController,
                      "Escribe un comentario...",
                      focusNode: _focusNode,
                      key: _textFieldKey,
                      darkMode: false,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      size: 24,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      await _postComment(parentCommentId: replyingToCommentId);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTextChanged() {
    final text = _commentController.text;
    final cursorPos = _commentController.selection.baseOffset;

    if (cursorPos > 0 && text[cursorPos - 1] == '@') {
    } else {
      final match = RegExp(r'@(\w+)$').firstMatch(text.substring(0, cursorPos));
      if (match != null) {
        _fetchUsers(match.group(1)!);
      } else {
        _removeUserOverlay();
      }
    }
    _checkMentions();
  }

  void _checkMentions() {
    String text = _commentController.text;

    // Extraer todos los @usernames actuales en el texto
    final matches = RegExp(r'@(\w+)').allMatches(text);
    List<String> currentMentions =
        matches.map((match) => match.group(1)!).toList();

    // Buscar los IDs de los usuarios mencionados que ya no están en el texto
    mentionedUserIds.removeWhere((userId) {
      // Obtener el username del ID
      String? username =
          mentionedUsers[userId]; // Un mapa que asocia ID con username
      return username != null && !currentMentions.contains(username);
    });

    setState(() {}); // 🔹 Actualizar la UI si hay cambios
  }

  Future<void> _fetchUsers(String query) async {
    try {
      final response = await ApiClient()
          .get('security_filter/v1/api/social/users?query=$query');
      final data = jsonDecode(response.body);
      if (data['ok']) {
        setState(() {
          users = List<UserInFilter>.from(
              data['users'].map((user) => UserInFilter.fromJson(user)));
        });
        _showUserOverlay();
      }
    } catch (e) {
      print("Error al obtener usuarios: $e");
    }
  }

  void _showUserOverlay() {
    _removeUserOverlay();

    final RenderBox renderBox =
        _textFieldKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    double estimatedHeight = _estimateOverlayHeight(users);

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy - estimatedHeight - 5,
          width: size.width,
          child: Material(
            elevation: 6.0,
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 400,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: users.map((user) {
                    return ListTile(
                      title: Text(user.username,
                          style: const TextStyle(color: Colors.black)),
                      subtitle: Text('${user.name} ${user.lastName}',
                          style: const TextStyle(color: Colors.black12)),
                      onTap: () => _mentionUser(user),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  double _estimateOverlayHeight(List<UserInFilter> users) {
    const double itemHeight = 64;
    return (users.length * itemHeight).clamp(0, 400);
  }

  void _mentionUser(UserInFilter user) {
    final text = _commentController.text;
    final cursorPos = _commentController.selection.baseOffset;

    final match = RegExp(r'@(\w*)$').firstMatch(text.substring(0, cursorPos));
    if (match != null) {
      final newText =
          text.replaceRange(match.start, cursorPos, '@${user.username} ');
      _commentController.text = newText;
      _commentController.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length),
      );

      if (!mentionedUserIds.contains(user.id)) {
        mentionedUserIds.add(user.id);
        mentionedUsers[user.id] = user.username;
      }

      _removeUserOverlay();
    }
  }

  void _removeUserOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_onTextChanged);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchComments());
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _removeUserOverlay();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset == 0.0) {
      _focusNode.unfocus();
    }
    super.didChangeMetrics();
  }
}
