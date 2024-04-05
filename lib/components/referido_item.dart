import 'package:flutter/material.dart';

class ReferidoItem extends StatelessWidget {
  final String email;
  final String ganancia;

  const ReferidoItem({super.key, required this.email, required this.ganancia});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      width: double.maxFinite,
      height: 59,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: const Color(0xFF05FF00), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            email,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 13.0,
            ),
          ),
          Text(
            ganancia,
            style: const TextStyle(
              color: Color(0xFF05FF00),
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
            ),
          ),
        ],
      ),
    );
  }
}
