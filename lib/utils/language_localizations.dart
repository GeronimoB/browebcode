import 'dart:convert';

import 'package:bro_app_to/utils/current_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'language_delegate.dart';

class LanguageLocalizations {
  Locale locale;

  LanguageLocalizations(this.locale);

  static LanguageLocalizations? of(BuildContext context) =>
      Localizations.of<LanguageLocalizations>(context, LanguageLocalizations);

  static const LocalizationsDelegate<LanguageLocalizations> delegate =
      LanguageLocalizationsDelegate();

  Map<String, dynamic>? _localizedStrings;

  Future<bool> load() async {
    final String jsonString = await rootBundle
        .loadString('assets/language/${locale.languageCode}/strings.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    _localizedStrings = jsonMap.map(
        (String key, dynamic value) => MapEntry<String, dynamic>(key, value));

    return true;
  }

  String? translate(String key) => _localizedStrings![key];

  Map<String, dynamic>? getJsonTranslate() => _localizedStrings;

  String get currentLanguage => locale.languageCode;

  Future<void> changeLanguage(String languageCode) async {
    final newLocale = Locale(languageCode);
    locale = newLocale;
    await load();
  }
}
