import 'package:bro_app_to/utils/language_localizations.dart';
import 'package:flutter/material.dart';

class LanguageLocalizationsDelegate
    extends LocalizationsDelegate<LanguageLocalizations> {
  const LanguageLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'es', 'it', 'fr', 'de'].contains(locale.languageCode);

  @override
  Future<LanguageLocalizations> load(Locale locale) async {
    final LanguageLocalizations localizations = LanguageLocalizations(locale);

    await localizations.load();

    return localizations;
  }

  @override
  bool shouldReload(LanguageLocalizationsDelegate old) => false;
}
