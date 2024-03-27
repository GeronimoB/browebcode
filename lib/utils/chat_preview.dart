import 'package:bro_app_to/src/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';

class ChatPreview {
  int count;
  String message;
  String time;
  UserModel friendUser;

  ChatPreview({
    required this.friendUser,
    required this.count,
    required this.message,
    required this.time,
  });
}
