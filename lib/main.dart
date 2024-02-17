import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bro_app_to/Intro.dart'; // Asegúrate de importar correctamente tu archivo Intro.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MySplashScreen(), // Cambio a la pantalla de introducción
      debugShowCheckedModeBanner: false,
    );
  }
}

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black, // Color negro en la parte inferior
              Colors.grey[900]!, // Color negro un poco más claro arriba
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/Logo.png', // Nombre de la imagen del logo
            width: 246, // Ancho del logo
            height: 117, // Alto del logo
          ),
        ),
      ),
    );
  }
}
