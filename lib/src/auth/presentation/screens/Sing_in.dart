import 'package:bro_app_to/providers/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/agent/bottom_navigation_bar.dart';
import 'package:bro_app_to/olvide_contrasena.dart';
import 'package:bro_app_to/Screens/player_profile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../components/custom_text_button.dart';
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
    return Scaffold(
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
              const Text(
                'Identifícate',
                style: TextStyle(
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
                decoration: const InputDecoration(
                  labelText: 'Usuario/Correo',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00E050), width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00E050), width: 2),
                  ),
                ),
                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00E050), width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00E050), width: 2),
                  ),
                ),
                obscureText: true,
                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
              ),
              Align(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => OlvideContrasenaPage()),
                    );
                  },
                  child: const Text(
                    '¿Se te ha olvidado la contraseña?',
                    style: TextStyle(
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
                        context);
                  },
                  text: 'Entrar',
                  buttonPrimary: true,
                  width: 100,
                  height: 39),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Recordar sesión',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                    ),
                  ),
                  Checkbox(
                    value:
                        rememberMe, // Deberías manejar el estado del checkbox en tu lógica
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
                        return Colors.white; // Color por defecto (fondo blanco)
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
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          ),
      ],
    ));
  }
}
