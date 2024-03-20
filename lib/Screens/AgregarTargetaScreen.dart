import 'package:flutter/material.dart';

class AgregarTarjetaScreen extends StatefulWidget {
  AgregarTarjetaScreen({Key? key}) : super(key: key);

  @override
  _AgregarTarjetaScreenState createState() => _AgregarTarjetaScreenState();
}

class _AgregarTarjetaScreenState extends State<AgregarTarjetaScreen> {
  String tipoTarjeta = 'visa'; // Por defecto seleccionamos Visa

  @override
  Widget build(BuildContext context) {
    String imagenTarjeta = tipoTarjeta == 'visa' ? 'assets/Visa_icon.png' : 'assets/Mastercard_icon.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MÉTODO DE PAGO',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF00E050)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF212121), Color(0xFF121212)],
          ),
        ),
        padding: EdgeInsets.all(26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Disponibles',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontFamily: 'Montserrat',
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF00E050)),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: Image.asset(imagenTarjeta),
                title: Text(
                  'Titular XXXXXXXX\nNúmero XXXXXXXXXXXX',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    softWrap: false,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.close, color: Color(0xFF00E050)),
                  onPressed: () {
                    // Acción para eliminar tarjeta
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Agregar Tarjeta',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontFamily: 'Montserrat',
              ),
            ),
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
          if (tipoTarjeta == 'visa') // Mostrar el punto si está seleccionada Visa
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00E050),
              ),
            ),
          SizedBox(width: 8),
          Image.asset('assets/Visa_icon.png', height: 40),
        ],
      ),
    ),
    SizedBox(width: 16),
    GestureDetector(
      onTap: () {
        setState(() {
          tipoTarjeta = 'mastercard';
        });
      },
      child: Row(
        children: [
          if (tipoTarjeta == 'mastercard') // Mostrar el punto si está seleccionada Mastercard
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00E050),
              ),
            ),
          SizedBox(width: 8),
          Image.asset('assets/Mastercard_icon.png', height: 40),
        ],
      ),
    ),
  ],
),

            SizedBox(height: 16.0),
            TextField(
              style: TextStyle(color: Colors.white,fontFamily: 'Montserrat', fontSize: 12),
              decoration: InputDecoration(
                labelText: 'Nombres del Titular',
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 12),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E050))),
              ),
            ),
            TextField(
              style: TextStyle(color: Colors.white,fontFamily: 'Montserrat', fontSize: 12),
              decoration: InputDecoration(
                labelText: 'Número de Tarjeta',
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 12),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E050))),
              ),
            ),
            TextField(
              style: TextStyle(color: Colors.white,fontFamily: 'Montserrat', fontSize: 12),
              decoration: InputDecoration(
                labelText: 'Fecha de Caducidad',
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 12),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E050))),
              ),
            ),
            TextField(
              style: TextStyle(color: Colors.white,fontFamily: 'Montserrat', fontSize: 12),
              decoration: InputDecoration(
                labelText: 'Código de seguridad',
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 12),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00E050))),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 70), // Puedes ajustar el valor de acuerdo a tus necesidades
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00E050),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Reducir el padding vertical y horizontal
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Redondear bordes
                ),
                onPressed: () {
                  // Acción para añadir tarjeta
                },
                child: Text(
                  'Añadir Tarjeta',
                  style: TextStyle(
                    fontSize: 14, // Reducir el tamaño del texto
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold, // Hacer el texto en negrita
                    color: Colors.black, // Color del texto en negro
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/Logo.png', width: 80),
            ),
          ],
        ),
      ),
    );
  }
}
