import 'package:bro_app_to/components/i_field.dart';
import 'package:bro_app_to/providers/player_provider.dart';
import 'package:bro_app_to/src/registration/presentation/screens/select_camp.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/olvide_contrasena.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../components/custom_text_button.dart';
import '../../../../utils/current_state.dart';
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
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background_2.png'),
            fit: BoxFit.cover,
          ),
          color: Color.fromARGB(255, 19, 12, 12),
        ),
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  color: Colors.grey,
                  icon: const Icon(
                    Icons.question_mark,
                    color: Color(0xFF00E050),
                    size: 32,
                  ),
                  onPressed: () {},
                ),
              ],
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            extendBody: true,
            body: Stack(
              children: [
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
                      iField(emailController, translations!['user_or_email']),
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
                            borderSide:
                                BorderSide(color: Color(0xFF00E050), width: 2),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xFF00E050), width: 2),
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
                                if (states.contains(MaterialState.selected)) {
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
                              builder: (context) => const SignInScreen()),
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
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                      ),
                    ),
                  ),
              ],
            )),
      ),
    );
  }
}
