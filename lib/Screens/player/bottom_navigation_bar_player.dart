import 'package:bro_app_to/Screens/mensajes.dart';
import 'package:bro_app_to/Screens/player/match_player.dart';
import 'package:bro_app_to/Screens/player/upload_video.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/player_profile.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'home_page/home_page_videos.dart';

import 'dart:html' as html;

void preventBackNavigation() {
  html.window.history.pushState(null, '', html.window.location.href);
  html.window.onPopState.listen((event) {
    html.window.history.pushState(null, '', html.window.location.href);
  });
}

final List<Widget> _pages = [
  const HomePageVideosScreen(),
  const MatchePlayer(),
  const UploadVideoWidget(),
  const MensajesPage(),
  const PlayerProfile(),
];

class CustomBottomNavigationBarPlayer extends StatefulWidget {
  final int initialIndex;

  const CustomBottomNavigationBarPlayer({super.key, this.initialIndex = 0});

  @override
  CustomBottomNavigationBarPlayerState createState() =>
      CustomBottomNavigationBarPlayerState();
}

class CustomBottomNavigationBarPlayerState
    extends State<CustomBottomNavigationBarPlayer> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    preventBackNavigation();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 530),
          child: Container(
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
              extendBody: true,
              body: _pages[_selectedIndex],
              bottomNavigationBar: Container(
                height: 70,
                padding: const EdgeInsets.all(8),
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                      _pages.length, (index) => _buildNavItem(index)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final List<String> iconNames = [
      'Inicio.svg',
      'Match.svg',
      'Player.svg',
      'Mensaje.svg',
      'Perfil.svg',
    ];

    final List<String> selectedIconNames = [
      'Inicio-1.svg',
      'Match-1.svg',
      'Player.svg',
      'Mensaje-1.svg',
      'Perfil-1.svg',
    ];
    final labels = ['Inicio', 'Match', '', 'Mensajes', 'Perfil'];

    return SizedBox(
      width: 75,
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            index == 3
                ? Consumer<UserProvider>(
                    builder: (context, provider, _) => Stack(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/icons/${_selectedIndex == index ? selectedIconNames[index] : iconNames[index]}',
                          height: 32,
                          width: 32,
                        ),
                        provider.unreadTotalMessages != 0
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    provider.unreadTotalMessages.toString(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xff00E050),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  )
                : SvgPicture.asset(
                    'assets/icons/${_selectedIndex == index ? selectedIconNames[index] : iconNames[index]}',
                    height: 32,
                    width: 32,
                  ),
            Text(
              labels[index],
              style: TextStyle(
                color: _selectedIndex == index
                    ? Colors.white
                    : Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
