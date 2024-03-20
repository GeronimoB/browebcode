import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/perfil_detalle_page.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[850]!, Colors.black],
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).padding.top + 20),
            const CircleAvatar(
              radius: 90.0,
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Nombre de Usuario',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const Text(
              'Subtítulo',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 0),
            jugadorCard(screenWidth, 'Nombre del Jugador',
                'assets/images/jugador1.png'),
            jugadorCard(screenWidth, 'Nombre del Jugador',
                'assets/images/jugador1.png'),
          ],
        ),
      ),
    );
  }

  Widget jugadorCard(
      double screenWidth, String nombreJugador, String imageAsset) {
    return Container(
      height: 168.0,
      margin:
          EdgeInsets.symmetric(vertical: 5.0, horizontal: screenWidth * 0.05),
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Colors.green, width: 2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      imageAsset,
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombreJugador,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Descripción del Jugador',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          child: const Text(
                            'Ver Perfil...',
                            style: TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onPressed: () {
                            PerfilDetallePage;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
