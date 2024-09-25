import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:html' as html;

import '../common/sizes.dart';
import '../utils/current_state.dart';

Future<void> _handleDownload(String fileUrl, BuildContext context) async {
  if (fileUrl.isEmpty) {
    return;
  }
  String fileName = fileUrl.split('/').last;
  try {
    // Show a loading dialog
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

    final response = await html.HttpRequest.request(fileUrl);

    // Crea un blob con el contenido del video
    final blob = html.Blob([response.response], 'video/mp4');

    // Crea una URL para el blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Crea un elemento de ancla para la descarga
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName) // Usa el nombre original del archivo
      ..click();

    // Limpieza
    html.Url.revokeObjectUrl(url);

    Navigator.of(context).pop();
  } catch (e) {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            translations!["error"],
          ),
          content: Text(
            translations!["downloadError"],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                translations!["ok"],
              ),
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

Widget fileItem(
  String fileUrl,
  DateTime datetime,
  bool sent,
  bool read,
  BuildContext context,
) {
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
