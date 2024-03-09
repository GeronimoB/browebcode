import 'package:flutter/material.dart';

class Matche extends StatefulWidget {
  const Matche({super.key});

  @override
  _MatcheState createState() => _MatcheState();
}

class _MatcheState extends State<Matche> {
  final List<bool> _isSelected = [false, false, false]; // Estado de selección de cada tarjeta

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fondo gris oscuro
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF212121), Color(0xFF121212)], // Gradiente de gris más oscuro a negro
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 68.0, bottom: 20),
              child: Align(
                alignment: Alignment.center,
                child: Text('Match',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _isSelected.length,
                itemBuilder: (context, index) {
                  return _buildMatchComponent('assets/jugador1.png', 'Nombre Jugador ${index + 1}', 'Descripción Jugador ${index + 1}', index);
                },
              ),
            ),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: _isSelected[index] ? 260 : 100, 
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: MediaQuery.of(context).size.width * 0.95, // Ancho del 95%
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0), // Borde redondeado
          border: Border.all(
            color: Colors.green,
            width: 2.0,
          ),
          color: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 35.0,
                backgroundImage: AssetImage(imagePath),
              ),
              title: Text(
                playerName,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                playerDescription,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
            if (_isSelected[index]) ...[
              const Expanded(
                child: Text(
                  'Aquí va la descripción extendida del jugador...',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implementar funcionalidad para "Vamos al Chat"
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.green, // foreground
                    ),
                    child: const Text('¡Vamos al Chat!'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implementar funcionalidad para "Ver Perfil"
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.green, // foreground
                    ),
                    child: const Text('Ver Perfil'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
