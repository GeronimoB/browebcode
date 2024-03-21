import 'package:flutter/material.dart';
import 'package:bro_app_to/components/custom_text_button.dart';

class MatchProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black, // Color de fondo negro
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.maxFinite, // Ocupa todo el ancho disponible
                    height: MediaQuery.of(context).size.height * 0.5, // 50% de la altura de la pantalla
                    child: Image.asset(
                      'assets/images/jugador1.png', // Ruta de la imagen local
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  SizedBox(height: 20),
                  const Text(
                    'Información del Jugador:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // Texto en blanco
                  ),
                  SizedBox(height: 10),
                  _buildInfoRow(context, 'Fecha de Nacimiento:', 'dd/mm/aaaa'),
                  _buildInfoRow(context, 'País, Provincia:', 'País, Provincia'),
                  _buildInfoRow(context, 'Categoría:', 'Categoría en la que juega'),
                  _buildInfoRow(context, 'Escuela Deportiva:', 'lores'),
                  _buildInfoRow(context, 'Logros Individuales:', 'Logros individuales'),
                  _buildInfoRow(context, 'Selección Nacional:', ' Masculina 18'),
                  SizedBox(height: 20),
                  CustomTextButton(
                    onTap: () {}, 
                    text: '¡Vamos al Chat!',
                    buttonPrimary: true,
                    width: 154,
                    height: 39,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top, 
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF00E050)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), // Texto en blanco
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.white), // Texto en blanco
          ),
        ],
      ),
    );
  }
}
