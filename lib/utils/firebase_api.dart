import 'dart:convert';

import 'package:bro_app_to/main.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:bro_app_to/utils/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void handleMessage(RemoteMessage? message) {
  if (message == null) return;
  print("manejando el mensaje...");
  print(message);
  //navigatorKey.currentState?.pushReplacementNamed('HomePage');
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
              icon: '@drawable/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future<void> initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
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
