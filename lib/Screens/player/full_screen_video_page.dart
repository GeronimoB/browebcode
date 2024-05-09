import 'dart:io';

import 'package:bro_app_to/Screens/agent/bottom_navigation_bar.dart';
import 'package:bro_app_to/Screens/metodo_pago_screen.dart';
import 'package:bro_app_to/components/modal_decision.dart';
import 'package:bro_app_to/components/snackbar.dart';
import 'package:bro_app_to/providers/player_provider.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:bro_app_to/utils/video_model.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../components/custom_text_button.dart';
import '../../utils/api_client.dart';
import 'bottom_navigation_bar_player.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

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

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: offset.dx + size.width - 230,
            top: offset.dy + 95,
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
                        translations!['save'],
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
    final videoHeight = MediaQuery.of(context).size.height - 100;
    return Stack(
      children: [
        GestureDetector(
          onTap: _togglePlayPause,
          child: _controller.value.isInitialized
              ? SizedBox(
                  width: double.maxFinite,
                  height: videoHeight,
                  child: VideoPlayer(_controller),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                  ),
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
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => widget.showOptions
                      ? const CustomBottomNavigationBarPlayer(
                          initialIndex: 4,
                        )
                      : const CustomBottomNavigationBar(
                          initialIndex: 3,
                        ),
                ),
              );
            },
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
                icon: const Icon(Icons.more_horiz, color: Color(0xFF00E050)),
                onPressed: () {
                  _showCustomMenu(context);
                },
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          left: MediaQuery.of(context).size.width / 2 - 52,
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
          bottom: MediaQuery.of(context).size.height - videoHeight - 2,
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
            opacity: _showPauseIcon || !_controller.value.isPlaying ? 1.0 : 0.0,
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
    );
  }

  Future<void> _handleDownload(Video video) async {
    String? videoUrl = video.videoUrl;
    if (videoUrl == null || videoUrl.isEmpty) {
      return;
    }
    final status = await Permission.storage.status;

    if (!status.isGranted) {
      final result = await Permission.storage.request();
      if (!result.isGranted) {
        showErrorSnackBar(context, translations!['download_grant_denied']);
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
      final videoExtension = path.extension(videoUrl);
      final response = await http.get(Uri.parse(videoUrl));
      final downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

      final apkFile = File(
          '${downloadsDirectory!.path}/video_${video.id}_${DateTime.now().millisecondsSinceEpoch}.$videoExtension');

      await apkFile.writeAsBytes(response.bodyBytes);

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
                      translations!['congrats'],
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
                      translations!['video_save'],
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
                      child: translations!['ok'],
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
            title: Text(translations!['error_label']),
            content: Text(translations!['download_error']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(translations!['ok']),
              ),
            ],
          );
        },
      );

      debugPrint(e.toString());
    }
  }

  void _showConfirmationDeleteDialog(int videoId) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (BuildContext context) {
        return ModalDecition(
          text: translations!['delete_video_confirmation'],
          confirmCallback: () async {
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
}
