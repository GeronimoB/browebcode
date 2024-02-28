import 'package:flutter/material.dart';

class Matche extends StatefulWidget {
  @override
  _MatcheState createState() => _MatcheState();
}

class _MatcheState extends State<Matche> {
  List<bool> _isSelected = [false, false, false]; // Estado de selección de cada tarjeta

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        title: Text('Match', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight:FontWeight.bold)), // Título en blanco y en la fuente Montserrat
        backgroundColor: Colors.transparent, // Fondo transparente, 
        elevation: 0, // Sin sombra
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(height: 20), // Espacio entre el título y el primer componente
            _buildMatchComponent('assets/jugador1.png', 'Nombre Jugador 1', 'Descripción Jugador 1', 0),
            SizedBox(height: 20), // Espacio entre componentes
            _buildMatchComponent('assets/jugador1.png', 'Nombre Jugador 2', 'Descripción Jugador 2', 1),
            SizedBox(height: 20), // Espacio entre componentes
            _buildMatchComponent('assets/jugador1.png', 'Nombre Jugador 3', 'Descripción Jugador 3', 2),
            // Agrega más componentes según sea necesario
          ],
        ),
      ),
    );
  }

  Widget _buildMatchComponent(String imagePath, String playerName, String playerDescription, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected[index] = !_isSelected[index]; // Cambiar el estado de selección al presionar la tarjeta
        });
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0), // Borde redondeado
          border: Border.all(color: Colors.green), // Borde verde en el estado normal
          gradient: _isSelected[index] ? _buildGradient() : null, // Degradado en el estado seleccionado
        ),
        child: Row(
          children: [
            // Imagen del jugador
            CircleAvatar(
              radius: 35.0, // Nuevo tamaño de la imagen
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(width: 10.0),
            // Nombre y descripción del jugador
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playerName,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: _isSelected[index] ? Colors.black : Colors.white, // Texto negro si está seleccionado, de lo contrario, blanco
                  ),
                ),
                Text(
                  playerDescription,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: _isSelected[index] ? Colors.black : Colors.white, // Texto negro si está seleccionado, de lo contrario, blanco
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Función para construir el degradado lineal
  LinearGradient _buildGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF005000), // Verde oscuro
        Color(0xFF00E050), // Verde claro
      ],
    );
  }
}
