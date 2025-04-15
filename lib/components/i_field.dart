import 'package:flutter/material.dart';

Widget iField(
  TextEditingController ctlr,
  String label, {
  TextInputType keybType = TextInputType.text,
  Function(String)? onChanged,
  Key? key,
  FocusNode? focusNode,
  bool darkMode = true,
}) {
  return TextField(
    controller: ctlr,
    key: key,
    focusNode: focusNode,
    keyboardType: keybType,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: darkMode ? Colors.white : Colors.black,
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
    style: TextStyle(
      color: darkMode ? Colors.white : Colors.black,
      fontFamily: 'Montserrat',
    ),
    onChanged: onChanged,
    onSubmitted: (_) {
      focusNode?.unfocus();
    },
  );
}
