import 'package:bro_app_to/components/i_field.dart';
import 'package:bro_app_to/providers/player_provider.dart';
import 'package:bro_app_to/src/registration/presentation/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/olvide_contrasena.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import '../../../../components/custom_text_button.dart';
import '../../../../utils/current_state.dart';
import '../../../../utils/language_localizations.dart';
import '../../data/datasources/remote_data_source_impl.dart';
import '../../domain/entitites/user_entity.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool rememberMe = false;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isLoading = false;
  bool obscureText = true;
  bool _showAlert = false;
  String storeUrl = 'https://play.google.com/store';
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    showPlatformToast();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showPlatformToast() async {
    String userAgent = html.window.navigator.userAgent;

    if (userAgent.contains('Android')) {
      setState(() {
        _showAlert = true;
        storeUrl = 'https://play.google.com/store';
      });
    } else if (userAgent.contains('iPhone') || userAgent.contains('iPad')) {
      setState(() {
        _showAlert = true;
        storeUrl = 'https://www.apple.com/app-store/';
      });
    }
  }

  Future<bool> launchAction(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  void _closeAlert() {
    setState(() {
      _showAlert = false;
    });
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
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
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
                    text: translations!["close"],
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
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: true);
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/Background_2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height -
                          (MediaQuery.of(context).padding.top + 40),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            translations!['identify'],
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          iField(
                              emailController, translations!['user_or_email']),
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: translations!['password'],
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF00E050), width: 2),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF00E050), width: 2),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                              ),
                            ),
                            obscureText: obscureText,
                            style: const TextStyle(
                                color: Colors.white, fontFamily: 'Montserrat'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OlvideContrasenaPage()),
                              );
                            },
                            child: Text(
                              translations!['forget_pass_mssg'],
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextButton(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                RemoteDataSourceImpl(playerProvider).signIn(
                                    UserEntity(
                                        username: emailController.text,
                                        password: passwordController.text),
                                    context,
                                    rememberMe,
                                    false);
                              },
                              text: translations!['enter'],
                              buttonPrimary: true,
                              width: 100,
                              height: 39),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                translations!['remember_session'],
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white,
                                ),
                              ),
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = !rememberMe;
                                  });
                                },
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return const Color(0xff00E050);
                                    }
                                    return Colors.white;
                                  },
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()),
                            ),
                            child: RichText(
                                text: TextSpan(
                              text: translations!['if_you_dn_acct'],
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                    text: translations!['register_here'],
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline)),
                              ],
                            )),
                          ),
                          SizedBox(
                            height: 90,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SvgPicture.asset(
                                width: 104,
                                'assets/icons/Logo.svg',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          languageDialog(context);
                        },
                        child: const Icon(
                          Icons.language,
                          color: Color(0xff00E050),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  if (_showAlert)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xff3B3B3B),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: _closeAlert,
                                  child: const Icon(
                                    Icons.close,
                                    size: 24,
                                    color: Color(0xFF00E050),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/logo_tiendas.png',
                                    width: 55,
                                    height: 55,
                                  ),
                                ),
                                const Text(
                                  "Bró Football Platform",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat',
                                  ),
                                  maxLines: 2,
                                ),
                                CustomTextButton(
                                  text: 'Abrir',
                                  buttonPrimary: true,
                                  width: 65,
                                  height: 32,
                                  onTap: () => launchAction(storeUrl),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (playerProvider.isLoading)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black
                          .withOpacity(0.5), // Color de fondo semitransparente
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                        ),
                      ),
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
