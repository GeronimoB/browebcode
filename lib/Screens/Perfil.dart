import 'package:bro_app_to/Screens/config_profile.dart';
import 'package:bro_app_to/providers/agent_provider.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/perfil_detalle_page.dart';
import 'package:provider/provider.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final provider = Provider.of<AgenteProvider>(context, listen: true);
    final agente = provider.getAgente();
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
            Stack(
              alignment: Alignment.topRight,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 90.0,
                    backgroundImage: AssetImage('assets/images/user.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.settings, color: Color(0xFF00E050)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ConfigProfile(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              agente.usuario!,
              style: const TextStyle(
                color: Color(0xff05FF00),
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            Text(
              '${agente.provincia}, ${agente.pais}',
              style: const TextStyle(
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
