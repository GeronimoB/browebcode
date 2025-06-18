import 'package:bro_app_to/Screens/agent/bottom_navigation_bar.dart';
import 'package:bro_app_to/Screens/metodo_pago_screen.dart';
import 'package:bro_app_to/components/modal_decision.dart';
import 'package:bro_app_to/components/snackbar.dart';
import 'package:bro_app_to/providers/player_provider.dart';
import 'package:bro_app_to/utils/api_constants.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:bro_app_to/utils/video_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../../common/base_encode_helper.dart';
import '../../components/custom_text_button.dart';
import '../../utils/api_client.dart';
import 'bottom_navigation_bar_player.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

class FullScreenVideoPage extends StatefulWidget {
  final Video video;
  final int index;
  final bool showOptions;

  const FullScreenVideoPage(
      {Key? key,
      required this.video,
      required this.index,
      required this.showOptions})
      : super(key: key);

  @override
  FullScreenVideoPageState createState() => FullScreenVideoPageState();
}

class FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _controller;
  bool _showPauseIcon = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    Uri url = Uri.parse(widget.video.videoUrl ?? '');
    _controller = VideoPlayerController.networkUrl(url)
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
        _showPauseIconForAMoment();
      }
    });
  }

  void _showPauseIconForAMoment() {
    setState(() {
      _showPauseIcon = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showPauseIcon = false;
      });
    });
  }

  void _showCustomMenu(BuildContext context) {
    _overlayEntry?.remove();
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    double sizeWidth = size.width > 530 ? 530 : size.width;
    double sizeWidth2 =
        size.width > 530 ? ((size.width - 530) / 2 + 530) : size.width;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
            child: Container(
              width: sizeWidth,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: offset.dx + sizeWidth2 - 230,
            top: offset.dy + 35,
            width: 220,
            child: Material(
              borderRadius: BorderRadius.circular(15),
              elevation: 5.0,
              shadowColor: Colors.black.withOpacity(0.4),
              color: const Color(0xFF3B3B3B),
              child: Container(
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
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        translations!['delete_label'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontStyle: FontStyle.italic),
                      ),
                      onTap: () {
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                        _showConfirmationDeleteDialog(widget.video.id ?? 0);
                      },
                    ),
                    ListTile(
                      title: Text(
                          widget.video.isFavorite
                              ? translations!['stop_favorite']
                              : translations!['add_favorite'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic)),
                      onTap: () {
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                        _handleDestacar(widget.index, widget.video,
                            widget.video.isFavorite);
                      },
                    ),
                    ListTile(
                      title: Text(
                        translations!['download'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontStyle: FontStyle.italic),
                      ),
                      onTap: () {
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                        _handleDownload(widget.video);
                      },
                    ),
                    ListTile(
                      title: Text(
                        translations!['description_video'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontStyle: FontStyle.italic),
                      ),
                      onTap: () {
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                        _showDescriptionDialog(widget.video);
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Compartir',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontStyle: FontStyle.italic),
                      ),
                      onTap: () {
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                        _handleShare(widget.video);
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Cambiar portada',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onTap: () {
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                        _showCoverImageModal();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 530),
        child: Stack(
          children: [
            GestureDetector(
              onTap: _togglePlayPause,
              child: _controller.value.isInitialized
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                      ),
                    ),
            ),
            Positioned(
              right: 10,
              bottom: 162,
              child: Column(
                children: [
                  Icon(
                    widget.video.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.white,
                    size: 36,
                  ),
                  Text(
                    widget.video.likesCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      height: 1,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.mode_comment_outlined,
                    color: Colors.white,
                    size: 36,
                  ),
                  Text(
                    widget.video.commentsCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      height: 1,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 8.0,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF00E050),
                  size: 32,
                ),
                onPressed: () => widget.showOptions
                    ? Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              const CustomBottomNavigationBarPlayer(
                            initialIndex: 4,
                          ),
                        ),
                      )
                    : Navigator.of(context).pop(),
              ),
            ),
            if (widget.showOptions)
              Positioned(
                top: MediaQuery.of(context).padding.top,
                right: 8.0,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: const IconThemeData(color: Color(0xFF00E050)),
                  ),
                  child: IconButton(
                    icon:
                        const Icon(Icons.more_horiz, color: Color(0xFF00E050)),
                    onPressed: () {
                      _showCustomMenu(context);
                    },
                  ),
                ),
              ),
            Positioned(
              bottom: 20,
              left: (MediaQuery.of(context).size.width > 530
                          ? 530
                          : MediaQuery.of(context).size.width) /
                      2 -
                  52,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: SvgPicture.asset(
                  'assets/icons/Logo.svg',
                  fit: BoxFit.fitWidth,
                  width: 104,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 2,
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                padding: const EdgeInsets.symmetric(vertical: 0),
                colors: const VideoProgressColors(
                  playedColor: Color(0xFF00E050),
                  bufferedColor: Colors.white60,
                  backgroundColor: Colors.white24,
                ),
              ),
            ),
            GestureDetector(
              onTap: _togglePlayPause,
              child: AnimatedOpacity(
                opacity:
                    _showPauseIcon || !_controller.value.isPlaying ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Center(
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: _controller.value.isPlaying
                        ? const Color.fromARGB(142, 255, 255, 255)
                        : Colors.white,
                    size: 64,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDownload(Video video) async {
    String? videoUrl = video.downaloadVideoUrl;
    if (videoUrl == null || videoUrl.isEmpty) {
      return;
    }

    // Extraer el nombre del archivo de la URL
    String fileName = videoUrl.split('/').last;

    // Mostrar un indicador de carga
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

    try {
      // Realiza la solicitud para obtener el video
      final response = await html.HttpRequest.request(videoUrl);

      // Crea un blob con el contenido del video
      final blob = html.Blob([response.response], 'video/mp4');

      // Crea una URL para el blob
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Crea un elemento de ancla para la descarga
      html.AnchorElement(href: url)
        ..setAttribute(
            'download', fileName) // Usa el nombre original del archivo
        ..click();

      // Limpieza
      html.Url.revokeObjectUrl(url);

      // Cerrar el indicador de carga
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog(e.toString());
      debugPrint(e.toString());
    }
  }

  Future<void> _handleShare(Video video) async {
    final encodedId = Base64Helper.encode(video.id.toString());
    final videoUrl = 'https://app.bro.futbol/home/videos/$encodedId';

    Share.share(
      'Mira este video increíble: $videoUrl',
      sharePositionOrigin: Rect.fromLTWH(
          0,
          0,
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 2),
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
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
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  translations!["fileSaved"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translations!["error"]),
          content: Text(translations!["downloadError"]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(translations!["ok"]),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDeleteDialog(int videoId) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (BuildContext context) {
        print(translations!['delete_video_confirmation']);
        print(videoId.toString());

        return ModalDecition(
          text: translations!['delete_video_confirmation'],
          confirmCallback: () async {
            _controller.dispose();
            final response = await ApiClient()
                .post('auth/delete-video', {"videoId": videoId.toString()});

            await Future.delayed(const Duration(seconds: 1));

            if (response.statusCode == 200) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) =>
                        const CustomBottomNavigationBarPlayer(initialIndex: 4)),
              );
            } else {
              showErrorSnackBar(context, translations!['delete_video_err']);

              await Future.delayed(const Duration(seconds: 2));
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) =>
                        const CustomBottomNavigationBarPlayer(initialIndex: 4)),
              );
            }
          },
          cancelCallback: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showDescriptionDialog(Video video) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (BuildContext context) {
        TextEditingController editingController =
            TextEditingController(text: video.description);
        return Dialog(
            backgroundColor: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translations!["description_title"],
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xff00E050),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    TextField(
                      controller: editingController,
                      maxLength: 35,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF00E050), width: 2),
                        ),
                      ),
                      cursorColor: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomTextButton(
                          onTap: () => Navigator.of(context).pop(),
                          text: 'Cancelar',
                          buttonPrimary: false,
                          width: 90,
                          height: 27,
                        ),
                        CustomTextButton(
                          onTap: () async {
                            await ApiClient().post('auth/update-video', {
                              'videoId': video.id.toString(),
                              'description': editingController.text
                            });

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CustomBottomNavigationBarPlayer(
                                          initialIndex: 4)),
                            );
                          },
                          text: 'Guardar',
                          buttonPrimary: true,
                          width: 90,
                          height: 27,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  void _handleDestacar(int index, Video video, bool dDestacar) async {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    playerProvider.setVideoAndIndex(index, video);
    if (dDestacar) {
      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.6),
        builder: (BuildContext context) {
          return ModalDecition(
            text: translations!['cancel_favorite_video'],
            confirmCallback: () async {
              await ApiClient().post('auth/update-video', {
                'videoId': video.id.toString(),
                'subscriptionId': video.suscriptionId
              });
              playerProvider.indexProcessingVideoFavoritePayment = 0;
              playerProvider.videoProcessingFavoritePayment = null;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) =>
                        const CustomBottomNavigationBarPlayer(initialIndex: 4)),
              );
            },
            cancelCallback: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    } else {
      playerProvider.isSubscriptionPayment = false;
      _controller.pause();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MetodoDePagoScreen(valueToPay: 0.99),
        ),
      );
    }
  }

  Future<void> _pickCoverImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      _showUploadDialog();

      uploadVideoAndImageBytes(widget.video.id.toString(), file.bytes);
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
                      Navigator.of(context).pop();
                      await _pickCoverImage();
                    },
                    text: "Subir Imagen",
                    buttonPrimary: true,
                    width: 120,
                    height: 30,
                  ),
                  CustomTextButton(
                    onTap: () => Navigator.of(context).pop(),
                    text: "Cancelar",
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

  Future<void> uploadVideoAndImageBytes(
      String? videoId, Uint8List? coverImageBytes) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}/auth/update-cover'),
      );
      request.fields["videoId"] = videoId ?? '';

      if (coverImageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'imagen',
          coverImageBytes,
          filename: 'imagen.png',
          contentType: MediaType('image', 'png'),
        ));
      }

      var response = await request.send();
      await Future.delayed(const Duration(seconds: 1));
      if (response.statusCode == 200) {
        showSucessSnackBar(context, 'Portada cambiada exitosamente!');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const CustomBottomNavigationBarPlayer(initialIndex: 4),
          ),
        );
      } else {
        showErrorSnackBar(context, 'Hubo un error, intentalo de nuevo.');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const CustomBottomNavigationBarPlayer(initialIndex: 4),
          ),
        );
      }
    } catch (e) {
      showErrorSnackBar(context, 'Hubo un error, intentalo de nuevo.');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              const CustomBottomNavigationBarPlayer(initialIndex: 4),
        ),
      );
    }
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
                "Estamos subiendo tu imagen, esto puede tardar unos segundos…",
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
                backgroundColor: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
