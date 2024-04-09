import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/auth/data/models/user_model.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:bro_app_to/utils/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import 'package:path/path.dart' as path;

import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as Http;
import 'package:provider/provider.dart';

import '../utils/api_client.dart';
import '../utils/chat_preview.dart';

class FirebaseMessageRepository implements MessageUseCase {
  Stream<List<ChatPreview>> streamLastMessagesWithUsers(
      String userId, bool isAgent, BuildContext context) async* {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final id = isAgent ? "agente_$userId" : "jugador_$userId";
    try {
      final userDocSnapshot = FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .collection('messages')
          .snapshots();
      int contadorTotal = 0;
      await for (var snapshot in userDocSnapshot) {
        List<ChatPreview> messagesWithUsers = [];
        for (var otherUserDoc in snapshot.docs) {
          final otherUserId = otherUserDoc.id;
          final mute = await isMuted2(id, otherUserId);
          final userDBId = otherUserId.split('_')[1];
          final response = await ApiClient().get('auth/user/$userDBId');
          final chatInfo = await getChatInfo(id, otherUserId);
          final lastMsg = await chatInfo["lastMessage"];
          final lastTimeMessage = await chatInfo["lastTimeMessage"];
          final isPinned = await chatInfo["isPinned"];
          final count = await getUnreadMessageCount(id, otherUserId);

          if (count != 0) contadorTotal++;

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
              isPinned: isPinned,
              isMuted: mute,
              friendUser: userData,
              count: count,
              message: lastMsg,
              time: tiempo,
            );
            messagesWithUsers.add(chat);
          } else {
            continue;
          }
        }
        messagesWithUsers.sort((a, b) => b.isPinned ? 1 : -1);

        userProvider.unreadTotalMessages = contadorTotal;

        yield messagesWithUsers;
      }
    } catch (e) {
      print("Error getting last messages with users: $e");
      throw e;
    }
  }

  Future<Map<String, dynamic>> getChatInfo(String userId, String chatId) async {
    try {
      final messageDocSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('messages')
          .doc(chatId)
          .get();

      final String lastMessage = messageDocSnapshot.data()?['last_msg'] ?? '';
      final Timestamp lastTimeMessage =
          messageDocSnapshot.data()?['time_msg'] ?? Timestamp(0, 0);
      final bool isPinned = messageDocSnapshot.data()?['pinned'] == true;

      return {
        "lastMessage": lastMessage,
        "lastTimeMessage": lastTimeMessage,
        "isPinned": isPinned,
      };
    } catch (e) {
      print("Error getting chat info: $e");
      throw e;
    }
  }

  Future<bool> isPinned(String userId, String otherUserId) async {
    try {
      final chatSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('messages')
          .doc(otherUserId)
          .get();

      return chatSnapshot.exists && chatSnapshot.data()?['pinned'] == true;
    } catch (e) {
      print("Error checking if chat is pinned: $e");
      throw e;
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

  Future<void> deleteAllMessages(String senderId, String receiverId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('messages')
          .doc(receiverId)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('messages')
          .doc(receiverId)
          .collection('chats')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      print("Error deleting messages: $e");
      throw e;
    }
  }

  Future<void> muteFriend(String senderId, String receiverId, bool mute) async {
    try {
      final DocumentReference muteRef = FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('mutes')
          .doc(receiverId);

      if (mute) {
        // Si el usuario quiere silenciar al otro usuario, se crea la colección "mutes"
        await muteRef.set({"us": receiverId});
      } else {
        // Si el usuario quiere deshacer el silencio, se elimina la colección "mutes"
        print("deshacer silencio");
        await muteRef.delete();
      }
    } catch (e) {
      print("Error muting/unmuting friend: $e");
      throw e;
    }
  }

  Future<bool> isMuted(String userId, String otherUserId) async {
    try {
      final DocumentSnapshot muteSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserId)
          .collection('mutes')
          .doc(userId)
          .get();

      return muteSnapshot.exists;
    } catch (e) {
      print("Error checking mute status: $e");
      rethrow;
    }
  }

  Future<bool> isMuted2(String userId, String otherUserId) async {
    try {
      final DocumentSnapshot muteSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('mutes')
          .doc(otherUserId)
          .get();

      return muteSnapshot.exists;
    } catch (e) {
      print("Error checking mute status: $e");
      rethrow;
    }
  }

  Future<void> pinChat(String senderId, String receiverId, bool pin) async {
    try {
      final DocumentReference chatRef = FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('messages')
          .doc(receiverId);
      await chatRef.update({'pinned': pin});
    } catch (e) {
      print("Error pinning/unpinning chat: $e");
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

      final mute = await isMuted(message.senderId, message.receiverId);
      print(mute);
      if (!mute) {
        const uri = "auth/notification-message";
        Map<String, dynamic> body = {
          "title": username,
          "body": message.message,
          "friendID": message.receiverId,
        };
        ApiClient().post(uri, body);
      }
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
