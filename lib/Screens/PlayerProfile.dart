import 'package:flutter/material.dart';

class PlayerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double gridSpacing = 4.0; // Espacio más pequeño entre las imágenes

    return Scaffold(
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
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                right: 8.0,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    // Acción para el botón de configuración
                  },
                ),
              ),
            ),
            SizedBox(height: 8.0),
            CircleAvatar(
              radius: 80.0,
              backgroundImage: AssetImage('assets/jugador.png'),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 8.0),
            Text(
              'NOMBRE Y APELLIDO',
              style: TextStyle(color: Colors.white, fontSize: 22.0),
            ),
            Text(
              'Datos Futbolista',
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
              height: 4.0, // Barra verde más ancha
              width: double.infinity, // Hace que la barra sea tan ancha como las tres imágenes juntas, incluido el espacio entre ellas
              color: Colors.green,
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(gridSpacing),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: gridSpacing,
                  mainAxisSpacing: gridSpacing,
                  // El childAspectRatio es aproximado, ajustar según sea necesario
                  childAspectRatio: (MediaQuery.of(context).size.width / 3 - gridSpacing * 2) / 183,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Image.asset('assets/jugador1.png', fit: BoxFit.cover);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
