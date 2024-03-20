import 'package:bro_app_to/Screens/config_profile_player.dart';
import 'package:bro_app_to/Screens/full_screen_image_page.dart';
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
                  icon: const Icon(Icons.settings, color: Color(0xFF00E050)),
                  onPressed: () {
                                        Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ConfigProfilePlayer(),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            const CircleAvatar(
              radius: 80.0,
              backgroundImage: AssetImage('assets/images/jugador.png'),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'NOMBRE Y APELLIDO',
              style: TextStyle(color: Color(0xFF00E050), fontSize: 22.0,fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,),
            ),
            const Text(
              'Datos Futbolista',
              style: TextStyle(color: Colors.white, fontSize: 16.0,fontFamily: 'Montserrat',fontStyle: FontStyle.italic,
                    ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
              height: 4.0, // Barra verde más ancha
              width: double.infinity, // Hace que la barra sea tan ancha como las tres imágenes juntas, incluido el espacio entre ellas
              color: const Color(0xFF00E050),
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
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FullScreenImagePage(imagePath: 'assets/images/jugador1.png'),
                        ),
                      );
                    },
                    child: Image.asset('assets/images/jugador1.png', fit: BoxFit.cover),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
