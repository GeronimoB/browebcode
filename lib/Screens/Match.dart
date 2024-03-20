import 'package:flutter/material.dart';

class Matche extends StatefulWidget {
  const Matche({super.key});

  @override
  _MatcheState createState() => _MatcheState();
}

class _MatcheState extends State<Matche> {
  final List<bool> _isSelected = [false, false, false]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF212121), Color(0xFF121212)], 
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 68.0, bottom: 20),
              child: Align(
                alignment: Alignment.center,
                child: Text('Match',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _isSelected.length,
                itemBuilder: (context, index) {
                  return _buildMatchComponent('assets/images/jugador1.png', 'Nombre Jugador ${index + 1}', 'Descripción Jugador ${index + 1}', index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildMatchComponent(String imagePath, String playerName, String playerDescription, int index) {
  return GestureDetector(
    onTap: () {
      setState(() {
        _isSelected[index] = !_isSelected[index]; 
      });
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 00),
      curve: Curves.easeInOut,
      height: _isSelected[index] ? 260 : 109, // Ajusta la altura aquí para acomodar el tamaño de la imagen
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width * 0.95, 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_isSelected[index] ? 50 : 100, ), 
        border: Border.all(
          color: Colors.green,
          width: 2.0,
        ),
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Asegúrate de que la columna no ocupe más espacio del necesario
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinea los elementos del Row en la parte superior
            children: [
              Container(
                width: 105.0,
                height: 105.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 30), // Espacio entre la imagen y el texto
              Expanded( // Asegura que el texto no desborde
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinea el texto a la izquierda
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      playerName,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      playerDescription,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (_isSelected[index]) ...[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16.0), // Asegúrate de que el padding izquierdo coincida con cualquier otro padding que quieras alinear
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    const SizedBox(height: 10),
                  Text(
                    'Escuela deportiva en la que juega',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5.0), // Controla el espacio entre los textos ajustando el SizedBox
                  Text(
                    'Logro individuales',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Selección Nacional Masculina 18',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 2.0, color: Colors.green),
                    textStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    fixedSize: const Size(132, 30),
                  ),
                  child: const Text('¡Vamos al Chat!',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                    ),),
                  
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    fixedSize: const Size(132, 30),
                  ),
                  child: const Text('Ver Perfil'),
                ),
              ],
            ),

          ],
        ],
      ),
    ),
  );
}

}