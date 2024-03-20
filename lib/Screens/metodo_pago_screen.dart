import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/agregar_tarjeta_screen.dart';

class MetodoDePagoScreen extends StatelessWidget {
  const MetodoDePagoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double metodoPagoWidth = 341.0;
    const double metodoPagoHeight = 106.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF212121), Color(0xFF121212)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'MÉTODO DE PAGO',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF00E050)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  '00,00€',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF00E050), 
                    fontSize: 40,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AgregarTarjetaScreen()),
                  );
                },
                child: Image.asset(
                  'assets/images/visa.png',
                  width: metodoPagoWidth,
                  height: metodoPagoHeight,
                ),
              ),
              const SizedBox(height: 26),
              Image.asset(
                'assets/images/Transfencias.png',
                width: metodoPagoWidth,
                height: metodoPagoHeight,
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/images/Logo.png',
                  width: 80,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
