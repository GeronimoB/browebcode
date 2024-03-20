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
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 44, 44, 44),
                  Color.fromARGB(255, 0, 0, 0),
                ],
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
            top: screenSize.height * 0.1,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Color.fromARGB(255, 40, 40, 40),
                    Color.fromARGB(0, 43, 43, 43),
                  ],
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: 394,
            ),
          ),
          playerPic(
            "Portero",
            "1",
            screenSize.height * 0.55,
            screenSize.width * 0.43,
          ),
          playerPic(
            "Lateral Derecho",
            "2",
            screenSize.height * 0.52,
            screenSize.width * 0.85,
          ),
          playerPic(
            "Lateral Izquierdo",
            "3",
            screenSize.height * 0.52,
            screenSize.width * 0.01,
          ),
          playerPic(
            "Defensa Central",
            "4",
            screenSize.height * 0.5,
            screenSize.width * 0.6,
          ),
          playerPic(
            "Defensa Central",
            "5",
            screenSize.height * 0.5,
            screenSize.width * 0.26,
          ),
          playerPic(
            "Mediocampista Defensivo",
            "6",
            screenSize.height * 0.45,
            screenSize.width * 0.17,
          ),
          playerPic(
            "Mediocampista Derecho",
            "7",
            screenSize.height * 0.41,
            screenSize.width * 0.73,
          ),
          playerPic(
            "Mediocampista Central",
            "8",
            screenSize.height * 0.45,
            screenSize.width * 0.67,
          ),
          playerPic(
            "Delantero Centro",
            "9",
            screenSize.height * 0.40,
            screenSize.width * 0.475,
          ),
          playerPic(
            "Delantero Centro",
            "10",
            screenSize.height * 0.44,
            screenSize.width * 0.4,
          ),
          playerPic(
            "Extremo Izquierdo",
            "11",
            screenSize.height * 0.41,
            screenSize.width * 0.1,
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
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _acceptedTerms = !_acceptedTerms;
                            });
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: 'Confirmo y acepto los ',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'Términos y Condiciones y he leído la Política de Privacidad.',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
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
    bool? isSelected;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23)),
              backgroundColor: const Color(0xFF3B3B3B),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "¿Eres $position?",
                    style: const TextStyle(
                        color: Color(0xff00E050),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio<bool>(
                        value: true,
                        groupValue: isSelected,
                        onChanged: (bool? value) {
                          // Actualiza el estado para reflejar la nueva selección
                          setState(() => isSelected = value);
                        },
                        activeColor: const Color(0xff00E050),
                      ),
                      const Text("SÍ",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      const SizedBox(width: 25),
                      Radio<bool>(
                        value: false,
                        groupValue: isSelected,
                        onChanged: (bool? value) {
                          // Actualiza el estado para reflejar la nueva selección
                          setState(() => isSelected = value);
                        },
                        activeColor: const Color(0xff00E050),
                      ),
                      const Text("NO",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ],
                  ),
                  CustomTextButton(
                      onTap: () {
                        Navigator.of(context).pop(isSelected);
                      },
                      text: "Listo",
                      buttonPrimary: true,
                      width: 174,
                      height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget playerPic(String position, String number, double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () {
          _showPositionDialog(position);
        },
        child: Column(
          children: [
            Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(17.5)),
                child: Center(
                  child: Text(
                    number,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 1,
                        height: 1),
                  ),
                )),
            Image.asset(
              'assets/images/football-player 1.png',
            ),
          ],
        ),
      ),
    );
  }
}
