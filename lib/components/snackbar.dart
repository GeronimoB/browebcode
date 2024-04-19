import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        textAlign: TextAlign.start,
      ),
    ),
  );
}

void showSucessSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
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
    ),
  );
}
