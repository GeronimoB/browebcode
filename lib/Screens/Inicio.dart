import 'package:flutter/material.dart';

class InicioPage extends StatefulWidget {
  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  double _xOffset = 0.0;
  double _rotation = 0.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _xOffset += details.primaryDelta!;
      _rotation = _xOffset / 1000;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_xOffset > 100) {
      // Swiped right
      print('Swiped right');
    } else if (_xOffset < -100) {
      // Swiped left
      print('Swiped left');
    }
    setState(() {
      _xOffset = 0;
      _rotation = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      body: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Stack(
          children: <Widget>[
            // Fondo
            Positioned.fill(
              child: Image.asset(
                'assets/Background.png', // Ruta de la imagen de fondo
                fit: BoxFit.cover,
              ),
            ),
            // Imagen principal
            Positioned(
              child: Transform.rotate(
                angle: _rotation,
                child: Transform.translate(
                  offset: Offset(_xOffset, 0),
                  child: Image.asset(
                    'assets/jugador.png', // Ruta de la imagen principal
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // SVG para la derecha
            if (_xOffset > 0)
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 50,
                right: 0,
                child: Image.asset(
                  'assets/Matchicon.png', // SVG para la derecha
                  width: 200,
                  height: 200,
                ),
              ),
            // SVG para la izquierda
            if (_xOffset < 0)
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 50,
                left: -30,
                child: Image.asset(
                  'assets/No Match.png', // SVG para la izquierda
                  width: 200,
                  height: 200,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
