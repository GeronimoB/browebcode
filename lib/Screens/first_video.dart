import 'package:bro_app_to/Screens/Inicio.dart';
import 'package:bro_app_to/Screens/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class FirstVideoWidget extends StatefulWidget {
  const FirstVideoWidget({super.key});

  @override
  State<FirstVideoWidget> createState() => _FirstVideoWidgetState();
}

class _FirstVideoWidgetState extends State<FirstVideoWidget> {
  VideoPlayerController? _videoController;
  double _sliderValue = 0.0;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      String videoPath = file.path!;
      _videoController
          ?.dispose(); // Libera el controlador de video existente si lo hay
      _videoController = VideoPlayerController.file(File(videoPath))
        ..initialize().then((_) {
          setState(() {
            _videoController!.play(); // Reproduce el video
            _videoController!.setLooping(true); // Pone el video en bucle
          });
        });
      _videoController!.addListener(() {
        setState(() {
          _sliderValue = _videoController!.value.position.inSeconds.toDouble();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 44, 44, 44),
              Color.fromARGB(255, 33, 33, 33),
              Color.fromARGB(255, 22, 22, 22),
              Color.fromARGB(255, 22, 22, 22),
              Color.fromARGB(255, 18, 18, 18),
            ],
            stops: [
              0.0,
              0.5,
              0.8,
              0.9,
              1.0
            ]),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Hacer el fondo del Scaffold transparente
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xff00E050)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Mi Primer Video',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            _videoController?.value.isInitialized ?? false
                ? Column(
                    children: [
                      AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                      Slider(
                        activeColor: Color(0xff3EAE64),
                        inactiveColor: Color(0xff00F056),
                        value: _sliderValue,
                        min: 0.0,
                        max: _videoController!.value.duration.inSeconds
                            .toDouble(),
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                            _videoController!
                                .seekTo(Duration(seconds: value.toInt()));
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.shuffle),
                            color: Color(0xff00F056),
                            iconSize: 30,
                            onPressed: () {
                              // Retroceder 30 segundos
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.fast_rewind),
                            color: Color(0xff00F056),
                            iconSize: 30,
                            onPressed: () {
                              // Retroceder 30 segundos
                              _videoController!.seekTo(Duration(
                                  seconds: _videoController!
                                          .value.position.inSeconds -
                                      10));
                            },
                          ),
                          IconButton(
                            color: Color(0xff00F056),
                            iconSize: 60,
                            icon: _videoController!.value.isPlaying
                                ? Icon(Icons.pause_circle_filled)
                                : Icon(Icons.play_circle_fill),
                            onPressed: () {
                              setState(() {
                                if (_videoController!.value.isPlaying) {
                                  _videoController!.pause();
                                } else {
                                  _videoController!.play();
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.fast_forward),
                            color: Color(0xff00F056),
                            iconSize: 30,
                            onPressed: () {
                              // Avanzar 30 segundos
                              _videoController!.seekTo(Duration(
                                  seconds: _videoController!
                                          .value.position.inSeconds +
                                      10));
                            },
                          ),
                          IconButton(
                            color: Color(0xff00F056),
                            iconSize: 30,
                            icon: Icon(Icons.star),
                            onPressed: () {
                              // Implementa la lógica para agregar a favoritos
                            },
                          ),
                        ],
                      ),
                      Container(
                        width: 100,
                        height: 42,
                        margin: EdgeInsets.symmetric(vertical: 60),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 0, 180, 64),
                              Color.fromARGB(255, 0, 225, 80),
                              Color.fromARGB(255, 0, 178, 63),
                            ], // Colores de tu gradiente
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(21),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 0, 224, 80),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 0), // Desplazamiento del sombreado
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CustomBottomNavigationBar()),
                            );
                          },
                          child: const Center(
                            child: Text(
                              'Subir',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: _pickVideo,
                    child: Image.asset(
                      'assets/images/CloudIcon.png',
                      height: 120,
                    )),
            Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Image.asset(
                  'assets/Logo.png',
                  width: 104,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
