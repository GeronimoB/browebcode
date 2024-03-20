import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/metodo_de_pago_screen.dart';
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
          Positioned.fill(
            child: Image.asset('assets/images/Fondo.png', fit: BoxFit.cover),
          ),
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
          Positioned(
            top: screenSize.height * 0.55,
            left: screenSize.width * 0.43,
            child: GestureDetector(
              onTap: () => _showPositionDialog("Portero"),
              child: Image.asset(
                'assets/images/Nro1.png',
              ),
            ),
          ),
          Positioned(
            top: screenSize.height * 0.52,
            left: screenSize.width * 0.85,
            child: GestureDetector(
              onTap: () => _showPositionDialog("Lateral Derecho"),
            child: Image.asset(
              'assets/images/Nro2.png',
            ),
          ),
          ),
          Positioned(
            top: screenSize.height * 0.52,
            left: screenSize.width * 0.01,
            child: GestureDetector(
              onTap: () => _showPositionDialog("Lateral Izquierdo"),
            child: Image.asset(
              'assets/images/Nro3.png',
            ),
          ),
          ),
          Positioned(
            top: screenSize.height * 0.5,
            left: screenSize.width * 0.6,
            child: GestureDetector(
              onTap: () => _showPositionDialog("Defensa Central"),
            child: Image.asset(
              'assets/images/Nro4.png',
            ),
          ),
          ),
          Positioned(
            top: screenSize.height * 0.5,
            left: screenSize.width * 0.26,
            child: GestureDetector(
              onTap: () => _showPositionDialog("Defensa Central"),
            child: Image.asset(
              'assets/images/Nro5.png',
            ),
          ),
          ),
          Positioned(
            top: screenSize.height * 0.45,
            left: screenSize.width * 0.17,
            child: GestureDetector(
              onTap: () => _showPositionDialog("Mediocampista Defensivo"),
            child: Image.asset(
              'assets/images/Nro6.png',
            ),
          ),
          ),
          Positioned(
            top: screenSize.height * 0.41,
            left: screenSize.width * 0.73,
            child: GestureDetector(
              onTap: () => _showPositionDialog("Mediocampista Derecho"),
            child: Image.asset(
              'assets/images/Nro7.png',
            ),
          ),
          ),
          Positioned(
            top: screenSize.height * 0.45,
            left: screenSize.width * 0.67,
            child: GestureDetector(
              onTap: () => _showPositionDialog("Mediocampista Central"),
            child: Image.asset(
              'assets/images/Nro8.png',
            ),
          ),
          ),
          Positioned(
            top: screenSize.height * 0.41,
            left: screenSize.width * 0.47,
            child: GestureDetector(
              onTap: () => _showPositionDialog("Delantero Centro"),
            child: Image.asset(
              'assets/images/Nro9.png',
            ),
          ),
          ),
          Positioned(
            top: screenSize.height * 0.44,
            left: screenSize.width * 0.4,
            child: GestureDetector(
              onTap: () => _showPositionDialog("Mediocampista Ofensivo"),
            child: Image.asset(
              'assets/images/Nro10.png',
            ),
          ),
          ),
          Positioned(
            top: screenSize.height * 0.41,
            left: screenSize.width * 0.1,
            child: GestureDetector(
              onTap: () => _showPositionDialog("Extremo Izquierdo"),
            child: Image.asset(
              'assets/images/Nro11.png',
            ),
          ),
          ),
          Positioned(
            top: screenSize.height * 0.7,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: <Widget>[
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
                              fontSize: 8, 
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                                      onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MetodoDePagoScreen()),
                    );
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), 
                ],
              ),
            ),
          ),
 
          Positioned(
            bottom: screenSize.height * 0.03, 
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


void _showPositionDialog(String position) {
  // Debería ser una variable de estado para que pueda actualizar la interfaz de usuario cuando cambie
  bool? isSelected;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: const Color(0xFF3B3B3B),
            title: Text(
              "¿Eres $position?",
              style: const TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("SÍ", style: TextStyle(color: Colors.white)),
                    Radio<bool>(
                      value: true,
                      groupValue: isSelected,
                      onChanged: (bool? value) {
                        // Actualiza el estado para reflejar la nueva selección
                        setState(() => isSelected = value);
                      },
                      activeColor: Colors.green,
                    ),
                    const Text("NO", style: TextStyle(color: Colors.white)),
                    Radio<bool>(
                      value: false,
                      groupValue: isSelected,
                      onChanged: (bool? value) {
                        // Actualiza el estado para reflejar la nueva selección
                        setState(() => isSelected = value);
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 20), 
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, 
                    shape: const StadiumBorder(), 
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(isSelected); 
                  },
                  child: const Text(
                    "Listo",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

}
