import 'package:bro_app_to/Screens/Match_player.dart';
import 'package:bro_app_to/Screens/Mensajes_player.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/player_profile.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBarPlayer extends StatefulWidget {
  @override
  _CustomBottomNavigationBarPlayerState createState() =>
      _CustomBottomNavigationBarPlayerState();
}

class _CustomBottomNavigationBarPlayerState
    extends State<CustomBottomNavigationBarPlayer> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PlayerProfile(),
    MatchePlayer(),
    PlayerIcon(), 
    MensajesPage_player(),
    PlayerProfile(),
  ];

  final List<String?> _iconNames = [
    'Inicio.svg',
    'Match.svg',
    'Player.svg', 
    'Mensaje.svg',
    'Perfil.svg',
  ];

  final List<String> _selectedIconNames = [
    'Inicio-1.svg',
    'Match-1.svg',
    'Player.svg', 
    'Mensaje-1.svg',
    'Perfil-1.svg',
  ];

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
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? SvgPicture.asset(
                      'assets/icons/${_selectedIconNames[0]}',
                      height: 32,
                      width: 32,
                    )
                  : SvgPicture.asset(
                      'assets/icons/${_iconNames[0]}',
                      height: 32,
                      width: 32,
                    ),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? SvgPicture.asset(
                      'assets/icons/${_selectedIconNames[1]}',
                      height: 32,
                      width: 32,
                    )
                  : SvgPicture.asset(
                      'assets/icons/${_iconNames[1]}',
                      height: 32,
                      width: 32,
                    ),
              label: 'Match',
            ),
                        BottomNavigationBarItem(
              icon: _selectedIndex == 3
                  ? SvgPicture.asset(
                      'assets/icons/${_selectedIconNames[2]}',
                      height: 32,
                      width: 32,
                    )
                  : SvgPicture.asset(
                      'assets/icons/${_iconNames[2]}',
                      height: 32,
                      width: 32,
                    ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? SvgPicture.asset(
                      'assets/icons/${_selectedIconNames[3]}',
                      height: 32,
                      width: 32,
                    )
                  : SvgPicture.asset(
                      'assets/icons/${_iconNames[3]}',
                      height: 32,
                      width: 32,
                    ),
              label: 'Mensajes',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 3
                  ? SvgPicture.asset(
                      'assets/icons/${_selectedIconNames[4]}',
                      height: 32,
                      width: 32,
                    )
                  : SvgPicture.asset(
                      'assets/icons/${_iconNames[4]}',
                      height: 32,
                      width: 32,
                    ),
              label: 'Perfil',
            ),
            
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class PlayerIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      child: const Icon(
        Icons.sports_soccer, // Cambia este icono según tus necesidades
        color: Colors.white,
      ),
    );
  }
}
