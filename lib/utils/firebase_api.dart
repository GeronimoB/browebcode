import 'dart:convert';

import 'package:bro_app_to/Screens/agent/bottom_navigation_bar.dart';
import 'package:bro_app_to/Screens/player/bottom_navigation_bar_player.dart';
import 'package:bro_app_to/main.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/auth/presentation/screens/Sing_in.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:bro_app_to/utils/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void handleMessage(RemoteMessage? message) async {
  if (message == null) return;
  print("manejando el mensaje...");
  print(message);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final agente = prefs.getBool("agente");
  if (agente != null) {
    if (agente) {
      navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
          builder: (context) =>
              const CustomBottomNavigationBar(initialIndex: 2)));
    } else {
      navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
          builder: (context) =>
              const CustomBottomNavigationBarPlayer(initialIndex: 3)));
    }
  } else {
    navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInScreen()));
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
  final title = message.notification?.title ?? '';
  final body = message.notification?.body ?? '';
  // Verifica si hay datos en el mensaje antes de almacenar la notificación
  if (title.isNotEmpty || body.isNotEmpty) {
    currentNotifications.add(
      NotificationModel(title: title, content: body),
    );

    await saveNotification(NotificationModel(title: title, content: body));
  }
}

Future<void> saveNotification(NotificationModel notification) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Recupera las notificaciones existentes
  List<String>? savedNotifications = prefs.getStringList('notifications') ?? [];

  // Agrega la nueva notificación
  savedNotifications.add(jsonEncode(notification.toJson()));

  // Guarda la lista actualizada
  prefs.setStringList('notifications', savedNotifications);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("recibiendo mensaje...");
      final notification = message.notification;
      if (notification == null) return;
      handleMessage(message);

      // Almacena la notificación activa en la lista
      final title = notification.title ?? '';
      final body = notification.body ?? '';
      currentNotifications.add(
        NotificationModel(title: title, content: body),
      );

      await saveNotification(NotificationModel(title: title, content: body));
      _localNotifications.show(
          notification.hashCode,
          title,
          body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@drawable/ic_stat_ic_notification',
            ),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future<void> initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android =
        AndroidInitializationSettings('@drawable/ic_stat_ic_notification');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload.payload ?? ''));
      handleMessage(message);
    });

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(channel);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    fcmToken = await _firebaseMessaging.getToken() ?? "";
    print("Token: $fcmToken");
    initPushNotifications();
    initLocalNotifications();
  }
}
