import 'dart:async';
import 'dart:html' as html;
import 'dart:convert';

import 'package:bro_app_to/Screens/player/bottom_navigation_bar_player.dart';
import 'package:bro_app_to/components/app_bar_title.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/components/snackbar.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  late UserProvider userProvider;
  late PlayerProvider playerProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    playerProvider = Provider.of<PlayerProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Uint8List? coverImageBytes;
  Uint8List? videoBytes;

  Future<void> _pickCoverImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      if (kIsWeb) {
        coverImageBytes = file.bytes;
        setState(() {});
        Navigator.of(context).pop();
        _showUploadDialog();
        final player = playerProvider.getPlayer()!;
        await uploadVideoAndImageBytes(
            player.userId, '${player.name} ${player.lastName}');
      } else {
        // Manejo para otras plataformas si es necesario
      }
    }
  }

  void _showCoverImageModal() {
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
              const Text(
                "¿Deseas subir una imagen de portada?",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomTextButton(
                    onTap: () async {
                      await _pickCoverImage();
                    },
                    text: "Subir Imagen",
                    buttonPrimary: true,
                    width: 120,
                    height: 30,
                  ),
                  CustomTextButton(
                    onTap: () async {
                      Navigator.of(context).pop();
                      _showUploadDialog();
                      final player = playerProvider.getPlayer()!;
                      await uploadVideoAndImageBytes(
                          player.userId, '${player.name} ${player.lastName}');
                    },
                    text: "Omitir",
                    buttonPrimary: false,
                    width: 120,
                    height: 30,
                  ),
                ],
              ),
            ],
          ),
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

      // Si estás en la web, puede que necesites leer el archivo de una forma diferente.
      if (kIsWeb) {
        videoBytes = file.bytes;
        if (videoBytes == null) {
          // Error handling if bytes are null
          return;
        }

        if (!await _validateVideoBytes(videoBytes!)) {
          return;
        }
        setState(() {});
        _showCoverImageModal();
      } else {
        return;
      }
    }
  }

  Future<bool> _validateVideoBytes(Uint8List bytes) async {
    final blob = html.Blob([bytes], 'video/mp4');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final videoElement = html.VideoElement()
      ..src = url
      ..load();

    await videoElement.onLoadedMetadata.first;

    if (videoElement.duration > 120) {
      _showChargeDialog("El video no puede durar más de 2 minutos", false);
      html.Url.revokeObjectUrl(url);
      return false;
    }

    if (videoElement.videoHeight < 720 && videoElement.videoWidth < 720) {
      _showChargeDialog("La resolución mínima es de 720p", false);
      html.Url.revokeObjectUrl(url);
      return false;
    }

    if (videoElement.videoWidth > videoElement.videoHeight) {
      _showChargeDialog("Solo se pueden subir videos verticales", false);
      html.Url.revokeObjectUrl(url);
      return false;
    }

    html.Url.revokeObjectUrl(url);
    return true;
  }

  Future<void> uploadVideoAndImageBytes(
      String? userId, String? username) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}/auth/uploadFiles'),
    );
    request.fields["userId"] = userId ?? '';
    request.fields["username"] = username ?? '';

    // Agregar el video como bytes
    request.files.add(http.MultipartFile.fromBytes(
      'video',
      videoBytes!,
      filename: 'video.mp4',
      contentType: MediaType('video', 'mp4'),
    ));

    if (coverImageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'imagen',
        coverImageBytes!,
        filename: 'imagen.png',
        contentType: MediaType('image', 'png'),
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      showSucessSnackBar(context, translations!["VideoUploadSuccessMessage"]);
      Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              const CustomBottomNavigationBarPlayer(initialIndex: 4),
        ),
      );
    } else {
      Navigator.of(context).pop();
      showErrorSnackBar(context, translations!["VideoLoadError"]);
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
                backgroundColor: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }

  String errorMessage = '';

  Future<bool> _canUploadMoreVideos() async {
    final videosCountResponse = await ApiClient()
        .get('auth/videos_count/${userProvider.getCurrentUser().userId}');

    try {
      if (videosCountResponse.statusCode == 200) {
        final jsonData = jsonDecode(videosCountResponse.body);
        final total = jsonData["userVideosCount"];
        final maxVideosAllowed =
            videosForPlan[userProvider.getCurrentUser().subscription];

        if (total >= maxVideosAllowed) {
          setState(() {
            errorMessage = translations!["VideoLimitExceededMessage"];
          });
          return false;
        }
        return true;
      } else {
        setState(() {
          errorMessage = translations!["ErrorOccurredMessage"];
        });
        return false;
      }
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = translations!["ErrorOccurredMessage"];
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = playerProvider.getPlayer();
    final canUploadVideo = userProvider.getCurrentUser().status &&
        (player?.registroCompleto ?? false) &&
        (player?.emailVerified ?? false);

    if (!canUploadVideo) {
      errorMessage = translations!["InactiveSubscriptionMessage"];
    }

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
          title: appBarTitle(translations!["UPLOAD_A_VIDEO"]),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBody: true,
        body: SafeArea(
          child: errorMessage.isEmpty
              ? FutureBuilder<bool>(
                  future: _canUploadMoreVideos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || !(snapshot.data ?? false)) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            errorMessage ??
                                translations!["ErrorOccurredMessage"],
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox.shrink(),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: _pickVideo,
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
                      );
                    }
                  },
                )
              : Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ),
    );
  }
}
