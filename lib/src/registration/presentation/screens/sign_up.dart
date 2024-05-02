import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../components/custom_text_button.dart';
import '../../../../components/i_field.dart';
import '../../../../providers/player_provider.dart';

import '../../../../utils/api_client.dart';
import '../../../../utils/current_state.dart';
import '../../../../utils/language_localizations.dart';
import 'select_camp.dart';

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
  late TextEditingController dniController;
  late TextEditingController referralCodeCtlr;

  Future<bool> validateAndCheckEmail(BuildContext context, String email,
      String name, String lastName, DateTime fecha, String password) async {
    if (email.isEmpty ||
        lastName.isEmpty ||
        dniController.text.isEmpty ||
        fecha == DateTime.now() ||
        password.isEmpty ||
        name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(translations!['complete_all_fields'])),
      );
      return false;
    }

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(translations!['valid_email'])),
      );
      return false;
    }
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(translations!['valid_pssw'])),
      );
      return false;
    }

    try {
      final response =
          await ApiClient().post('auth/verify-email', {"email": email});

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(translations!['email_in_use'])),
        );
        return false;
      }
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(translations!['error_try_again']),
        ),
      );
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(translations!['error_try_again']),
        ),
      );
      return false;
    }
    if (referralCodeCtlr.text.isNotEmpty) {
      try {
        final response = await ApiClient().post(
          'auth/referralCode',
          {"code": referralCodeCtlr.text},
        );

        if (response.statusCode != 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(translations!['ref_code_no_exist'])),
          );
          referralCodeCtlr.text = "";
          return false;
        }
        return true;
      } on TimeoutException {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(translations!['error_try_again']),
          ),
        );
        return false;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(translations!['error_try_again']),
          ),
        );
        return false;
      }
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    dniController = TextEditingController();
    nameController = TextEditingController();
    passwordController = TextEditingController();
    _selectedDate = DateTime.now();
    mailController = TextEditingController();
    lastNameController = TextEditingController();
    referralCodeCtlr = TextEditingController();
  }

  @override
  void dispose() {
    dniController.dispose();
    nameController.dispose();
    passwordController.dispose();
    mailController.dispose();
    lastNameController.dispose();
    referralCodeCtlr.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final LanguageLocalizations? localizations =
        LanguageLocalizations.of(context);
    Locale? locale = localizations?.locale;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: locale,
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
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    translations!['sign_up'],
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  iField(nameController, translations!['name']),
                  const SizedBox(height: 10),
                  iField(lastNameController, translations!['last_name']),
                  const SizedBox(height: 10),
                  iField(dniController, translations!['dni_label']),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: translations!['birthdate'],
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF00E050), width: 2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          const Icon(Icons.calendar_today, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  iField(mailController, translations!['personal_email']),
                  const SizedBox(height: 10),
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: _formKey,
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: translations!['password'],
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
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
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                          return translations!['enter_password'];
                        }
                        if (value.length < 8) {
                          return translations!['pssw_8_characters'];
                        }
                        // Verifica si contiene al menos una mayúscula
                        if (!value.contains(RegExp(r'[A-Z]'))) {
                          return translations!['pssw_mayus_letter'];
                        }
                        // Verifica si contiene al menos una minúscula
                        if (!value.contains(RegExp(r'[a-z]'))) {
                          return translations!['pssw_minus_letter'];
                        }
                        // Verifica si contiene al menos un número
                        if (!value.contains(RegExp(r'[0-9]'))) {
                          return translations!['pssw_number'];
                        }
                        // Verifica si contiene al menos un carácter especial
                        if (!value
                            .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                          return translations!['pssw_special'];
                        }
                        return null; // Retorna null si la contraseña cumple con todos los requisitos
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  iField(referralCodeCtlr, translations!['referral_code']),
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
                            dni: dniController.text,
                            codigoReferido: referralCodeCtlr.text,
                            email: mailController.text,
                            name: nameController.text,
                            lastName: lastNameController.text,
                            birthDate: _selectedDate,
                            password: passwordController.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SelectCamp(registrando: true)),
                        );
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    text: translations!['next'],
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
          ),
          if (isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black
                  .withOpacity(0.5), // Color de fondo semitransparente
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}