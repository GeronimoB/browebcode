import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:flutter/material.dart';

import 'Chatpage.dart';

class MatchePlayer extends StatefulWidget {
  const MatchePlayer({super.key});

  @override
  _MatcheState createState() => _MatcheState();
}

class _MatcheState extends State<MatchePlayer> {
  final List<bool> _isSelected = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF212121), Color(0xFF121212)],
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 68.0, bottom: 20),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Match',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _isSelected.length,
                itemBuilder: (context, index) {
                  return _buildMatchComponent(
                      'assets/images/jugador1.png',
                      'Nombre entrenador ${index + 1}',
                      'Descripción entrenador ${index + 1}',
                      index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchComponent(String imagePath, String playerName,
      String playerDescription, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Deseleccionar todos los otros elementos
          for (int i = 0; i < _isSelected.length; i++) {
            if (i != index) {
              _isSelected[i] = false;
            }
          }
          // Cambiar el estado del elemento seleccionado actualmente
          _isSelected[index] = !_isSelected[index];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 00),
        curve: Curves.easeInOut,
        height: _isSelected[index]
            ? 260
            : 109, // Ajusta la altura aquí para acomodar el tamaño de la imagen
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              _isSelected[index] ? 50 : 100,
            ),
            border: Border.all(
              color: const Color(0xff00f056),
              width: 1,
            ),
            color: Colors.transparent,
            boxShadow: _isSelected[index]
                ? [
                    const CustomBoxShadow(
                        color: Color(0xff05ff00), blurRadius: 4)
                  ]
                : null),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    imagePath,
                    width: 106,
                    height: 106,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, //
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        playerName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        playerDescription,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_isSelected[index]) ...[
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                    left:
                        16.0), // Asegúrate de que el padding izquierdo coincida con cualquier otro padding que quieras alinear
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Escuela deportiva en la que juega',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                        height:
                            5.0), // Controla el espacio entre los textos ajustando el SizedBox
                    Text(
                      'Logro individuales',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Selección Nacional Masculina 18',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomTextButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            name: 'Entrenador ${index + 1}',
                          ),
                        ),
                      );
                    },
                    text: '¡Vamos al Chat!',
                    buttonPrimary: false,
                    width: 135,
                    height: 32,
                    fontSize: 11,
                  ),
                  CustomTextButton(
                    onTap: () {},
                    text: 'Ver Perfil',
                    buttonPrimary: true,
                    width: 135,
                    height: 32,
                    fontSize: 11,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
