import 'dart:typed_data';

import 'package:bro_app_to/Screens/planes_pago.dart';
import 'package:bro_app_to/components/app_bar_title.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/providers/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../../utils/current_state.dart';

class UploadCoverImageScreen extends StatefulWidget {
  const UploadCoverImageScreen({super.key});

  @override
  State<UploadCoverImageScreen> createState() => _UploadCoverImageScreenState();
}

class _UploadCoverImageScreenState extends State<UploadCoverImageScreen> {
  Uint8List? imagePathToUpload;

  @override
  void dispose() {
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

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      Uint8List? imageBytes;

      if (kIsWeb) {
        imageBytes = file.bytes;
        if (imageBytes == null) {
          return;
        }

        final playerProvider =
            Provider.of<PlayerProvider>(context, listen: false);

        playerProvider.updateImageToUpload(imageBytes);

        showUploadDialog('La imagen se ha cargado con exito!', true);

        // Opcional: Mostrar la imagen seleccionada en un Image widget
        setState(() {});

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PlanesPago()),
          );
        });
      }
    }
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
                title: appBarTitle('Portada'),
                automaticallyImplyLeading: false,
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: SvgPicture.asset(
                      'assets/icons/CloudIcon.svg',
                      width: 210,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Sube la portada de tu video, si no la subes el sistema generará una.',
                    style: TextStyle(
                      color: Color(0xFF00E050),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w900,
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  CustomTextButton(
                      onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PlanesPago(),
                            ),
                          ),
                      text: 'Omitir',
                      buttonPrimary: true,
                      width: 116,
                      height: 39),
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
