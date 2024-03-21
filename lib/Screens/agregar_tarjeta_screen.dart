import 'package:bro_app_to/Screens/bottom_navigation_bar.dart';
import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/api_client.dart';

class AgregarTarjetaScreen extends StatefulWidget {
  const AgregarTarjetaScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AgregarTarjetaScreenState createState() => _AgregarTarjetaScreenState();
}

class _AgregarTarjetaScreenState extends State<AgregarTarjetaScreen> {
  String tipoTarjeta = 'Visa';
  bool isSelected = false;
  late TextEditingController nombresTitularCtlr;
  late TextEditingController numeroTarjetaCtlr;
  late TextEditingController fechaCaducidadCtlr;
  late TextEditingController cvcCtlr;

  @override
  void initState() {
    super.initState();
    nombresTitularCtlr = TextEditingController();
    numeroTarjetaCtlr = TextEditingController();
    fechaCaducidadCtlr = TextEditingController();
    cvcCtlr = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    String imagenTarjeta = 'visa' == 'visa'
        ? 'assets/images/Visa_icon.png'
        : 'assets/images/Mastercard_icon.png';

    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF212121), Color(0xFF121212)],
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
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
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF00E050),
                size: 32,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          backgroundColor: Colors.transparent, // Fondo de scaffold transparente
          body: Container(
            padding: const EdgeInsets.all(26.0),
            width: 450,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.maxFinite,
                  child: Text(
                    'Disponibles',
                    style: TextStyle(
                        color: Color(0xFF00E050),
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 15),
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
                        icon: const Icon(Icons.close, color: Color(0xFF00E050)),
                        onPressed: () {
                          // Acción para eliminar tarjeta
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const SizedBox(
                  width: double.maxFinite,
                  child: Text(
                    'Agregar Tarjeta',
                    style: TextStyle(
                        color: Color(0xFF00E050),
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          tipoTarjeta = 'Visa';
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: tipoTarjeta == 'Visa'
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
                          tipoTarjeta = 'Mastercard';
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: tipoTarjeta == 'Mastercard'
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
                TextField(
                  controller: nombresTitularCtlr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Nombres del Titular',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontStyle: FontStyle.italic),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF00E050))),
                  ),
                ),
                TextField(
                  controller: numeroTarjetaCtlr,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: 'Número de Tarjeta',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontStyle: FontStyle.italic),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF00E050))),
                  ),
                ),
                TextField(
                  controller: fechaCaducidadCtlr,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Caducidad (MM/YYYY)',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontStyle: FontStyle.italic),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF00E050))),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(7),
                    _FechaCaducidadInputFormatter(), // Formatea la entrada de texto
                  ],
                ),
                TextField(
                  controller: cvcCtlr,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: 'Código de seguridad',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontStyle: FontStyle.italic),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF00E050))),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        3), // Limita a 3 caracteres
                    FilteringTextInputFormatter
                        .digitsOnly, // Permite solo números
                  ],
                  obscureText: true,
                ),
                const SizedBox(height: 35.0),
                CustomTextButton(
                    onTap: () async {
                      if (nombresTitularCtlr.text.isEmpty ||
                          numeroTarjetaCtlr.text.isEmpty ||
                          fechaCaducidadCtlr.text.isEmpty ||
                          cvcCtlr.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(
                                  'Por favor, complete todos los campos.')),
                        );
                      } else {
                        final addPaymentMetodResult = await ApiClient().post(
                          'security_filter/v1/api/payment/payment-method',
                          {
                            "titular": nombresTitularCtlr.text,
                            "numeroTarjeta": numeroTarjetaCtlr.toString(),
                            "expira": fechaCaducidadCtlr.text.toString(),
                            "cvc": cvcCtlr.text.toString(),
                            "franquicia": tipoTarjeta,
                          },
                        );
                        print(addPaymentMetodResult.statusCode);
                      }
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => CustomBottomNavigationBar()),
                      // );
                    },
                    text: 'Añadir Tarjeta',
                    buttonPrimary: true,
                    width: 233,
                    height: 30),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset('assets/icons/Logo.svg', width: 80),
                ),
              ],
            ),
          ),
        ));
  }
}

class _FechaCaducidadInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    // Si el texto es más largo que 2 caracteres y el tercer caracter no es "/", elimina el exceso de caracteres
    if (text.length > 2 && text[2] != '/') {
      text = text.substring(0, 2) + '/' + text.substring(2);
    }

    // Si el texto tiene más de 7 caracteres, corta el exceso
    if (text.length > 7) {
      text = text.substring(0, 7);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
