import 'package:flutter/material.dart';

class InicioPage extends StatefulWidget {
  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  double _xOffset = 0.0;
  double _rotation = 0.0;
  int _currentIndex = 0;
  List<String> _images = [
    'assets/jugador.png',
    'assets/jugador.png',
    'assets/jugador.png',
    // Añade más rutas de imagen según sea necesario
  ];

  // Calcula el índice de la próxima imagen teniendo en cuenta los límites de la lista
  int get _nextIndex {
    if (_currentIndex + 1 >= _images.length) {
      return 0;
    } else {
      return _currentIndex + 1;
    }
  }

  // Calcula el índice de la imagen anterior teniendo en cuenta los límites de la lista
  int get _prevIndex {
    if (_currentIndex - 1 < 0) {
      return _images.length - 1;
    } else {
      return _currentIndex - 1;
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _xOffset += details.primaryDelta!;
      _rotation = _xOffset / 1000;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_xOffset > 100) {
      setState(() {
        _currentIndex = _nextIndex;
      });
      print('Swiped right');
    } else if (_xOffset < -100) {
      setState(() {
        _currentIndex = _prevIndex;
      });
      print('Swiped left');
    }
    setState(() {
      _xOffset = 0;
      _rotation = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1 - (_xOffset.abs() * 0.001);
    double backgroundScale = 0.8 + (_xOffset.abs() * 0.0005); // Fondo comienza más pequeño y se agranda
    double opacity = 0.5 + (_xOffset.abs() * 0.001); // La opacidad aumenta con el desplazamiento

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Stack(
          children: <Widget>[
            // Imagen de fondo (próxima imagen)
            Positioned.fill(
              child: Transform.scale(
                scale: backgroundScale,
                child: Opacity(
                  opacity: _xOffset == 0 ? 0 : opacity, // Asegura que la opacidad sea 0 cuando no hay desplazamiento
                  child: Image.asset(
                    _images[_xOffset > 0 ? _prevIndex : _nextIndex], // Determina qué imagen mostrar en el fondo
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Imagen principal (actual)
            Positioned.fill(
              child: Transform.scale(
                scale: scale,
                child: Transform.rotate(
                  angle: _rotation,
                  child: Transform.translate(
                    offset: Offset(_xOffset, 0),
                    child: Image.asset(
                      _images[_currentIndex],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            // Íconos de acción (Match/No Match)
            if (_xOffset > 0)
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 50,
                right: 0,
                child: Image.asset(
                  'assets/Matchicon.png',
                  width: 200,
                  height: 200,
                ),
              ),
            if (_xOffset < 0)
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 50,
                left: -30,
                child: Image.asset(
                  'assets/No Match.png',
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
