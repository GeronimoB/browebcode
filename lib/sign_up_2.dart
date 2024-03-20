import 'package:bro_app_to/Screens/select_camp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'components/custom_dropdown.dart';
import 'components/custom_text_button.dart';

class SignUpScreen2 extends StatelessWidget {
  const SignUpScreen2({super.key});

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
              'assets/images/BackgroundRegis.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Pie dominante',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownWidget<String>(
                      value: 'Zurdo',
                      items: ['Zurdo', 'Diestro', 'Ambidiestro'].toList(),
                      onChanged: (String? newValue) {
                        // Handle dropdown value change
                      },
                      itemBuilder: (String item) {
                        return item;
                      },
                      width: 120,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Selección nacional',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownWidget<String>(
                      value: 'Masculina',
                      items: ['Masculina', 'Femenino'].toList(),
                      onChanged: (String? newValue) {
                        // Handle dropdown value change
                      },
                      itemBuilder: (String item) {
                        return item;
                      },
                      width: 120,
                    ),
                    const SizedBox(width: 10),
                    DropdownWidget<String>(
                      value: '12',
                      items: ['12', '13', '14', '15', '16'].toList(),
                      onChanged: (String? newValue) {
                        // Handle dropdown value change
                      },
                      itemBuilder: (String item) {
                        return item;
                      },
                      width: 70,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Código Afiliado',
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
                const SizedBox(height: 25),
                CustomTextButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectCamp()),
                      );
                    },
                    text: 'Siguiente',
                    buttonPrimary: true,
                    width: 116,
                    height: 39),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: MediaQuery.of(context).size.width / 2 - 52,
            child: Image.asset(
              width: 104,
              'assets/images/Logo.png',
            ),
          ),
        ],
      ),
    );
  }
}
