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

  @override
  Widget build(BuildContext context) {
    String imagenTarjeta = tipoTarjeta == 'visa'
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Disponibles',
                      style: TextStyle(
                          color: Color(0xFF00E050),
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF00E050)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
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
                          icon:
                              const Icon(Icons.close, color: Color(0xFF00E050)),
                          onPressed: () {
                            // Acción para eliminar tarjeta
                          },
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
                              if (tipoTarjeta ==
                                  'visa') // Mostrar el punto si está seleccionada Visa
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF00E050),
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
                              if (tipoTarjeta ==
                                  'mastercard') // Mostrar el punto si está seleccionada Mastercard
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF00E050),
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
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal:
                              70), // Puedes ajustar el valor de acuerdo a tus necesidades
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E050),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal:
                                  16), // Reducir el padding vertical y horizontal
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20)), // Redondear bordes
                        ),
                        onPressed: () {
                          // Acción para añadir tarjeta
                        },
                        child: const Text(
                          'Añadir Tarjeta',
                          style: TextStyle(
                            fontSize: 14, // Reducir el tamaño del texto
                            fontFamily: 'Montserrat',
                            fontWeight:
                                FontWeight.bold, // Hacer el texto en negrita
                            color: Colors.black, // Color del texto en negro
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
