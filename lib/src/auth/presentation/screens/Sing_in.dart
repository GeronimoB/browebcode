import 'package:bro_app_to/providers/player_provider.dart';
import 'package:bro_app_to/src/registration/presentation/screens/select_camp.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/agent/bottom_navigation_bar.dart';
import 'package:bro_app_to/Screens/olvide_contrasena.dart';
import 'package:bro_app_to/Screens/player_profile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../components/custom_text_button.dart';
import '../../../../injection_container.dart';
import '../../../../utils/current_state.dart';
import '../../../registration/presentation/screens/Sing_up.dart';
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

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: true);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 19, 12, 12),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/Background_2.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
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
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: translations!['user_or_email'],
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00E050), width: 2),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00E050), width: 2),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: translations!['password'],
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00E050), width: 2),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00E050), width: 2),
                    ),
                  ),
                  obscureText: true,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat'),
                ),
                Align(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => OlvideContrasenaPage()),
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
                  height: 5,
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
                      fillColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(
                                0xff00E050); // Color cuando está seleccionado
                          }
                          return Colors
                              .white; // Color por defecto (fondo blanco)
                        },
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Bordes redondeados
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SelectCamp(registrando: true)),
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
          if (playerProvider.isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black
                  .withOpacity(0.5), // Color de fondo semitransparente
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                ),
              ),
            ),
        ],
      )),
    );
  }
}
