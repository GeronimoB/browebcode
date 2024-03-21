import 'package:flutter/material.dart';

class PerfilDetallePage extends StatelessWidget {
  const PerfilDetallePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF00E050)),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Perfil Jugador Info',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            trailing: const SizedBox(width: 24), // To center the title
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const CircleAvatar(
                  radius: 75.0,
                  backgroundImage: AssetImage(
                      'path/to/player/image.png'), // Tu imagen de jugador aquí.
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nombres y Apellidos',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Fecha de Nacimiento\nPaís, Provincia\nCategoría en la que juega\nEscuela deportiva en la que juega\nLogros individuales\nSelección Nacional Masculina U18',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                  ),
                  onPressed: () {
                    // Acción para ir al chat
                  },
                  child: const Text('¡Vamos al Chat!',
                      style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

