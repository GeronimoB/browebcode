import 'package:flutter/material.dart';

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
    return Container(
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
              : const _CustomBoxShadow(
                  color: Color.fromARGB(255, 0, 224, 80),
                  blurRadius: 3,
                  offset: Offset(0, 0),
                ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
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

class _CustomBoxShadow extends BoxShadow {
  const _CustomBoxShadow({
    Color color = Colors.black,
    Offset offset = Offset.zero,
    double blurRadius = 20.0,
    BlurStyle blurStyle = BlurStyle.outer,
  }) : super(
          color: color,
          offset: offset,
          blurRadius: blurRadius,
          blurStyle: blurStyle,
        );

  @override
  Paint toPaint() {
    final result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) {
        result.maskFilter = null;
      }
      return true;
    }());
    return result;
  }
}
