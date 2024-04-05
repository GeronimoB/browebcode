import 'dart:async';

import 'package:bro_app_to/components/custom_dropdown.dart';
import 'package:bro_app_to/src/registration/presentation/screens/select_camp.dart';
import 'package:bro_app_to/utils/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../components/custom_text_button.dart';
import '../../../../providers/player_provider.dart';
import '../../../../utils/current_state.dart';

class SignUpScreen2 extends StatefulWidget {
  const SignUpScreen2({super.key});

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  bool isLoading = false;
  late TextEditingController dniController;
  late TextEditingController countryController;
  late TextEditingController stateController;
  late TextEditingController categoryController;
  late TextEditingController clubController;
  late TextEditingController achivementController;
  late TextEditingController referralCodeCtlr;
  late TextEditingController heightController;
  String dominantFoot = translations!['left_feet'];
  String selection = translations!['male'];
  String catSelection = '12';

  Future<bool> validateForm(BuildContext context) async {
    if (dniController.text.isEmpty ||
        countryController.text.isEmpty ||
        stateController.text.isEmpty ||
        categoryController.text.isEmpty ||
        clubController.text.isEmpty ||
        achivementController.text.isEmpty ||
        heightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(translations!['complete_all_fields'])),
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
        // Captura cualquier otra excepción y muestra un mensaje de error genérico
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
    countryController = TextEditingController();
    clubController = TextEditingController();
    heightController = TextEditingController();
    categoryController = TextEditingController();
    stateController = TextEditingController();
    achivementController = TextEditingController();
    referralCodeCtlr = TextEditingController();
  }

  @override
  void dispose() {
    dniController.dispose();
    countryController.dispose();
    clubController.dispose();
    categoryController.dispose();
    stateController.dispose();
    achivementController.dispose();
    referralCodeCtlr.dispose();
    super.dispose();
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
              'assets/images/BackgroundRegis.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 145.0, 24, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  translations!['sign_up'],
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: dniController,
                  decoration: InputDecoration(
                    labelText: translations!['dni_label'],
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00F056), width: 2),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat'),
                ),
                TextField(
                  controller: countryController,
                  decoration: InputDecoration(
                    labelText: translations!['country_label'],
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00F056), width: 2),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat'),
                ),
                TextField(
                  controller: stateController,
                  decoration: InputDecoration(
                    labelText: translations!['state_label'],
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00F056), width: 2),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat'),
                ),
                TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: translations!['height_label'],
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: translations!['category_label'],
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00F056), width: 2),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat'),
                ),
                TextField(
                  controller: clubController,
                  decoration: InputDecoration(
                    labelText: translations!['club_label'],
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00F056), width: 2),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat'),
                ),
                TextField(
                  controller: achivementController,
                  decoration: InputDecoration(
                    labelText: translations!['individual_achievements'],
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00F056), width: 2),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat'),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      translations!['individual_achievements'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownWidget<String>(
                      value: dominantFoot,
                      items: [
                        translations!['left_feet'].toString(),
                        translations!['right_feet'].toString(),
                        translations!['both_feet'].toString(),
                      ].toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dominantFoot = newValue ?? translations!['left_feet'];
                        });
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
                    Text(
                      translations!['left_feet'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownWidget<String>(
                      value: selection,
                      items: [
                        translations!['male'].toString(),
                        translations!['female'].toString(),
                      ].toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selection = newValue ?? translations!['male'];
                        });
                      },
                      itemBuilder: (String item) {
                        return item;
                      },
                      width: 120,
                    ),
                    const SizedBox(width: 10),
                    DropdownWidget<String>(
                      value: catSelection,
                      items: ['12', '13', '14', '15', '16'].toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          catSelection = newValue ?? '12';
                        });
                      },
                      itemBuilder: (String item) {
                        return item;
                      },
                      width: 70,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: referralCodeCtlr,
                  decoration: InputDecoration(
                    labelText: translations!['referral_code'],
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00F056), width: 2),
                    ),
                  ),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Montserrat'),
                ),
                const SizedBox(height: 55),
                CustomTextButton(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      FocusScope.of(context).unfocus();

                      bool isValid = await validateForm(
                        context,
                      );
                      if (isValid) {
                        final playerProvider =
                            Provider.of<PlayerProvider>(context, listen: false);
                        playerProvider.updateTemporalPlayer(
                          dni: dniController.text,
                          pais: countryController.text,
                          provincia: stateController.text,
                          categoria: categoryController.text,
                          club: categoryController.text,
                          logros: achivementController.text,
                          codigoReferido: referralCodeCtlr.text,
                          altura: heightController.text,
                          pieDominante: dominantFoot,
                          seleccion: selection,
                          categoriaSeleccion: catSelection,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelectCamp(
                                    registrando: true,
                                  )),
                        );
                      }
                      setState(() {
                        isLoading = false; // Ocultar el loader
                      });
                    },
                    text: translations!['next'],
                    buttonPrimary: true,
                    width: 116,
                    height: 39),
                const SizedBox(height: 85),
                SvgPicture.asset(
                  width: 104,
                  'assets/icons/Logo.svg',
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
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
