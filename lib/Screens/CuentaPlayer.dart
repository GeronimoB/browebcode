import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:provider/provider.dart';
import 'package:bro_app_to/providers/user_provider.dart';

class CuentaPage extends StatefulWidget {
  @override
  _CuentaPageState createState() => _CuentaPageState();
}

class _CuentaPageState extends State<CuentaPage> {
  bool deslizadorActivado = true; // Estado del deslizador

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    final player = playerProvider.getPlayer()!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Para quitar la sombra debajo del AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF05FF00)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF212121), Color(0xFF121212)],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 20),
            const Text(
              'CUENTA',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 181,
              height: 181,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/jugador.png',
                    width: 181,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
             Text(
              '${player.name} ${player.lastName}',
              style: const TextStyle(
                color: Color(0xFF05FF00),
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
             Text(
              '${player.pais}, ${player.provincia} - ${player.club} - ${player.categoria}',
              style: const TextStyle(
                color: Colors.grey,
                fontFamily: 'Montserrat',
                fontSize: 16,
              ),
            ),
            CarouselSlider(
  options: CarouselOptions(
    height: 300.0,
    enlargeCenterPage: true,
    autoPlay: true,
    autoPlayCurve: Curves.fastOutSlowIn,
    enableInfiniteScroll: true,
    autoPlayAnimationDuration: const Duration(milliseconds: 800),
    viewportFraction: 0.8,
  ),
  items: [
    {
      'nombre': 'Gold',
      'descripcion': 'La mejor opción para ti. Incluye funciones avanzadas y soporte premium.',
    },
    {
      'nombre': 'Silver',
      'descripcion': 'Económico y efectivo. Ideal para usuarios intermedios que ',
    },
    {
      'nombre': 'Bronze',
      'descripcion': 'Comienza con nosotros. Perfecto para principiantes que desean ',
    },
    // Agrega más mapas a la lista para más tarjetas...
  ].map((plan) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: 360, // Ancho de la tarjeta
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Color(0xFF05FF00)),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 26,
                left: 26,
                child: Image.asset('assets/images/Logo.png', width: 100),
              ),
              Positioned(
                top: 36,
                right: 36,
                child: Text(
                  plan['nombre']!, // Nombre del plan
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF05FF00),
                  ),
                ),
              ),
              Positioned(
                top: 80,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Que incluye:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      plan['descripcion']!, // Descripción del plan
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: null, // Permite múltiples líneas
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF05FF00),
                      ),
                      child: const Text('Ver más...'),
                    ),
                    Center(
                      child: CustomTextButton(
                      onTap: () {}, // No se necesita ninguna acción
                      text: 'Adquirir', // Agrega el texto "Adquirir"
                      buttonPrimary: true, // Utiliza el estilo primario
                      width: 90, height: 30,
                    ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }).toList(),
),

            const SizedBox(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Image.asset(
                    'assets/images/Logo.png',
                    width: 104,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
