import 'package:bro_app_to/src/auth/data/models/user_model.dart';

class ChatPreview {
  int count;
  String message;
  String time;
  UserModel friendUser;
  bool isMuted;
  bool isPinned;

  ChatPreview({
    required this.isMuted,
    required this.isPinned,
    required this.friendUser,
    required this.count,
    required this.message,
    required this.time,
  });
}
