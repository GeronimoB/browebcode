import 'dart:io';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../common/sizes.dart';

Future<void> _handleDownload(String fileUrl, BuildContext context) async {
  if (fileUrl.isEmpty) {
    return;
  }

  final status = await Permission.storage.status;

  if (!status.isGranted) {
    final result = await Permission.storage.request();
    if (!result.isGranted) {
      return;
    }
  }

  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
          ),
        );
      },
    );

    final fileExtension = path.extension(fileUrl);
    final response = await http.get(Uri.parse(fileUrl));
    final downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    final file = File(
        '${downloadsDirectory!.path}/archivo_${DateTime.now().millisecondsSinceEpoch}$fileExtension');

    await file.writeAsBytes(response.bodyBytes);

    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xff3B3B3B),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(5, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    translations!["congrats"],
                    style: const TextStyle(
                        color: Color(0xff00E050),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'El archivo se ha guardado en la carpeta de descargas.',
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ));
      },
    );
  } catch (e) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Ha habido un error en la descarga, intente nuevamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    debugPrint(e.toString());
  }
}

Icon getFileIcon(String fileType) {
  // Determinar el icono según la extensión del archivo
  switch (fileType) {
    case 'pdf':
      return const Icon(Icons.picture_as_pdf, color: Colors.red, size: 64);
    case 'doc':
    case 'docx':
      return const Icon(Icons.description, color: Colors.blue, size: 64);
    case 'xls':
    case 'xlsx':
      return const Icon(Icons.table_chart, color: Colors.green, size: 64);
    case 'ppt':
    case 'pptx':
      return const Icon(Icons.slideshow, color: Colors.orange, size: 64);
    case 'mp4':
    case 'avi':
    case 'mkv':
      return const Icon(Icons.video_library,
          color: Colors.deepPurple, size: 64);
    case 'mp3':
    case 'wav':
      return const Icon(Icons.music_note, color: Colors.deepOrange, size: 64);
    default:
      return const Icon(Icons.insert_drive_file, size: 64);
  }
}

String getFileType(String fileUrl) {
  // Obtener la extensión del archivo desde la URL o cualquier otra fuente
  String extension = path.extension(fileUrl);

  // Eliminar el punto inicial de la extensión
  if (extension.isNotEmpty && extension[0] == '.') {
    extension = extension.substring(1);
  }

  // Devolver la extensión en minúsculas
  return extension.toLowerCase();
}

String getFileDisplayName(String fileUrl) {
  // Obtener el nombre del archivo de la URL
  String fileName = path.basename(fileUrl);

  // Truncar el nombre del archivo si es demasiado largo
  const maxLength = 50;
  if (fileName.length > maxLength) {
    fileName = '${fileName.substring(0, maxLength - 3)}...';
  }

  return fileName;
}

Widget fileItem(String fileUrl, DateTime datetime, bool sent, bool read,
    BuildContext context) {
  String fileType = getFileType(fileUrl);
  return Container(
    width: Sizes.width,
    padding: EdgeInsets.symmetric(horizontal: Sizes.padding),
    alignment: sent ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      width: Sizes.width * 0.65,
      margin: EdgeInsets.symmetric(vertical: Sizes.padding / 4),
      padding: EdgeInsets.symmetric(
          horizontal: Sizes.padding / 2, vertical: Sizes.padding / 4),
      decoration: BoxDecoration(
          color: sent
              ? const Color.fromARGB(51, 4, 255, 0)
              : const Color.fromARGB(51, 255, 255, 255),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(Sizes.radius),
            bottomRight: Radius.circular(Sizes.radius),
            topRight: Radius.circular(sent ? 0 : Sizes.radius),
            topLeft: Radius.circular(sent ? Sizes.radius : 0),
          ),
          border: Border.all(
            color: sent
                ? const Color.fromARGB(107, 4, 255, 0)
                : const Color.fromARGB(51, 255, 255, 255),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () => _handleDownload(fileUrl, context),
              child: Center(child: getFileIcon(fileType))),
          SizedBox(height: Sizes.padding / 4),
          Text(
            getFileDisplayName(fileUrl),
            style: TextStyle(
              color: Colors.white,
              fontSize: Sizes.font14,
            ),
          ),
          SizedBox(height: Sizes.padding / 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                datetime.toIso8601String().substring(11, 16),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Sizes.font14,
                ),
              ),
              const SizedBox(width: 5),
              sent
                  ? Icon(read ? Icons.done_all : Icons.check,
                      size: 16, color: const Color.fromARGB(255, 215, 214, 214))
                  : Container(),
            ],
          ),
        ],
      ),
    ),
  );
}
