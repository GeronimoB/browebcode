import 'dart:typed_data';

import 'package:bro_app_to/Screens/planes_pago.dart';
import 'package:bro_app_to/components/app_bar_title.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/providers/player_provider.dart';
import 'package:bro_app_to/src/registration/presentation/screens/upload_cover_image.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../../utils/current_state.dart';
import 'dart:html' as html;

class FirstVideoWidget extends StatefulWidget {
  const FirstVideoWidget({super.key});

  @override
  State<FirstVideoWidget> createState() => _FirstVideoWidgetState();
}

class _FirstVideoWidgetState extends State<FirstVideoWidget> {
  VideoPlayerController? _temporalVideoController;
  final double _sliderValue = 0.0;
  String? videoPathToUpload;
  Uint8List? imagePathToUpload;

  @override
  void dispose() {
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
                        color: success ? const Color(0xff00E050) : Colors.white,
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
                      text: translations!['ready'],
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

  Future<bool> _validateVideoBytes(Uint8List bytes) async {
    final blob = html.Blob([bytes], 'video/mp4');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final videoElement = html.VideoElement()
      ..src = url
      ..load();

    await videoElement.onLoadedMetadata.first;

    if (videoElement.duration > 120) {
      showUploadDialog("El video no puede durar más de 2 minutos", false);
      html.Url.revokeObjectUrl(url);
      return false;
    }

    if (videoElement.videoHeight < 720 && videoElement.videoWidth < 720) {
      showUploadDialog("La resolución mínima es de 720p", false);
      html.Url.revokeObjectUrl(url);
      return false;
    }

    if (videoElement.videoWidth > videoElement.videoHeight) {
      showUploadDialog("Solo se pueden subir videos verticales", false);
      html.Url.revokeObjectUrl(url);
      return false;
    }

    html.Url.revokeObjectUrl(url);
    return true;
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      Uint8List? videoBytes;

      if (kIsWeb) {
        videoBytes = file.bytes;
        if (videoBytes == null) {
          // Error handling if bytes are null
          return;
        }

        if (!await _validateVideoBytes(videoBytes)) {
          return;
        }

        final playerProvider =
            Provider.of<PlayerProvider>(context, listen: false);

        playerProvider.updateVideoToUpload(videoBytes);
        playerProvider.isSubscriptionPayment = true;
        playerProvider.isNewSubscriptionPayment = true;

        showUploadDialog(translations!['video_scss'], true);

        final blob = html.Blob([videoBytes], 'video/mp4');
        final url = html.Url.createObjectUrlFromBlob(blob);
        _temporalVideoController =
            VideoPlayerController.networkUrl(Uri.parse(url))
              ..initialize().then((_) {
                setState(() {});
                _temporalVideoController!.play();
              });

        Future.delayed(const Duration(seconds: 5), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const UploadCoverImageScreen()),
          );
        });
      } else {
        return;
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 530),
          child: Container(
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
              backgroundColor: Colors.transparent,
              extendBody: true,
              appBar: AppBar(
                scrolledUnderElevation: 0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: appBarTitle(translations!['first_video']),
                automaticallyImplyLeading: false,
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox.shrink(),
                  _temporalVideoController?.value.isInitialized ?? false
                      ? Column(
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                              height: 500,
                              child: VideoPlayer(_temporalVideoController!),
                            ),
                            VideoProgressIndicator(
                              _temporalVideoController!,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: Color(0xFF00E050),
                                bufferedColor: Colors.white,
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      : Column(
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
          ),
        ),
      ),
    );
  }
}
