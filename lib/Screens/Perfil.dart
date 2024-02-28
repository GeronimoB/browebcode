import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener el ancho de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen, nombre y subtítulo
            Positioned(
              top: 20.0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 208.0,
                  height: 208.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/user.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'Nombre de Usuario',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: Color(0xFF00E050),
              ),
            ),
            Text(
              'Subtítulo',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'Montserrat',
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 100),
            // Tarjetas de jugador
            Container(
              width: screenWidth * 0.9, // Ancho de la tarjeta
              height: 168.0,
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF00E050),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Columna para la imagen del jugador
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40.0,
                        backgroundImage: AssetImage('assets/jugador.png'),
                      ),
                    ],
                  ),
                  SizedBox(width: 20), // Separación entre columnas
                  // Columna para el nombre, descripción y enlace "Perfil"
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nombre del Jugador',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Descripción del Jugador',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          // Acción al hacer clic en el texto "Perfil"
                        },
                        child: Text(
                          'Perfil',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF00E050),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
