import 'package:bro_app_to/src/auth/data/models/user_model.dart';
import 'package:bro_app_to/utils/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import 'package:path/path.dart' as path;

import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as Http;

import '../utils/api_client.dart';
import '../utils/chat_preview.dart';

class FirebaseMessageRepository implements MessageUseCase {
  Future<List<ChatPreview>> getLastMessagesWithUsers(
      String userId, bool isAgent) async {
    final id = isAgent ? "agente_$userId" : "jugador_$userId";
    try {
      print(id);
      final userDocSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .collection('messages')
          .get();

      List<ChatPreview> messagesWithUsers = [];

      for (var otherUserDoc in userDocSnapshot.docs) {
        final otherUserId = otherUserDoc.id;
        print(otherUserId);
        final userDBId = otherUserId.split('_')[1];
        final response = await ApiClient().get('auth/user/$userDBId');
        final lastMsg = await getLastMessage(id, otherUserId);
        final lastTimeMessage = await getLastTimeMessage(id, otherUserId);
        final count = await getUnreadMessageCount(id, otherUserId);
        print("sin leer $count");
        String tiempo = "";
        if (lastTimeMessage != Timestamp(0, 0)) {
          DateTime dateTime = lastTimeMessage.toDate();
          tiempo = dateTime.toIso8601String().substring(11, 16);
        }
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final user = jsonData['user'];
          final userData = UserModel.fromJson(user);
          final chat = ChatPreview(
              friendUser: userData,
              count: count,
              message: lastMsg,
              time: tiempo);
          messagesWithUsers.add(chat);
        } else {
          continue;
        }
      }

      return messagesWithUsers;
    } catch (e) {
      // Manejar errores
      print("Error getting last messages with users: $e");
      throw e;
    }
  }

  Future<String> getLastMessage(String userId, String chatId) async {
    dynamic lastMessage = (await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('messages')
            .doc(chatId)
            .get())
        .data()?['last_msg'];
    if (lastMessage != null && lastMessage is String) {
      return lastMessage;
    } else {
      return "";
    }
  }

  Future<int> getUnreadMessageCount(String userId, String chatId) async {
    int unreadCount = 0;

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(userId)
        .collection('messages')
        .doc(chatId)
        .collection('chats')
        .get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.docs;

    for (var document in documents) {
      String receiverId = document.data()['receiverId'];

      bool isRead = document.data()['read'] ?? false;
      if (receiverId == userId && !isRead) {
        unreadCount++;
      }
    }
    return unreadCount;
  }

  Future<void> markAllMessagesAsRead(String userId, String chatId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(userId)
        .collection('messages')
        .doc(chatId)
        .collection('chats')
        .where('receiverId', isEqualTo: userId)
        .get();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'read': true});
    }

    QuerySnapshot<Map<String, dynamic>> snapshot2 = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(chatId)
        .collection('messages')
        .doc(userId)
        .collection('chats')
        .where('receiverId', isEqualTo: userId)
        .get();

    for (var doc in snapshot2.docs) {
      batch.update(doc.reference, {'read': true});
    }

    await batch.commit();
  }

  Future<Timestamp> getLastTimeMessage(String userId, String chatId) async {
    dynamic lastTimeMessage = (await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('messages')
            .doc(chatId)
            .get())
        .data()?['time_msg'];
    if (lastTimeMessage != null && lastTimeMessage is Timestamp) {
      return lastTimeMessage;
    } else {
      return Timestamp(0, 0);
    }
  }

  Future<void> deleteAllMessages(String senderId, String receiverId) async {
    try {
      // Borrar el documento del remitente al receptor
      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('messages')
          .doc(receiverId)
          .delete();

      // Borrar el documento del receptor al remitente
      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('messages')
          .doc(senderId)
          .delete();
    } catch (e) {
      // Manejar errores
      print("Error deleting messages: $e");
      throw e;
    }
  }

  @override
  Future<void> sendMessage(Message message, String username) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(message.senderId)
          .collection('messages')
          .doc(message.receiverId)
          .collection('chats')
          .add({
        "senderId": message.senderId,
        "receiverId": message.receiverId,
        "message": message.message,
        "type": "text",
        "date": DateTime.now(),
        "sent": true,
        "read": false
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(message.senderId)
          .collection('messages')
          .doc(message.receiverId)
          .set({'last_msg': message.message, 'time_msg': DateTime.now()});

      const uri = "auth/notification-message";
      Map<String, dynamic> body = {
        "title": username,
        "body": message.message,
        "friendID": message.receiverId,
      };
      ApiClient().post(uri, body);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(message.receiverId)
          .collection('messages')
          .doc(message.senderId)
          .collection("chats")
          .add({
        "senderId": message.senderId,
        "receiverId": message.receiverId,
        "message": message.message,
        "type": "text",
        "date": DateTime.now(),
        "sent": false,
        "read": false
      });
      // Actualizar último mensaje
      await FirebaseFirestore.instance
          .collection('users')
          .doc(message.receiverId)
          .collection('messages')
          .doc(message.senderId)
          .set({"last_msg": message.message, 'time_msg': DateTime.now()});
    } catch (e) {
      // Manejar errores
      print("Error sending message: $e");
      throw e;
    }
  }
}
