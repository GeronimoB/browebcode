import 'package:flutter/material.dart';
import 'package:bro_app_to/Sing_in.dart';
import 'package:bro_app_to/Sing_up.dart';

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
              'assets/Background_1.png',
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
                  Image.asset(
                    'assets/Logo.png',
                    width: 239,
                  ),
                  const SizedBox(height: 20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 304,
                    height: 39,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF05FF00)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                        setState(() {
                          isPressedSignIn = !isPressedSignIn;
                          isPressedCreateAccount = false; // Aseguramos que el otro botón no esté presionado
                        });
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      ),
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: isPressedCreateAccount ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 304,
                    height: 39,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF05FF00)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()), 
                      );
                        setState(() {
                          isPressedCreateAccount = !isPressedCreateAccount;
                          isPressedSignIn = false; // Aseguramos que el otro botón no esté presionado
                        });
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(isPressedCreateAccount ? const Color(0xFF00E050) : Colors.transparent),
                      ),
                      child: Text(
                        'Crear Cuenta',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: isPressedCreateAccount ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
