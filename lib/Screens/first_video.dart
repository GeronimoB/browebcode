import 'package:bro_app_to/Screens/Inicio.dart';
import 'package:bro_app_to/Screens/bottom_navigation_bar.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/planes_pago.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
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
                        inactiveColor: const Color(0xff00F056),
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
                            icon: const Icon(Icons.shuffle),
                            color: const Color(0xff00F056),
                            iconSize: 30,
                            onPressed: () {
                              // Retroceder 30 segundos
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.fast_rewind),
                            color: const Color(0xff00F056),
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
                            color: const Color(0xff00F056),
                            iconSize: 60,
                            icon: _videoController!.value.isPlaying
                                ? const Icon(Icons.pause_circle_filled)
                                : const Icon(Icons.play_circle_fill),
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
                            icon: const Icon(Icons.fast_forward),
                            color: const Color(0xff00F056),
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
                            color: const Color(0xff00F056),
                            iconSize: 30,
                            icon: const Icon(Icons.star),
                            onPressed: () {
                              // Implementa la lógica para agregar a favoritos
                            },
                          ),
                        ],
                      ),
                      CustomTextButton(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PlanesPago()),
                            );
                          },
                          text: 'Subir',
                          buttonPrimary: true,
                          width: 100,
                          height: 39)
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
                padding: const EdgeInsets.all(25),
                child: SvgPicture.asset(
                  width: 104,
                  'assets/icons/Logo.svg',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
