import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/language_localizations.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  void changeLanguage(BuildContext context, String languageCode) async {
    LanguageLocalizations? localizations = LanguageLocalizations.of(context);
    if (localizations != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', languageCode);
      localizations.changeLanguage(languageCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage =
        LanguageLocalizations.of(context)?.currentLanguage ?? 'es';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'IDIOMA',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF05FF00),
            size: 32,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF212121), Color(0xFF121212)],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: [
            languageTile(context, 'en', 'English', currentLanguage == 'en'),
            languageTile(context, 'es', 'Español', currentLanguage == 'es'),
            languageTile(context, 'de', 'Aleman', currentLanguage == 'de'),
            languageTile(context, 'it', 'Italiano', currentLanguage == 'it'),
            languageTile(context, 'fr', 'Frances', currentLanguage == 'fr'),
          ],
        ),
      ),
    );
  }

  Widget languageTile(
      BuildContext context, String languageCode, String language, bool select) {
    return InkWell(
      onTap: () {
        changeLanguage(context, languageCode);
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: select ? const Color(0xFF00F056) : Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          language,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
