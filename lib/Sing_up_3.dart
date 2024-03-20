import 'package:bro_app_to/Screens/SelectCamp.dart';
import 'package:flutter/material.dart';

class SignUpScreen_3 extends StatelessWidget {
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
              'assets/BackgroundRegis.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Regístrate',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Pais',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00F056), width: 2),
                    ),
                  ),
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                ),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Provincia',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00F056), width: 2),
                    ),
                  ),
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                ),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Altura',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00F056), width: 2),
                    ),
                  ),
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                ),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Categoría en la que juega',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00F056), width: 2),
                    ),
                  ),
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                ),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Club/Escuela deportivo/a en el/la que juega',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00F056), width: 2),
                    ),
                  ),
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                ),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Logros individuales',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00F056), width: 2),
                    ),
                  ),
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                ),
                const SizedBox(height: 10),
                // Modificando el primer DropdownButtonFormField
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFF00F056), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Pie dominante',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                        ),
                        dropdownColor: Colors.transparent,
                        items: ['Zurdo', 'Diestro', 'Ambidiestro']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: Colors
                                    .white, // Establece el color del texto como blanco
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          // Handle dropdown value change
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                // Modificando el segundo DropdownButtonFormField
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFF00F056), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Selección nacional',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                        ),
                        dropdownColor: Colors.transparent,
                        items: [
                          'Selección Nacional Masculina',
                          'Selección Nacional Femenina'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          // Handle dropdown value change
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectCamp()),
                    );
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            horizontal: 20)), // Ajuste del ancho del botón
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF00F056)), // Cambio de color de fondo a verde
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Bordes redondeados
                      ),
                    ),
                  ),
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: Colors.black,
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/Logo.png',
                    width: 104,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
