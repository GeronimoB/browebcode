import 'package:bro_app_to/Screens/bottom_navigation_bar_player.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:video_thumbnail/video_thumbnail.dart';

import '../providers/user_provider.dart';
import '../utils/api_constants.dart';

// import 'package:video_thumbnail/video_thumbnail.dart';

class UploadVideoWidget extends StatefulWidget {
  const UploadVideoWidget({super.key});

  @override
  State<UploadVideoWidget> createState() => _UploadVideoWidgetState();
}

class _UploadVideoWidgetState extends State<UploadVideoWidget> {
  VideoPlayerController? _videoController;
  VideoPlayerController? _temporalVideoController;
  double _sliderValue = 0.0;
  String? videoPathToUpload;
  Uint8List? imagePathToUpload;

  @override
  void dispose() {
    _videoController?.dispose();
    _temporalVideoController?.dispose();
    super.dispose();
  }

  void showChargeDialog(String text, bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23)),
              backgroundColor: const Color(0xFF3B3B3B),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                        color: success ? Color(0xff00E050) : Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: success ? FontWeight.w400 : FontWeight.bold,
                        fontSize: success ? 20 : 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  CustomTextButton(
                      onTap: () {
                        success
                            ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CustomBottomNavigationBarPlayer()),
                              )
                            : Navigator.of(context).pop();
                      },
                      text: "Listo",
                      buttonPrimary: true,
                      width: 174,
                      height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String videoPath = file.path!;
      videoPathToUpload = videoPath;
      _temporalVideoController?.dispose();
      _temporalVideoController = VideoPlayerController.file(File(videoPath));

      await _temporalVideoController?.initialize();

      // Verificar duración del video
      Duration duration = _temporalVideoController!.value.duration;
      if (duration.inSeconds > 120) {
        // Video dura más de 2 minutos
        showChargeDialog("El video no puede durar más de 2 minutos", false);
        return;
      }

      if (_temporalVideoController!.value.size.height < 720 ||
          _temporalVideoController!.value.size.width < 720) {
        // Video tiene una resolución menor a 720p
        showChargeDialog("La resolución minima es de 720p", false);
        return;
      }
      if (_temporalVideoController!.value.aspectRatio > 1) {
        // Video es horizontal
        showChargeDialog("Solo se pueden subir videos verticales", false);
        return;
      }

      // Capturar un frame del video para usarlo como placeholder
      final uint8list = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.PNG,
        maxHeight: 200,
        quality: 30,
      );
      imagePathToUpload = uint8list;

      _temporalVideoController?.dispose();
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(File(videoPath));

      await _videoController?.initialize();

      await _videoController?.play();

      _videoController?.setLooping(true);

      _videoController?.addListener(() {
        setState(() {
          _sliderValue = _videoController!.value.position.inSeconds.toDouble();
        });
      });
      final playerProvider =
          Provider.of<PlayerProvider>(context, listen: false);
      _showUploadDialog();
      await uploadVideoAndImage(
          videoPath, uint8list, playerProvider.getPlayer()!.userId);
    }
  }

  Future<void> uploadVideoAndImage(
      String? videoPath, Uint8List? uint8list, String? userId) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}/auth/uploadFiles'),
    );
    request.fields["userId"] = userId ?? '';
    if (videoPath != null) {
      // Adjuntar el archivo de video al cuerpo de la solicitud
      request.files.add(await http.MultipartFile.fromPath(
        'video', // Nombre del campo en el servidor para el video
        videoPath,
      ));
    }

    if (uint8list != null) {
      // Adjuntar los bytes de la imagen al cuerpo de la solicitud
      request.files.add(http.MultipartFile.fromBytes(
        'imagen',
        uint8list,
        filename: 'imagen.png',
        contentType: MediaType('image', 'png'),
      ));
    }

    // Enviar la solicitud al servidor y esperar la respuesta
    var response = await request.send();

    // Verificar el estado de la respuesta
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text('Video subido exitosamente.')));
      Future.delayed(Duration(seconds: 3));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CustomBottomNavigationBarPlayer(initialIndex: 4)),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content:
              Text('Hubo un error al cargar el video, intentalo de nuevo.')));
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
              'Subir video',
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
                      SizedBox(
                        width: double.maxFinite,
                        height: 500,
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     IconButton(
                      //       icon: const Icon(Icons.shuffle),
                      //       color: const Color(0xff00F056),
                      //       iconSize: 30,
                      //       onPressed: () {
                      //         // Retroceder 30 segundos
                      //       },
                      //     ),
                      //     IconButton(
                      //       icon: const Icon(Icons.fast_rewind),
                      //       color: const Color(0xff00F056),
                      //       iconSize: 30,
                      //       onPressed: () {
                      //         // Retroceder 30 segundos
                      //         _videoController!.seekTo(Duration(
                      //             seconds: _videoController!
                      //                     .value.position.inSeconds -
                      //                 10));
                      //       },
                      //     ),
                      //     IconButton(
                      //       color: const Color(0xff00F056),
                      //       iconSize: 60,
                      //       icon: _videoController!.value.isPlaying
                      //           ? const Icon(Icons.pause_circle_filled)
                      //           : const Icon(Icons.play_circle_fill),
                      //       onPressed: () {
                      //         setState(() {
                      //           if (_videoController!.value.isPlaying) {
                      //             _videoController!.pause();
                      //           } else {
                      //             _videoController!.play();
                      //           }
                      //         });
                      //       },
                      //     ),
                      //     IconButton(
                      //       icon: const Icon(Icons.fast_forward),
                      //       color: const Color(0xff00F056),
                      //       iconSize: 30,
                      //       onPressed: () {
                      //         // Avanzar 30 segundos
                      //         _videoController!.seekTo(Duration(
                      //             seconds: _videoController!
                      //                     .value.position.inSeconds +
                      //                 10));
                      //       },
                      //     ),
                      //     IconButton(
                      //       color: const Color(0xff00F056),
                      //       iconSize: 30,
                      //       icon: const Icon(Icons.star),
                      //       onPressed: () {
                      //         // Implementa la lógica para agregar a favoritos
                      //       },
                      //     ),
                      //   ],
                      // ),
                      CustomTextButton(
                          onTap: () {
                            showChargeDialog(
                                "El video se subio exitosamente!", true);
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
                padding: const EdgeInsets.only(bottom: 80),
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

  void _showUploadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23)),
              contentPadding: const EdgeInsets.all(25),
              backgroundColor: const Color(0xFF3B3B3B),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Estamos subiendo tu vídeo, esto puede tardar unos segundos…",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25),
                  LinearProgressIndicator(
                    color: Color(0xff00E050),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
