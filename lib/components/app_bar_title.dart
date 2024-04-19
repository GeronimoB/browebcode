import 'package:flutter/material.dart';

Widget appBarTitle(String text) {
  return Text(
    text,
    style: const TextStyle(
      color: Colors.white,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      fontSize: 24.0,
      decoration: TextDecoration.none,
    ),
    textAlign: TextAlign.center,
  );
}
