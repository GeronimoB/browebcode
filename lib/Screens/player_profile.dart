import 'dart:convert';

import 'package:bro_app_to/Screens/config_profile_player.dart';
import 'package:bro_app_to/Screens/full_screen_video_page.dart';
import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/utils/video_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/api_client.dart';

class PlayerProfile extends StatefulWidget {
  @override
  _PlayerProfileState createState() => _PlayerProfileState();
}

class _PlayerProfileState extends State<PlayerProfile> {
  Map<String, bool> destacadas = {
    'assets/images/jugador1.png': false,
  };

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final userId =
        playerProvider.getPlayer()!.userId; // Obtener el ID del jugador
    try {
      final videosResponse = await ApiClient()
          .get('auth/videos/$userId'); // Realizar la solicitud de videos
      if (videosResponse.statusCode == 200) {
        final jsonData = jsonDecode(videosResponse.body);
        final videos = jsonData["videos"];
        playerProvider.setUserVideos(mapListToVideos(videos));
      } else {
        print('Error al obtener los videos: ${videosResponse.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud de videos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: true);
    final player = playerProvider.getPlayer()!;
    final videos = playerProvider.userVideos;
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
              decoration: const BoxDecoration(
                  color: Color(0xFF00E050),
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
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FullScreenVideoPage(
                              videoPath: video.videoUrl ?? ''),
                        ),
                      );
                    },
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/video_placeholder.jpg',
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/video_placeholder.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                      image: video.imageUrl ?? "",
                      fit: BoxFit.fill,
                    ),
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
