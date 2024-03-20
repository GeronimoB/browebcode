import 'package:bro_app_to/Screens/bottom_navigation_bar.dart';
import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgregarTarjetaScreen extends StatefulWidget {
  const AgregarTarjetaScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AgregarTarjetaScreenState createState() => _AgregarTarjetaScreenState();
}

class _AgregarTarjetaScreenState extends State<AgregarTarjetaScreen> {
  String tipoTarjeta = 'visa'; // Por defecto seleccionamos Visa
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    String imagenTarjeta = 'visa' == 'visa'
        ? 'assets/images/Visa_icon.png'
        : 'assets/images/Mastercard_icon.png';

    return SafeArea(
        child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF212121), Color(0xFF121212)],
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'MÉTODO DE PAGO',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.transparent, // AppBar transparente
                elevation: 0, // Quitar sombra
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF00E050)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              backgroundColor:
                  Colors.transparent, // Fondo de scaffold transparente
              body: Container(
                padding: const EdgeInsets.all(26.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Disponibles',
                      style: TextStyle(
                          color: Color(0xFF00E050),
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelected = !isSelected;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF00E050)),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: isSelected
                                ? [
                                    const CustomBoxShadow(
                                        color: Color(0xFF00E050), blurRadius: 4)
                                  ]
                                : null),
                        child: ListTile(
                          leading: Image.asset(imagenTarjeta),
                          title: const Text(
                            'Titular XXXXXXXX\nNúmero XXXXXXXXXXXX',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            softWrap: false,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close,
                                color: Color(0xFF00E050)),
                            onPressed: () {
                              // Acción para eliminar tarjeta
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Agregar Tarjeta',
                      style: TextStyle(
                          color: Color(0xFF00E050),
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tipoTarjeta = 'visa';
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: tipoTarjeta == 'visa'
                                      ? Color(0xFF00E050)
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Image.asset('assets/images/Visa_icon.png',
                                  height: 40),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tipoTarjeta = 'mastercard';
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: tipoTarjeta == 'mastercard'
                                      ? Color(0xFF00E050)
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Image.asset('assets/images/Mastercard_icon.png',
                                  height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const TextField(
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 12),
                      decoration: InputDecoration(
                        labelText: 'Nombres del Titular',
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 12),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF00E050))),
                      ),
                    ),
                    const TextField(
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 12),
                      decoration: InputDecoration(
                        labelText: 'Número de Tarjeta',
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 12),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF00E050))),
                      ),
                    ),
                    const TextField(
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 12),
                      decoration: InputDecoration(
                        labelText: 'Fecha de Caducidad',
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 12),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF00E050))),
                      ),
                    ),
                    const TextField(
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 12),
                      decoration: InputDecoration(
                        labelText: 'Código de seguridad',
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 12),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF00E050))),
                      ),
                    ),
                    const SizedBox(height: 35.0),
                    CustomTextButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CustomBottomNavigationBar()),
                          );
                        },
                        text: 'Añadir Tarjeta',
                        buttonPrimary: true,
                        width: 233,
                        height: 30),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child:
                          SvgPicture.asset('assets/icons/Logo.svg', width: 80),
                    ),
                  ],
                ),
              ),
            )));
  }
}
