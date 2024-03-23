import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/agent/Inicio.dart'; // Importa los archivos de las pantallas
import 'package:bro_app_to/Screens/agent/Match.dart';
import 'package:bro_app_to/Screens/mensajes.dart';
import 'package:bro_app_to/Screens/perfil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int initialIndex;

  const CustomBottomNavigationBar({super.key, this.initialIndex = 0});
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  // Lista de páginas que quieres mostrar en el BottomNavigationBar
  final List<Widget> _pages = [
    InicioPage(),
    Matche(),
    MensajesPage(),
    PerfilPage(),
  ];

  // Lista de nombres de archivos de iconos no seleccionados
  final List<String> _iconNames = [
    'Inicio.svg',
    'Match.svg',
    'Mensaje.svg',
    'Perfil.svg',
  ];

  // Lista de nombres de archivos de iconos seleccionados
  final List<String> _selectedIconNames = [
    'Inicio-1.svg',
    'Match-1.svg',
    'Mensaje-1.svg',
    'Perfil-1.svg',
  ];

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
              icon: _selectedIndex == 2
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
              label: 'Mensajes',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 3
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
