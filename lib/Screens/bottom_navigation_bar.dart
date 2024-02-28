import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/Inicio.dart'; // Importa los archivos de las pantallas
import 'package:bro_app_to/Screens/Match.dart';
import 'package:bro_app_to/Screens/Mensajes.dart';
import 'package:bro_app_to/Screens/Perfil.dart';

class CustomBottomNavigationBar extends StatefulWidget {
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
    'Inicio.png',
    'Match.png',
    'Mensaje.png',
    'Perfil.png',
  ];

  // Lista de nombres de archivos de iconos seleccionados
  final List<String> _selectedIconNames = [
    'Inicio-1.png',
    'Match-1.png',
    'Mensaje-1.png',
    'Perfil-1.png',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black, 
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.black, 
            icon: _selectedIndex == 0
                ? Image.asset(
                    'assets/${_selectedIconNames[0]}',
                    height: 24,
                    width: 24,
                  )
                : Image.asset(
                    'assets/${_iconNames[0]}',
                    height: 24,
                    width: 24,
                  ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black, 
            icon: _selectedIndex == 1
                ? Image.asset(
                    'assets/${_selectedIconNames[1]}',
                    height: 24,
                    width: 24,
                  )
                : Image.asset(
                    'assets/${_iconNames[1]}',
                    height: 24,
                    width: 24,
                  ),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: _selectedIndex == 2
                ? Image.asset(
                    'assets/${_selectedIconNames[2]}',
                    height: 24,
                    width: 24,
                  )
                : Image.asset(
                    'assets/${_iconNames[2]}',
                    height: 24,
                    width: 24,
                  ),
            label: 'Mensajes',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: _selectedIndex == 3
                ? Image.asset(
                    'assets/${_selectedIconNames[3]}',
                    height: 24,
                    width: 24,
                  )
                : Image.asset(
                    'assets/${_iconNames[3]}',
                    height: 24,
                    width: 24,
                  ),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white, 
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
