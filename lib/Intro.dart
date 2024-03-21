import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/src/auth/presentation/screens/Sing_in.dart';
import 'package:bro_app_to/sing_up.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bro_app_to/Screens/player_profile.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isPressedSignIn = false;
  bool isPressedCreateAccount = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(255, 0, 0, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/Background_1.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   SvgPicture.asset(
                    width: 239,
                    height: 117,
                    fit: BoxFit.fill,
                    'assets/icons/Logo.svg',
                  ),
                  const SizedBox(height: 20),
                  CustomTextButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()),
                        );
                      },
                      text: 'Iniciar Sesión',
                      buttonPrimary: false,
                      width: 304,
                      height: 39),
                  const SizedBox(height: 20),
                  CustomTextButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        );
                      },
                      text: 'Crear Cuenta',
                      buttonPrimary: true,
                      width: 304,
                      height: 39),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
