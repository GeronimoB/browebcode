import 'package:flutter/material.dart';

import '../main.dart';

void showErrorSnackBar(BuildContext ctx, String message) {
  print(scaffoldMessengerKey.currentState);
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        textAlign: TextAlign.start,
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}

void showSucessSnackBar(BuildContext context, String text) {
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: const Color(0xFF05FF00),
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        textAlign: TextAlign.start,
      ),
      duration: const Duration(seconds: 5),
    ),
  );
}
