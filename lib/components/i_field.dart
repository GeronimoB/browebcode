import 'package:flutter/material.dart';

Widget iField(TextEditingController ctlr, String label,
    {TextInputType keybType = TextInputType.text}) {
  return TextField(
    controller: ctlr,
    keyboardType: keybType,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
        fontSize: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF00F056), width: 2),
      ),
    ),
    style: const TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
  );
}
