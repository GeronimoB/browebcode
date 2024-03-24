import 'package:bro_app_to/Screens/player/match_player.dart';
import 'package:bro_app_to/Screens/mensajes_player.dart';
import 'package:bro_app_to/Screens/player/upload_video.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/player_profile.dart';
import 'package:flutter_svg/svg.dart';

final List<Widget> _pages = [
  PlayerProfile(),
  const MatchePlayer(),
  const UploadVideoWidget(),
  const MensajesPage_player(),
  PlayerProfile(),
];

final List<String> _iconNames = [
  'Inicio.svg',
  'Match.svg',
  'Player.svg',
  'Mensaje.svg',
  'Perfil.svg',
];

final List<String> _selectedIconNames = [
  'Inicio-1.svg',
  'Match-1.svg',
  'Player-1.svg',  // Asegúrate de tener este icono para el estado seleccionado, si no, usa 'Player.svg'
  'Mensaje-1.svg',
  'Perfil-1.svg',
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
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        extendBody: true,
        body: _pages[_selectedIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            // Personalización para evitar el efecto blanco
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            canvasColor: Colors.black,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/${_selectedIndex == 0 ? _selectedIconNames[0] : _iconNames[0]}',
                  height: 32,
                  width: 32,
                ),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/${_selectedIndex == 1 ? _selectedIconNames[1] : _iconNames[1]}',
                  height: 32,
                  width: 32,
                ),
                label: 'Match',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/${_selectedIndex == 2 ? _selectedIconNames[2] : _iconNames[2]}',
                  height: 32,
                  width: 32,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/${_selectedIndex == 3 ? _selectedIconNames[3] : _iconNames[3]}',
                  height: 32,
                  width: 32,
                ),
                label: 'Mensajes',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/${_selectedIndex == 4 ? _selectedIconNames[4] : _iconNames[4]}',
                  height: 32,
                  width: 32,
                ),
                label: 'Perfil',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.8),
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
