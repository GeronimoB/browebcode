import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bro_app_to/Screens/agent/inicio.dart';
import 'package:bro_app_to/Screens/agent/Match.dart';
import 'package:bro_app_to/Screens/mensajes.dart';
import 'package:bro_app_to/Screens/agent/perfil.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int initialIndex;

  const CustomBottomNavigationBar({super.key, this.initialIndex = 0});
  @override
  CustomBottomNavigationBarState createState() =>
      CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    InicioPage(),
    const Matche(),
    MensajesPage(),
    const PerfilPage(),
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
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                List.generate(_pages.length, (index) => _buildNavItem(index)),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final iconNames = ['Inicio.svg', 'Match.svg', 'Mensaje.svg', 'Perfil.svg'];
    final selectedIconNames = [
      'Inicio-1.svg',
      'Match-1.svg',
      'Mensaje-1.svg',
      'Perfil-1.svg'
    ];
    final labels = ['Inicio', 'Match', 'Mensajes', 'Perfil'];

    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
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
    );
  }
}
