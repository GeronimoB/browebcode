import 'package:flutter/material.dart';

import 'custom_box_shadow.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool buttonPrimary;
  final double width;
  final double height;
  const CustomTextButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.buttonPrimary,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: buttonPrimary
              ? const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 180, 64),
                    Color.fromARGB(255, 0, 225, 80),
                    Color.fromARGB(255, 0, 178, 63),
                  ], // Colores de tu gradiente
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: Color.fromARGB(255, 0, 224, 80), width: 2),
          boxShadow: [
            buttonPrimary
                ? const BoxShadow(
                    color: Color.fromARGB(255, 0, 224, 80),
                    blurRadius: 2,
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                    blurStyle: BlurStyle.normal)
                : const CustomBoxShadow(
                    color: Color.fromARGB(255, 0, 224, 80),
                    offset: Offset(0, 0),
                  ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: buttonPrimary ? Colors.black : Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
