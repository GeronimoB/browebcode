import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPage extends StatefulWidget {
  final String videoPath;

  const FullScreenVideoPage({Key? key, required this.videoPath})
      : super(key: key);

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    Uri url = Uri.parse(widget.videoPath);
    _controller = VideoPlayerController.networkUrl(url)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 8.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF00E050)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            right: 8.0,
            child: Theme(
              data: Theme.of(context).copyWith(
                iconTheme: const IconThemeData(color: Color(0xFF00E050)),
              ),
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Color(0xFF00E050)),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  side: BorderSide(color: Color(0xFF00E050)),
                ),
                color: const Color(0xff3B3B3B),
                onSelected: (String result) {},
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                      child: Text('Borrar',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic)),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'destacar',
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                      child: Text('Destacar',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic)),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                      child: Text('Editar',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic)),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                      child: Text('Guardar',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic)),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                      child: Text('Ocultar',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontStyle: FontStyle.italic)),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              color: Colors.black,
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/Logo.svg',
                  fit: BoxFit.fitWidth,
                  width: 100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
