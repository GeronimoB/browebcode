import 'package:flutter/material.dart';

class OlvideContrasenaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Color de fondo detrás de la imagen
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Fondo_oc.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(height: 400), // You may adjust this as needed
            const Text(
              'Recuperación de Cuenta',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Te enviaremos un correo electrónico con un enlace con el que ingresarás de inmediato.',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w600, // SemiBoldItalic
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                // Add your onPressed code here
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 2.0, color: Colors.greenAccent), // Borde en verde neón
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text(
                'Recuperar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 50), // You may adjust this as needed
            SizedBox(
              width: 100,
              height: 49,
              child: Image.asset('assets/Logo.png'), // Tamaño del logo ajustado
            ),
            const SizedBox(height: 10), // You may adjust this as needed
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: OlvideContrasenaPage()));
