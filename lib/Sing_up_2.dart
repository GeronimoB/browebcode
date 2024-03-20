import 'package:flutter/material.dart';
import 'package:bro_app_to/Sing_up_3.dart';
import 'package:flutter_svg/svg.dart';

class SignUpScreen_2 extends StatefulWidget {
  @override
  _SignUpScreen_2State createState() => _SignUpScreen_2State();
}

class _SignUpScreen_2State extends State<SignUpScreen_2> {
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
              'assets/images/backgroundplanes.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50), // Espacio en la parte superior
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 120),
                child: Text(
                  'Planes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 4, // Actualizar con la cantidad real de planes
                  itemBuilder: (context, index) {
                    return _buildCard(index);
                  },
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
                    foregroundColor: Colors.white, backgroundColor: Color(0xFF00F056),
                    minimumSize: const Size(double.infinity, 50),
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
                  'assets/images/Logo.png',
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
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.lightGreen : Color(0xFF00F056), width: 2),
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
                    color: Color(0xFF00F056),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Total: 00,0€',
                  style: TextStyle(
                    color: Color(0xFF00F056),
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
                color: Color(0xFF00F056),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
