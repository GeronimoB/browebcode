import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/MetodoDePagoScreen.dart';
class SelectCamp extends StatefulWidget {
  @override
  _SelectCampState createState() => _SelectCampState();
}

class _SelectCampState extends State<SelectCamp> {
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
            child: Image.asset('assets/Fondo.png', fit: BoxFit.cover),
          ),
          // Campo con margen superior
          Positioned(
            top: screenSize.height * 0.1,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/Campo.png',
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
              'assets/Nro1.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.52,
            left: screenSize.width * 0.85,
            child: Image.asset(
              'assets/Nro2.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.52,
            left: screenSize.width * 0.01,
            child: Image.asset(
              'assets/Nro3.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.5,
            left: screenSize.width * 0.6,
            child: Image.asset(
              'assets/Nro4.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.5,
            left: screenSize.width * 0.26,
            child: Image.asset(
              'assets/Nro5.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.45,
            left: screenSize.width * 0.17,
            child: Image.asset(
              'assets/Nro6.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.41,
            left: screenSize.width * 0.73,
            child: Image.asset(
              'assets/Nro7.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.45,
            left: screenSize.width * 0.67,
            child: Image.asset(
              'assets/Nro8.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.41,
            left: screenSize.width * 0.47,
            child: Image.asset(
              'assets/Nro9.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.44,
            left: screenSize.width * 0.4,
            child: Image.asset(
              'assets/Nro10.png',
            ),
          ),
          Positioned(
            top: screenSize.height * 0.41,
            left: screenSize.width * 0.1,
            child: Image.asset(
              'assets/Nro11.png',
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
                  SizedBox(height: 10),
                  // Botón Siguiente
                  ElevatedButton(
                                      onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MetodoDePagoScreen()),
                    );
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Color del botón
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Tamaño del botón
                    ),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16, // Tamaño de fuente del botón
                        color: Colors.white, // Color del texto del botón
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Espacio extra para evitar superposición con el logo
                ],
              ),
            ),
          ),
          // Logo centrado en la parte inferior
          Positioned(
            bottom: screenSize.height * 0.03, // Espacio desde el fondo para el logo
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/Logo.png',
                width: 104,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
