import 'package:flutter/material.dart';
import 'package:bro_app_to/Sing_up_3.dart';
import 'package:flutter_svg/svg.dart';

class SignUpScreen_2 extends StatefulWidget {
  @override
  _SignUpScreen_2State createState() => _SignUpScreen_2State();
}

class _SignUpScreen_2State extends State<SignUpScreen_2> {
  String _selectedMenu = 'Mensual'; // Menú seleccionado por defecto
  int _selectedCardIndex = -1; // Índice de la tarjeta seleccionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 0, 0, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/Background_3.png', // Nombre de la imagen del fondo
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20), // Aumentado para más espacio arriba
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMenu = 'Mensual';
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top:
                                BorderSide(color: Colors.transparent, width: 2),
                            left:
                                BorderSide(color: Colors.transparent, width: 2),
                            bottom:
                                BorderSide(color: Colors.transparent, width: 2),
                          ),
                        ),
                        child: Text(
                          'Mensual',
                          style: TextStyle(
                            color: _selectedMenu == 'Mensual'
                                ? Colors.green
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMenu = 'Anual';
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top:
                                BorderSide(color: Colors.transparent, width: 2),
                            right:
                                BorderSide(color: Colors.transparent, width: 2),
                            bottom:
                                BorderSide(color: Colors.transparent, width: 2),
                          ),
                        ),
                        child: Text(
                          'Anual',
                          style: TextStyle(
                            color: _selectedMenu == 'Anual'
                                ? Colors.green
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 2,
                color: Colors.green,
              ),
              const SizedBox(height: 0),
              Expanded(
                child: ListView(
                  children: [
                    _buildCard(0),
                    _buildCard(1),
                    _buildCard(2),
                    _buildCard(3),
                    // Agrega más llamadas a _buildCard() según sea necesario
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen_3()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Colors.green, // Text Color (Foreground color)
                    minimumSize:
                        const Size(double.infinity, 50), // Set width and height
                  ),
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  width: 104,
                  'assets/images/Logo.png',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index) {
    bool isSelected = _selectedCardIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCardIndex = index;
        });
      },
      child: Container(
        height: 129,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? Colors.lightGreen : Colors.green, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  width: 62,
                  height: 32,
                  'assets/images/Logo.png',
                ),
                const SizedBox(
                    width: 10), // Espacio entre el logo y el texto "Basic"
                const Text(
                  'Basic',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Total: 00,0€',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Que Incluye:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed diam nonummy nibh euismod ...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Text(
              'Ver más...',
              style: TextStyle(
                color: Colors.green,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
