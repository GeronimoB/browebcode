import 'dart:convert';

import 'package:bro_app_to/Screens/afiliados_player.dart';
import 'package:bro_app_to/Screens/lista_afiliados.dart';
import 'package:bro_app_to/Screens/player/cuenta_player.dart';
import 'package:bro_app_to/Screens/notificaciones.dart';
import 'package:bro_app_to/Screens/player/edit_player_info.dart';
import 'package:bro_app_to/Screens/player/pedidos.dart';
import 'package:bro_app_to/Screens/player/verification.dart';
import 'package:bro_app_to/Screens/privacidad.dart';
import 'package:bro_app_to/Screens/player/servicios.dart';
import 'package:bro_app_to/components/app_bar_title.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/components/snackbar.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/utils/api_constants.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bro_app_to/providers/player_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/verificaciones_afiliados.dart';
import '../../utils/api_client.dart';
import '../../utils/language_localizations.dart';
import 'bottom_navigation_bar_player.dart';
import 'package:http/http.dart' as http;

class ConfigProfilePlayer extends StatefulWidget {
  const ConfigProfilePlayer({super.key});

  @override
  State<ConfigProfilePlayer> createState() => _ConfigProfilePlayerState();
}

class _ConfigProfilePlayerState extends State<ConfigProfilePlayer> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.getCurrentUser();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(height: 22),
            Text(
              '${user.name} ${user.lastName}',
              style: const TextStyle(
                color: Color(0xFF05FF00),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            appBarTitle(translations!["SETTING"]),
          ],
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF05FF00),
            size: 32,
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const CustomBottomNavigationBarPlayer(initialIndex: 4)),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF212121), Color(0xFF121212)],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 22),
                      _buildListItem(translations!['ACCOUNT'], context, true,
                          const CuentaPage()),
                      _buildListItem(translations!['EDIT_INFORMATION'], context,
                          true, const EditarInfoPlayer()),
                      _buildListItem(
                        translations!['change_pss'],
                        context,
                        true,
                        Privacidad(),
                        callback: () {
                          showPassDialog(context);
                        },
                      ),
                      if (!user.verificado)
                        _buildListItem(
                          translations!['verification_profile'],
                          context,
                          true,
                          const VerificationScreen(
                            newUser: false,
                          ),
                        ),
                      const SizedBox(height: 15),
                      _buildListItem(translations!['HelpCenter(FAQ)'], context,
                          false, const ConfigProfilePlayer()),
                      _buildListItem(translations!['Support'], context, false,
                          const ConfigProfilePlayer()),
                      _buildListItem(translations!['Notifications'], context,
                          true, const Notificaciones()),
                      _buildListItem(
                        translations!['Affiliates'],
                        context,
                        true,
                        const AfiliadosPlayer(),
                        callback: () {
                          user.verificadoReferral
                              ? Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          user.referralCode != ""
                                              ? const ListaReferidosScreen()
                                              : const AfiliadosPlayer()),
                                )
                              : showVerificationReferral(context);
                        },
                      ),
                      _buildListItem(translations!['ORDERS'], context, true,
                          const Pedidos()),
                      _buildListItem(translations!['SERVICES'], context, true,
                          const Servicios()),
                      _buildListItem(
                        translations!['Language'],
                        context,
                        true,
                        const Servicios(),
                        callback: () {
                          languageDialog(context);
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildListItem(translations!['DeleteAccount'], context,
                          false, const Servicios(), callback: () {
                        handleDeleteAccount(context);
                      }),
                      _buildListItem(translations!['LogOut'], context, false,
                          const Servicios(), callback: () {
                        handleLogOut(context);
                      }),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  alignment: Alignment.center,
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

  void changeLanguage(BuildContext context, String languageCode) async {
    LanguageLocalizations? localizations = LanguageLocalizations.of(context);
    if (localizations != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', languageCode);
      await localizations.changeLanguage(languageCode);
      setState(() {
        translations = LanguageLocalizations.of(context)!.getJsonTranslate();
      });
    }
  }

  void languageDialog(BuildContext context) {
    String currentLanguage =
        LanguageLocalizations.of(context)?.currentLanguage ?? 'es';
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Center(
                child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xff3B3B3B),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(5, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  languageTile(context, 'en', translations!["english"],
                      currentLanguage == 'en'),
                  languageTile(context, 'es', translations!["spanish"],
                      currentLanguage == 'es'),
                  languageTile(context, 'de', translations!["german"],
                      currentLanguage == 'de'),
                  languageTile(context, 'it', translations!["italian"],
                      currentLanguage == 'it'),
                  languageTile(context, 'fr', translations!["french"],
                      currentLanguage == 'fr'),
                  languageTile(context, 'pt', translations!["portuguese"],
                      currentLanguage == 'pt'),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: CustomTextButton(
                      text: translations!['close'],
                      buttonPrimary: true,
                      width: 120,
                      height: 35,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            )),
          ),
        );
      },
    );
  }

  void handleLogOut(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xff3B3B3B),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(5, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      translations!['AreYouSureYouWantToLogOut'],
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomTextButton(
                        onTap: () => Navigator.of(context).pop(),
                        text: translations!['No'],
                        buttonPrimary: false,
                        width: 90,
                        height: 35,
                      ),
                      CustomTextButton(
                        onTap: () {
                          final playerProvider = Provider.of<PlayerProvider>(
                              context,
                              listen: false);
                          final userProvider =
                              Provider.of<UserProvider>(context, listen: false);

                          playerProvider.logOut();
                          userProvider.logOut();

                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
                        },
                        text: translations!['Yes'],
                        buttonPrimary: true,
                        width: 90,
                        height: 35,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void handleDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(35),
                decoration: BoxDecoration(
                  color: const Color(0xff3B3B3B),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(5, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: double.maxFinite,
                      child: Text(
                        translations!['ConfirmDeleteAccount'],
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomTextButton(
                          onTap: () => Navigator.of(context).pop(),
                          text: 'NO',
                          buttonPrimary: false,
                          width: 90,
                          height: 35,
                        ),
                        CustomTextButton(
                          onTap: () async {
                            final playerProvider = Provider.of<PlayerProvider>(
                                context,
                                listen: false);
                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            final userId = userProvider.getCurrentUser().userId;
                            final url = Uri.parse(
                                '${ApiConstants.baseUrl}/auth/player/$userId');
                            try {
                              final response = await http.delete(url);
                              if (response.statusCode == 200) {
                                playerProvider.logOut();
                                userProvider.logOut();
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/intro', (route) => false);
                              } else {
                                debugPrint(
                                    'Error al eliminar el usuario: ${response.statusCode}');
                              }
                            } catch (error) {
                              debugPrint(
                                  'Error al realizar la solicitud DELETE: $error');
                            }
                          },
                          text: 'SÍ',
                          buttonPrimary: true,
                          width: 90,
                          height: 35,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showPassDialog(BuildContext context) {
    TextEditingController oldPasswordCtlr = TextEditingController();
    TextEditingController newPasswordCtlr = TextEditingController();
    TextEditingController confirmPasswordCtlr = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final formKey2 = GlobalKey<FormState>();
    final formKey3 = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              color: const Color(0xff3B3B3B),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(5, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  translations!['change_pss'],
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Color(0xff00E050),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: formKey,
                  child: TextFormField(
                    controller: oldPasswordCtlr,
                    decoration: InputDecoration(
                      labelText: translations!['old_pss'],
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                      errorStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 106, 106),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF00E050), width: 2),
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors.white, fontFamily: 'Montserrat'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return translations!['please_enter_pss'];
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: formKey2,
                  child: TextFormField(
                    controller: newPasswordCtlr,
                    decoration: InputDecoration(
                      labelText: translations!['new_pss'],
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                      errorStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 106, 106),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF00E050), width: 2),
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors.white, fontFamily: 'Montserrat'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return translations!['enter_password'];
                      }
                      if (value.length < 8) {
                        return translations!['pssw_8_characters'];
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return translations!['pssw_mayus_letter'];
                      }
                      if (!value.contains(RegExp(r'[a-z]'))) {
                        return translations!['pssw_minus_letter'];
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return translations!['pssw_number'];
                      }

                      if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        return translations!['pssw_special'];
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: formKey3,
                  child: TextFormField(
                    controller: confirmPasswordCtlr,
                    decoration: InputDecoration(
                      labelText: translations!['new_pss_confirmation'],
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                      errorStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 106, 106),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF00E050), width: 2),
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors.white, fontFamily: 'Montserrat'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return translations!['enter_password'];
                      }
                      if (value != newPasswordCtlr.text) {
                        return translations!['pss_dont_match'];
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextButton(
                      onTap: () => Navigator.of(context).pop(),
                      text: translations!['cancel'],
                      buttonPrimary: false,
                      width: 90,
                      height: 27,
                    ),
                    CustomTextButton(
                      onTap: () async {
                        final userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        final id =
                            userProvider.getCurrentUser().userId.toString();
                        final response =
                            await ApiClient().post('auth/change-pssw', {
                          "UserId": id,
                          "OldPassword": oldPasswordCtlr.text,
                          "NewPassword": newPasswordCtlr.text
                        });
                        if (response.statusCode == 200) {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString('username', "");
                          prefs.setString('password', "");
                          Navigator.of(context).pop();
                          showSucessSnackBar(
                              context, translations!['update_pss_scss']);
                        } else {
                          final jsonData = json.decode(response.body);
                          final errorMessage = jsonData["error"];
                          Navigator.of(context).pop();
                          showErrorSnackBar(context, errorMessage);
                        }
                      },
                      text: translations!['save'],
                      buttonPrimary: true,
                      width: 90,
                      height: 27,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListItem(
      String title, BuildContext context, bool showTrailingIcon, Widget page,
      {Function? callback}) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: showTrailingIcon
          ? const Icon(Icons.chevron_right, color: Color(0xFF05FF00))
          : null,
      onTap: () {
        if (callback != null) {
          callback.call();
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
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
        width: double.infinity,
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
