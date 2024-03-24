import 'dart:convert';

import 'package:bro_app_to/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/custom_box_shadow.dart';
import '../providers/player_provider.dart';
import '../providers/user_provider.dart';
import '../utils/api_client.dart';
import '../utils/video_model.dart';
import 'player/bottom_navigation_bar_player.dart';
import 'player/config_profile_player.dart';
import 'player/full_screen_video_page.dart';

class PlayerProfile extends StatefulWidget {
  @override
  _PlayerProfileState createState() => _PlayerProfileState();
}

class _PlayerProfileState extends State<PlayerProfile> {
  double gridSpacing = 4.0;
  bool _isExpanded = false; 

  @override
  void initState() {
    fetchVideos();
    super.initState();
  }

  Future<void> fetchVideos() async {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final userId = playerProvider.getPlayer()!.userId;
    try {
      final videosResponse = await ApiClient().get('auth/videos/$userId');
      print(videosResponse.body);
      if (videosResponse.statusCode == 200) {
        final jsonData = jsonDecode(videosResponse.body);
        final videos = jsonData["videos"];
        playerProvider.setUserVideos(mapListToVideos(videos));
      } else {
        playerProvider.setUserVideos([]);
        print('Error al obtener los videos: ${videosResponse.statusCode}');
      }
    } catch (e) {
      playerProvider.setUserVideos([]);
      print('Error en la solicitud de videos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: true);
    final player = playerProvider.getPlayer()!;
    final videos = playerProvider.userVideos;
    final widthVideo = MediaQuery.of(context).size.width / 3;
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final user = userProvider.getCurrentUser();
    String shortInfo = '${player.name} ${player.lastName}\n${player.provincia}, ${player.pais}';
    String fullInfo = '${player.name} ${player.lastName}\n${player.provincia}, ${player.pais}\n${player.club}\n${player.altura} cm\n${player.pieDominante}\n${player.seleccionNacional}\n${player.position}\n${player.categoria}\n${player.logrosIndividuales}';

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
            if (user.imageUrl != '')
              ClipOval(
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/fot.png',
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/fot.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    );
                  },
                  image: user.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            if (user.imageUrl == '')
              ClipOval(
                child: Image.asset(
                  'assets/images/fot.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
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
              _isExpanded ? fullInfo : shortInfo, 
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded; 
                });
              },
              child: Text(
                _isExpanded ? 'Ver menos' : 'Ver más',
                style: const TextStyle(
                  color: Color(0xFF05FF00),
                  fontSize: 16.0,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
              height: 4.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color(0xFF00E050),
                  boxShadow: [
                    CustomBoxShadow(color: Color(0xFF05FF00), blurRadius: 4)
                  ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: gridSpacing,
                    mainAxisSpacing: gridSpacing,
                    childAspectRatio: (widthVideo - gridSpacing * 2) / 183,
                  ),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                FullScreenVideoPage(video: video, index: index),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          FadeInImage.assetNetwork(
                            placeholder: 'assets/images/video_placeholder.jpg',
                            placeholderFit: BoxFit.fill,
                            placeholderCacheHeight: 175,
                            placeholderCacheWidth: widthVideo.toInt(),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/video_placeholder.jpg',
                                height: 175,
                                width: widthVideo,
                                fit: BoxFit.cover,
                              );
                            },
                            image: video.imageUrl ?? "",
                            width: widthVideo,
                            height: 175,
                            fit: BoxFit.fill,
                          ),
                          if (video
                              .isFavorite) // Mostrar estrella si el video está destacado
                            const Positioned(
                              top: 8.0,
                              right: 8.0,
                              child: Icon(
                                Icons.star,
                                color: Color(0xFF05FF00),
                                size: 24.0,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
