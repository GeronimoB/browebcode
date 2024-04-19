import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bro_app_to/Screens/player/bottom_navigation_bar_player.dart';
import 'package:bro_app_to/components/app_bar_title.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../providers/player_provider.dart';
import '../../utils/api_client.dart';
import '../../utils/api_constants.dart';
import '../../utils/current_state.dart';

Map<String, int> videosForPlan = {
  "Basic": 2,
  "Gold": 5,
  "Platinum": 10,
  "Unlimited": 9999999,
};

class UploadVideoWidget extends StatefulWidget {
  const UploadVideoWidget({Key? key}) : super(key: key);

  @override
  State<UploadVideoWidget> createState() => _UploadVideoWidgetState();
}

class _UploadVideoWidgetState extends State<UploadVideoWidget> {
  VideoPlayerController? _videoController;
  double _sliderValue = 0.0;
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _videoController?.removeListener(() {});
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

      if (!await _validateVideo(videoPath)) {
        return;
      }

      Uint8List? thumbnail = await _generateThumbnail(videoPath);
      if (thumbnail == null) {
        return;
      }

      _videoController = await _initializeVideoController(videoPath);
      if (_videoController == null) {
        return;
      }

      final playerProvider =
          Provider.of<PlayerProvider>(context, listen: false);
      _showUploadDialog();
      await uploadVideoAndImage(
          videoPath, thumbnail, playerProvider.getPlayer()!.userId);
    }
  }

  Future<bool> _validateVideo(String videoPath) async {
    VideoPlayerController temporalVideoController =
        VideoPlayerController.file(File(videoPath));
    await temporalVideoController.initialize();

    Duration duration = temporalVideoController.value.duration;
    if (duration.inSeconds > 120) {
      _showChargeDialog("El video no puede durar más de 2 minutos", false);
      temporalVideoController.dispose();
      return false;
    }

    if (temporalVideoController.value.size.height < 720 ||
        temporalVideoController.value.size.width < 720) {
      _showChargeDialog("La resolución mínima es de 720p", false);
      temporalVideoController.dispose();
      return false;
    }
    if (temporalVideoController.value.aspectRatio > 1) {
      _showChargeDialog("Solo se pueden subir videos verticales", false);
      temporalVideoController.dispose();
      return false;
    }

    temporalVideoController.dispose();
    return true;
  }

  Future<Uint8List?> _generateThumbnail(String videoPath) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      maxHeight: 200,
      quality: 30,
    );

    return uint8list;
  }

  Future<VideoPlayerController?> _initializeVideoController(
      String videoPath) async {
    VideoPlayerController videoController =
        VideoPlayerController.file(File(videoPath));
    await videoController.initialize();
    await videoController.play();
    videoController.setLooping(true);

    videoController.addListener(() {
      setState(() {
        _sliderValue = videoController.value.position.inSeconds.toDouble();
      });
    });

    return videoController;
  }

  void _showSubscriptionRe() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
              'No tienes una suscripcion activa, ve a tu cuenta para poder subir videos e interactuar con los agentes.')),
    );
  }

  Future<void> uploadVideoAndImage(
      String? videoPath, Uint8List? uint8list, String? userId) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}/auth/uploadFiles'),
    );
    request.fields["userId"] = userId ?? '';
    if (videoPath != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'video',
        videoPath,
      ));
    }

    if (uint8list != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'imagen',
        uint8list,
        filename: 'imagen.png',
        contentType: MediaType('image', 'png'),
      ));
    }
    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color(0xFF05FF00),
          content: Text('Video subido exitosamente.')));
      Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                const CustomBottomNavigationBarPlayer(initialIndex: 4)),
      );
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content:
              Text('Hubo un error al cargar el video, intentalo de nuevo.')));
    }
  }

  void _showChargeDialog(String text, bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          backgroundColor: const Color(0xFF3B3B3B),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                    color: success ? const Color(0xff00E050) : Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: success ? FontWeight.w400 : FontWeight.bold,
                    fontSize: success ? 20 : 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              CustomTextButton(
                  onTap: () {
                    success
                        ? Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CustomBottomNavigationBarPlayer()),
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
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          contentPadding: const EdgeInsets.all(25),
          backgroundColor: const Color(0xFF3B3B3B),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Estamos subiendo tu vídeo, esto puede tardar unos segundos…",
                style: const TextStyle(
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
            Color.fromARGB(255, 0, 0, 0),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: appBarTitle('SUBIR VIDEO'),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBody: true,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox.shrink(),
              _videoController?.value.isInitialized ?? false
                  ? Column(
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          height: 500,
                          child: VideoPlayer(_videoController!),
                        ),
                        Slider(
                          activeColor: const Color(0xff3EAE64),
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
                      ],
                    )
                  : Column(
                      children: [
                        GestureDetector(
                          onTap: userProvider.getCurrentUser().status
                              ? () async {
                                  final videosCount = await ApiClient().get(
                                      'auth/videos_count/${userProvider.getCurrentUser().userId}');
                                  try {
                                    if (videosCount.statusCode == 200) {
                                      final jsonData =
                                          jsonDecode(videosCount.body);
                                      final total = jsonData["userVideosCount"];

                                      if (total <
                                          videosForPlan[userProvider
                                              .getCurrentUser()
                                              .subscription]) {
                                        _pickVideo();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            content: Text(
                                              'Superaste el limite de videos de tu plan, si deseas subir un nuevo video, borra un video de tu perfil.',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.redAccent,
                                        content: Text(
                                          'Ocurrio un error intentalo de nuevo.',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              : _showSubscriptionRe,
                          child: SvgPicture.asset(
                            'assets/icons/CloudIcon.svg',
                            width: 210,
                          ),
                        ),
                        Text(
                          translations!['upload'],
                          style: const TextStyle(
                            color: Color(0xFF00E050),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            fontSize: 15.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          width: 300,
                          child: Text(
                            translations!['show_your_habilities'],
                            style: const TextStyle(
                              color: Color(0xFF00E050),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900,
                              fontSize: 15.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SvgPicture.asset(
                    'assets/icons/Logo.svg',
                    width: 104,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
