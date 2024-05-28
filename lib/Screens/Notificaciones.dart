import 'dart:convert';

import 'package:bro_app_to/components/app_bar_title.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/notification_model.dart';

class Notificaciones extends StatefulWidget {
  const Notificaciones({super.key});

  @override
  State<Notificaciones> createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 800,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 44, 44, 44),
            Color.fromARGB(255, 0, 0, 0),
          ],
        ),
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: appBarTitle(translations!["NOTIFICATIONS"]),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF00E050),
              size: 32,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: currentNotifications.length,
                itemBuilder: (BuildContext context, int index) {
                  final noti = currentNotifications[index];
                  return Container(
                    alignment: Alignment.center,
                    width: 400,
                    child: _buildNotificacionItem(noti),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Image.asset(
                'assets/images/Logo.png',
                width: 104,
              ),
            ),
          ],
        ),
      ),
      ),
      ),
    );
  }

  Future<void> saveNotification(NotificationModel notification) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Recupera las notificaciones existentes
    List<String>? savedNotifications =
        prefs.getStringList('notifications') ?? [];

    // Elimina la notificación de la lista
    savedNotifications.removeWhere((item) =>
        NotificationModel.fromJson(jsonDecode(item)).title ==
            notification.title &&
        NotificationModel.fromJson(jsonDecode(item)).content ==
            notification.content);

    // Guarda la lista actualizada
    prefs.setStringList('notifications', savedNotifications);
  }

  Widget _buildNotificacionItem(NotificationModel noti) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          setState(() {
            currentNotifications.remove(noti);
            saveNotification(noti);
          });
        }),
        children: [
          SlidableAction(
            autoClose: false,
            flex: 1,
            onPressed: (contexto) {
              final controller2 = Slidable.of(contexto);
              controller2?.dismiss(
                ResizeRequest(
                  const Duration(milliseconds: 300),
                  () {
                    setState(() {
                      currentNotifications.remove(noti);
                      saveNotification(noti);
                    });
                  },
                ),
                duration: const Duration(milliseconds: 300),
              );
            },
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xff05FF00),
            icon: Icons.close,
            label: null,
            spacing: 8,
          ),
        ],
      ),
      child: Container(
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(50),
        ),
        child: RichText(
          text: TextSpan(
            text: '${noti.title} ',
            children: [
              TextSpan(
                text: noti.content,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.normal),
              )
            ],
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
