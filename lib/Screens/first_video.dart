import 'dart:typed_data';

import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/planes_pago.dart';
import 'package:bro_app_to/utils/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:video_thumbnail/video_thumbnail.dart';

import '../providers/user_provider.dart';

class FirstVideoWidget extends StatefulWidget {
  const FirstVideoWidget({super.key});

  @override
  State<FirstVideoWidget> createState() => _FirstVideoWidgetState();
}

class _FirstVideoWidgetState extends State<FirstVideoWidget> {
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

  void showUploadDialog(String text, bool success) {
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
                      onTap: () async {
                        Navigator.of(context).pop();
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
        // Puedes mostrar un mensaje de error o realizar alguna acción apropiada
        showUploadDialog("El video no puede durar más de 2 minutos", false);
        return;
      }

      // Verificar resolución del video
      print(
          "esta es la resolucion: ${_temporalVideoController!.value.size!.height} ${_temporalVideoController!.value.size!.width}");
      if (_temporalVideoController!.value.size != null &&
          (_temporalVideoController!.value.size!.height < 720 ||
              _temporalVideoController!.value.size!.width < 720)) {
        // Video tiene una resolución menor a 720p
        // Puedes mostrar un mensaje de error o realizar alguna acción apropiada
        showUploadDialog("La resolución minima es de 720p", false);
        return;
      }

      // Verificar orientación del video
      if (_temporalVideoController!.value.aspectRatio > 1) {
        // Video es horizontal
        // Puedes mostrar un mensaje de error o realizar alguna acción apropiada
        showUploadDialog("Solo se pueden subir videos verticales", false);
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
      final playerProvider =
          Provider.of<PlayerProvider>(context, listen: false);

      playerProvider.updateDataToUpload(videoPath, uint8list);

      _temporalVideoController?.dispose();
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(File(videoPath));
      showUploadDialog("El video se cargo exitosamente", true);
      await _videoController?.initialize();

      await _videoController?.play();
      Future.delayed(Duration(seconds: 6), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PlanesPago()),
        );
      });

      _videoController?.setLooping(true); // Pone el video en bucle

      _videoController?.addListener(() {
        setState(() {
          _sliderValue = _videoController!.value.position.inSeconds.toDouble();
        });
      });
    }
  }

  Future<void> uploadVideoAndImage(
      String? videoPath, Uint8List? uint8list) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}/auth/uploadFiles'),
    );
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
        'imagen', // Nombre del campo en el servidor para la imagen
        uint8list,
        filename: 'imagen.png', // Nombre de archivo (puede ser cualquier cosa)
        contentType:
            MediaType('image', 'png'), // Tipo de contenido de la imagen
      ));
    }

    // Enviar la solicitud al servidor y esperar la respuesta
    var response = await request.send();

    // Verificar el estado de la respuesta
    if (response.statusCode == 200) {
      print('Archivos subidos con éxito');
    } else {
      print('Error al subir los archivos: ${response.reasonPhrase}');
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
