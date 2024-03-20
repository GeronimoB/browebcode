import 'package:flutter/material.dart';

class PerfilDetallePage extends StatelessWidget {
  const PerfilDetallePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
              icon: Icon(Icons.arrow_back, color: Colors.green),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Perfil Jugador Info',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            trailing: SizedBox(width: 24), // To center the title
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 75.0,
                  backgroundImage: AssetImage('path/to/player/image.png'), // Tu imagen de jugador aquí.
                ),
                const SizedBox(height: 16),
                Text(
                  'Nombres y Apellidos',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Fecha de Nacimiento\nPaís, Provincia\nCategoría en la que juega\nEscuela deportiva en la que juega\nLogros individuales\nSelección Nacional Masculina U18',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green),
                  ),
                  onPressed: () {
                    // Acción para ir al chat
                  },
                  child: Text('¡Vamos al Chat!', style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Para mostrar esta vista, usarías algo como esto en tu widget principal:
void _showPerfilDetalle(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return PerfilDetallePage();
    },
    isScrollControlled: true, // Si quieres que la hoja se extienda a toda la pantalla.
  );
}
