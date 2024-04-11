import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/src/registration/presentation/screens/select_camp.dart';
import 'package:bro_app_to/src/registration/presentation/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/src/auth/presentation/screens/sign_in.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/current_state.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  bool isPressedSignIn = false;
  bool isPressedCreateAccount = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                'assets/images/Background_1.png',
                fit: BoxFit.fill,
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
                    const SizedBox(height: 35),
                    CustomTextButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()),
                          );
                        },
                        text: translations!['sign_in'],
                        buttonPrimary: false,
                        width: 304,
                        height: 39),
                    const SizedBox(height: 20),
                    CustomTextButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        text: translations!['create_account'],
                        buttonPrimary: true,
                        width: 304,
                        height: 39),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
