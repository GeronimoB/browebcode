import 'package:flutter/material.dart';
import 'package:bro_app_to/Sing_up_3.dart';
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
            color: Color.fromARGB(255, 0, 0, 0),
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
              SizedBox(height: 5),
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
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.transparent, width: 2),
                            left: BorderSide(color: Colors.transparent, width: 2),
                            bottom: BorderSide(color: Colors.transparent, width: 2),
                          ),
                        ),
                        child: Text(
                          'Mensual',
                          style: TextStyle(
                            color: _selectedMenu == 'Mensual' ? Colors.green : Colors.white,
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
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.transparent, width: 2),
                            right: BorderSide(color: Colors.transparent, width: 2),
                            bottom: BorderSide(color: Colors.transparent, width: 2),
                          ),
                        ),
                        child: Text(
                          'Anual',
                          style: TextStyle(
                            color: _selectedMenu == 'Anual' ? Colors.green : Colors.white,
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
              SizedBox(height: 0),
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
              ElevatedButton(
                  onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen_3()), 
                      );
                  },
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/Logo.png', // Nombre de la imagen del logo
                  width: 104,
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
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.lightGreen : Colors.green, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/Logo.png', // Nombre de la imagen del logo
                  width: 62, // Ancho del logo
                  height: 32, // Alto del logo
                ),
                SizedBox(width: 10), // Espacio entre el logo y el texto "Basic"
                Text(
                  'Basic',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Spacer(),
                Text(
                  'Total: 00,0€',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              'Que Incluye:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed diam nonummy nibh euismod ...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
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
