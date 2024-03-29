import 'dart:convert';

import 'package:bro_app_to/Screens/player/full_screen_video_page.dart';
import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/providers/player_provider.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/src/registration/data/models/player_full_model.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:bro_app_to/utils/video_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerProfileToAgent extends StatefulWidget {
  final PlayerFullModel player;

  const PlayerProfileToAgent({super.key, required this.player});

  @override
  _PlayerProfileToAgentState createState() => _PlayerProfileToAgentState();
}

class _PlayerProfileToAgentState extends State<PlayerProfileToAgent> {
  double gridSpacing = 4.0;
  bool _isExpanded = false;
  List<Video> videosUsuario = [];

  @override
  void initState() {
    fetchVideos();
    super.initState();
  }

  Future<void> fetchVideos() async {
    final userId = widget.player.userId;
    try {
      final videosResponse = await ApiClient().get('auth/videos/$userId');
      if (videosResponse.statusCode == 200) {
        final jsonData = jsonDecode(videosResponse.body);
        final videos = jsonData["videos"];
        videosUsuario.clear();
        videosUsuario.addAll(mapListToVideos(videos));
        setState(() {});
      } else {
        videosUsuario.clear();
        print('Error al obtener los videos: ${videosResponse.statusCode}');
      }
    } catch (e) {
      videosUsuario.clear();
      print('Error en la solicitud de videos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    final videos = videosUsuario;
    final widthVideo = MediaQuery.of(context).size.width / 3;

    String shortInfo = '${player.provincia}, ${player.pais}';
    String fullInfo =
        '${player.provincia}, ${player.pais}\nEscuela deportiva: ${player.club}\n Altura: ${player.altura} cm\n Pie Dominante: ${player.pieDominante}\n Selección: ${player.seleccionNacional} ${player.categoriaSeleccion}\n Posición: ${player.position}\n Categoria: ${player.categoria}\n Logros: r${player.logrosIndividuales}';
    print("esta es la imagen ${player.userImage!.isNotEmpty}");
    print("esta es la imagen2 ${player.userImage!.isEmpty}");
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C2C2C), Color(0xFF000000)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent, // AppBar transparente
          elevation: 0, // Quitar sombra
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF00E050)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        extendBody: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (player.userImage!.isNotEmpty)
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
                  image: player.userImage!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            if (player.userImage!.isEmpty)
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
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'Ver menos...' : 'Ver más...',
                style: const TextStyle(
                    color: Color(0xFF05FF00),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(
              height: 15,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: GridView.builder(
                  padding: EdgeInsets.all(0),
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
                            builder: (context) => FullScreenVideoPage(
                              video: video,
                              index: index,
                              showOptions: false,
                            ),
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
                          if (video.isFavorite)
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
