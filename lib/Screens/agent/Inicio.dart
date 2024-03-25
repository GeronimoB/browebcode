import 'dart:convert';

import 'package:bro_app_to/Screens/agent/match_profile.dart';
import 'package:bro_app_to/providers/agent_provider.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:bro_app_to/utils/initial_video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/slidedable_video.dart';

class InicioPage extends StatefulWidget {
  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  double _xOffset = 0.0;
  double _rotation = 0.0;
  int _currentIndex = 0;
  List<InitialVideoModel> _videoUrls = [];
  late UserProvider provider;
  int currentUserId = 0;
  bool changeVideo = true;

  @override
  void initState() {
    super.initState();
    _fetchVideoUrls();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<UserProvider>(context, listen: false);
    currentUserId = provider.getCurrentUser().userId;
  }

  Future<void> _fetchVideoUrls() async {
    try {
      final response = await ApiClient().post('auth/random-videos', {"a": "a"});
      if (response.statusCode == 200) {
        final videos = jsonDecode(response.body)["video"];
        final List<InitialVideoModel> videosA = mapListToInitialVideos(videos);
        setState(() {
          _videoUrls = videosA;
        });
      } else {
        throw Exception('Error al obtener las URLs de los videos');
      }
    } catch (error) {
      print('Error al obtener las URLs de los videos: $error');
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _xOffset += details.primaryDelta!;
      _rotation = -_xOffset / 1000;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) async {
    if (_xOffset > 100) {
      final userId = _videoUrls[_currentIndex].userId;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _videoUrls.length;
      });
      _writeMatchData(userId);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MatchProfile(userId: userId)),
      );
    } else if (_xOffset < -100) {
      setState(() {
        changeVideo = false;
        //_currentIndex = (_currentIndex + 1) % _videoUrls.length;
      });
    }
    setState(() {
      _xOffset = 0;
      _rotation = 0;
    });
  }

  Future<void> _writeMatchData(int userId) async {
    await FirebaseFirestore.instance
        .collection('Matches')
        .doc('agente-$currentUserId')
        .collection('AgentMatches')
        .doc('jugador-$userId')
        .set(
      {
        'playerId': 'jugador-$userId',
        'createdAt': Timestamp.now(),
      },
    );

    await FirebaseFirestore.instance
        .collection('Matches')
        .doc('jugador-$userId')
        .collection('PlayerMatches')
        .doc('agente-$currentUserId')
        .set({
      'agentId': 'agente-$currentUserId',
      'createdAt': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1 - (_xOffset.abs() * 0.001);
    double height = MediaQuery.of(context).size.height;
    Widget child;

    if (_videoUrls.isEmpty) {
      child = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Cargando videos...'),
          ],
        ),
      );
    } else {
      child = SlidableVideo(
          videoUrl: _videoUrls[_currentIndex].url,
          nextVideoUrl: _videoUrls[_currentIndex + 1].url,
          showCurrentVideo: changeVideo);
    }
    return SizedBox(
      height: height * 0.9,
      child: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Transform.scale(
                scale: scale,
                child: Transform.rotate(
                  angle: _rotation,
                  child: Transform.translate(
                      offset: Offset(_xOffset, 0), child: child),
                ),
              ),
            ),
            if (_xOffset > 0)
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 50,
                right: 0,
                child: SvgPicture.asset(
                  'assets/icons/Matchicon.svg',
                  width: 200,
                  height: 200,
                ),
              ),
            if (_xOffset < 0)
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 50,
                left: 5,
                child: SvgPicture.asset(
                  'assets/icons/No Match.svg',
                  width: 200,
                  height: 200,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
