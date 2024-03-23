import 'dart:async';

import 'package:bro_app_to/utils/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../components/custom_text_button.dart';
import '../../../../providers/player_provider.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/api_client.dart';
import 'sign_up_2.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool isLoading = false;
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late DateTime _selectedDate;
  late TextEditingController mailController;
  late TextEditingController passwordController;

  Future<bool> validateAndCheckEmail(BuildContext context, String email,
      String name, String lastName, DateTime fecha, String password) async {
    if (email.isEmpty ||
        lastName.isEmpty ||
        fecha == DateTime.now() ||
        password.isEmpty ||
        name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Por favor, complete todos los campos.')),
      );
      return false;
    }

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.redAccent,
            content:
                Text('Por favor, introduce un correo electrónico válido.')),
      );
      return false;
    }
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Ingrese una contraseña valida.')),
      );
      return false;
    }

    try {
      final response =
          await ApiClient().post('auth/verify-email', {"email": email});

      if (response.statusCode != 200) {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text('El correo electrónico ya está en uso.')),
        );
        return false;
      }
      return true;
    } on TimeoutException {
      // Si se produce un timeout, muestra un mensaje de error y devuelve false
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content:
              Text('Se ha producido un error. Por favor, inténtalo de nuevo.'),
        ),
      );
      return false;
    } catch (e) {
      // Captura cualquier otra excepción y muestra un mensaje de error genérico
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content:
              Text('Se ha producido un error. Por favor, intentelo de nuevo.'),
        ),
      );
      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    passwordController = TextEditingController();
    _selectedDate = DateTime.now();
    mailController = TextEditingController();
    lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    mailController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

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
              'assets/images/Background_3.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
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
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
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
                          BorderSide(color: Color(0xFF00E050), width: 2),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Apellidos',
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
                          BorderSide(color: Color(0xFF00E050), width: 2),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat'),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Nacimiento',
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF00E050), width: 2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        Icon(Icons.calendar_today, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: mailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Personal - Tutor (-18 años)',
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
                          BorderSide(color: Color(0xFF00E050), width: 2),
                    ),
                  ),
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                ),
                const SizedBox(height: 10),
                Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: _formKey,
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                      errorStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 106, 106),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF00E050), width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors.white, fontFamily: 'Montserrat'),
                    obscureText: obscureText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa una contraseña.';
                      }
                      if (value.length < 8) {
                        return 'La contraseña debe tener al menos 8 caracteres.';
                      }
                      // Verifica si contiene al menos una mayúscula
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'La contraseña debe contener al menos una letra mayúscula.';
                      }
                      // Verifica si contiene al menos una minúscula
                      if (!value.contains(RegExp(r'[a-z]'))) {
                        return 'La contraseña debe contener al menos una letra minúscula.';
                      }
                      // Verifica si contiene al menos un número
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'La contraseña debe contener al menos un número.';
                      }
                      // Verifica si contiene al menos un carácter especial
                      if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        return 'La contraseña debe contener al menos un carácter especial.';
                      }
                      return null; // Retorna null si la contraseña cumple con todos los requisitos
                    },
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextButton(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      isLoading = true; // Mostrar el loader
                    });
                    bool isValid = await validateAndCheckEmail(
                        context,
                        mailController.text,
                        nameController.text,
                        lastNameController.text,
                        _selectedDate,
                        passwordController.text);
                    if (isValid) {
                      final playerProvider =
                          Provider.of<PlayerProvider>(context, listen: false);
                      playerProvider.updateTemporalPlayer(
                          email: mailController.text,
                          name: nameController.text,
                          lastName: lastNameController.text,
                          birthDate: _selectedDate,
                          password: passwordController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen2()),
                      );
                    }
                    setState(() {
                      isLoading = false; // Ocultar el loader
                    });
                  },
                  text: 'Siguiente',
                  buttonPrimary: true,
                  width: 116,
                  height: 39,
                ),
                SizedBox(
                  height: 90,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset(
                      width: 104,
                      'assets/icons/Logo.svg',
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black
                  .withOpacity(0.5), // Color de fondo semitransparente
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green), // Color del loader
                ),
              ),
            ),
        ],
      ),
    );
  }
}
