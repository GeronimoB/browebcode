import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:bro_app_to/Screens/agregar_tarjeta_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/player_provider.dart';

class MetodoDePagoScreen extends StatefulWidget {
  final double valueToPay;
  const MetodoDePagoScreen({super.key, required this.valueToPay});

  @override
  State<MetodoDePagoScreen> createState() => _MetodoDePagoScreenState();
}

class _MetodoDePagoScreenState extends State<MetodoDePagoScreen> {
  bool cardSelected = false;
  bool transferSelected = false;

  @override
  Widget build(BuildContext context) {
    const double metodoPagoWidth = 325.0;
    const double metodoPagoHeight = 106.0;
    final playerProvider = Provider.of<PlayerProvider>(context, listen: true);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C2C2C), Color(0xFF000000)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'MÉTODO DE PAGO',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF00E050)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                '${widget.valueToPay} €',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF00E050),
                  fontSize: 40,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  cardSelected = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  cardSelected = false;
                });
              },
              onTapCancel: () {
                setState(() {
                  cardSelected = false;
                });
              },
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AgregarTarjetaScreen()),
                );
              },
              child: Container(
                width: metodoPagoWidth,
                height: metodoPagoHeight,
                decoration: BoxDecoration(
                    color: cardSelected ? Colors.black : Colors.white,
                    border:
                        Border.all(color: const Color(0xff05FF00), width: 1.5),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: cardSelected
                        ? [
                            const CustomBoxShadow(
                              color: Color(0xff05FF00),
                              blurRadius: 4,
                            )
                          ]
                        : null),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/Mastercard_icon.png',
                      width: 96,
                      height: 54,
                    ),
                    Image.asset(
                      'assets/images/Visa_icon.png',
                      width: 96,
                      height: 54,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 26),
            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  transferSelected = true;
                  _mostrarMenuTransferencia();
                });
              },
              onTapUp: (_) {
                setState(() {
                  transferSelected = false;
                });
              },
              onTapCancel: () {
                setState(() {
                  transferSelected = false;
                });
              },
              onTap: () async {},
              child: Container(
                width: metodoPagoWidth,
                height: metodoPagoHeight,
                decoration: BoxDecoration(
                    color: transferSelected ? Colors.black : Colors.white,
                    border:
                        Border.all(color: const Color(0xff05FF00), width: 1.5),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: transferSelected
                        ? [
                            const CustomBoxShadow(
                              color: Color(0xff05FF00),
                              blurRadius: 4,
                            )
                          ]
                        : null),
                child: Center(
                  child: Text(
                    "TRANSFERENCIA BANCARIA",
                    style: TextStyle(
                        color: transferSelected
                            ? Colors.white
                            : const Color(0xff1D6937),
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(
                  'assets/icons/Logo.svg',
                  width: 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarMenuTransferencia() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ), // Esta línea le da bordes redondeados al Dialog
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF3B3B3B),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Gracias por tu compra',
                    style: TextStyle(
                      color: Color(0xff05FF00), // Color de los títulos
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800, // ExtraBold
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Titular XXXXXXXXX',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600, // SemiBold
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Banco XXXXXXXXX',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600, // SemiBold
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Cuenta XXXXXXXXXXXXXXXXXX',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600, // SemiBold
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Instrucciones',
                    style: TextStyle(
                      color: Color(0xff05FF00), // Color de los títulos
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800, // ExtraBold
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 11,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: CustomTextButton(
                      text: 'Subir Comprobante',
                      buttonPrimary: true,
                      width: 233,
                      height: 30),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
