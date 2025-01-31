import 'dart:convert';

class Base64Helper {
  // Codifica el texto en Base64
  static String encode(String text) {
    return base64Url.encode(utf8.encode(text));
  }

  // Decodifica el texto desde Base64
  static String decode(String base64Text) {
    return utf8.decode(base64Url.decode(base64Text));
  }
}
