import 'package:bro_app_to/Screens/first_video.dart';
import 'package:flutter/material.dart';

import '../components/custom_text_button.dart';

class SelectCamp extends StatefulWidget {
  const SelectCamp({super.key});

  @override
  SelectCampState createState() => SelectCampState();
}

class SelectCampState extends State<SelectCamp> {
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Fondo
          Positioned.fill(
            child: Image.asset('assets/images/Fondo.png', fit: BoxFit.cover),
          ),
          // Campo con margen superior
          Positioned(
            top: screenSize.height * 0.1,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Campo.png',
              width: screenSize.width,
              height: screenSize.height * 0.6,
              fit: BoxFit.fitWidth,
            ),
          ),
          // Jugador y Número
          Positioned(
            top: screenSize.height * 0.55,
            left: screenSize.width * 0.43,
            child: Image.asset(
              'assets/images/Nro1.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.52,
            left: screenSize.width * 0.85,
            child: Image.asset(
              'assets/images/Nro2.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.52,
            left: screenSize.width * 0.01,
            child: Image.asset(
              'assets/images/Nro3.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.5,
            left: screenSize.width * 0.6,
            child: Image.asset(
              'assets/images/Nro4.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.5,
            left: screenSize.width * 0.26,
            child: Image.asset(
              'assets/images/Nro5.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.45,
            left: screenSize.width * 0.17,
            child: Image.asset(
              'assets/images/Nro6.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.41,
            left: screenSize.width * 0.73,
            child: Image.asset(
              'assets/images/Nro7.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.45,
            left: screenSize.width * 0.67,
            child: Image.asset(
              'assets/images/Nro8.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.41,
            left: screenSize.width * 0.47,
            child: Image.asset(
              'assets/images/Nro9.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.44,
            left: screenSize.width * 0.4,
            child: Image.asset(
              'assets/images/Nro10.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.41,
            left: screenSize.width * 0.1,
            child: Image.asset(
              'assets/images/Nro11.png',
            ),
          ),
          // Contenido debajo del campo
          Positioned(
            top: screenSize.height * 0.7, // Justo debajo de la imagen del campo
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: <Widget>[
                  // Checkbox con términos y condiciones
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _acceptedTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            _acceptedTerms = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _acceptedTerms = !_acceptedTerms;
                            });
                          },
                          child: const Text(
                            'Confirmo y acepto los Términos y Condiciones y he leído la Política de Privacidad',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 8, // Tamaño de fuente más pequeño
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomTextButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FirstVideoWidget()),
                        );
                      },
                      text: 'Siguiente',
                      buttonPrimary: true,
                      width: 116,
                      height: 39),
                  const SizedBox(
                      height:
                          10), // Espacio extra para evitar superposición con el logo
                ],
              ),
            ),
          ),
          // Logo centrado en la parte inferior
          Positioned(
            bottom:
                screenSize.height * 0.03, // Espacio desde el fondo para el logo
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/Logo.png',
                width: 104,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
