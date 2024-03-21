import 'package:bro_app_to/Screens/config_profile_player.dart';
import 'package:bro_app_to/Screens/full_screen_image_page.dart';
import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerProfile extends StatefulWidget {
  @override
  _PlayerProfileState createState() => _PlayerProfileState();
}

class _PlayerProfileState extends State<PlayerProfile> {
  Map<String, bool> destacadas = {
    'assets/images/jugador1.png': false,
  };

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    final player = playerProvider.getPlayer()!;
    double gridSpacing = 4.0;
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
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 15.0),
            ClipOval(
              child: FadeInImage.assetNetwork(
                placeholder:
                    'assets/images/fot.png', // Placeholder mientras se carga la imagen
                imageErrorBuilder: (context, error, stackTrace) {
                  // Widget de fallback en caso de que la imagen falle al cargar
                  return Image.asset(
                    'assets/images/fot.png', // Imagen de fallback
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover, // Ajuste de la imagen
                  );
                },
                image: player.userImage ?? "", // URL de la imagen
                width: 80,
                height: 80,
                fit: BoxFit.cover, // Ajuste de la imagen
              ),
            ),
            const SizedBox(height: 15.0),
            Text(
              '${player.name} ${player.lastName}',
              style: const TextStyle(
                color: Color(0xFF00E050),
                fontSize: 22.0,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '${player.pais}, ${player.provincia} - ${player.club} - ${player.categoria}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15.0),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              height: 4.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color(0xFF00E050),
                  boxShadow: [
                    CustomBoxShadow(color: Color(0xFF05FF00), blurRadius: 4)
                  ]),
            ),
            const SizedBox(height: 15.0),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(gridSpacing),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: gridSpacing,
                  mainAxisSpacing: gridSpacing,
                  childAspectRatio: (MediaQuery.of(context).size.width / 3 -
                          gridSpacing * 2) /
                      183,
                ),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FullScreenImagePage(
                              imagePath: 'assets/images/jugador1.png'),
                        ),
                      );
                    },
                    child: Image.asset('assets/images/jugador1.png',
                        fit: BoxFit.cover),
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
