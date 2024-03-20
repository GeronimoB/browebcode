import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final String imagePath;

  const FullScreenImagePage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.1,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 8.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF00E050)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            right: 8.0,
            child: Theme(
              data: Theme.of(context).copyWith(
                iconTheme: const IconThemeData(color: Color(0xFF00E050)),
              ),
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Color(0xFF00E050)),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  side: BorderSide(color: Color(0xFF00E050)),
                ),
                color: const Color(0xff3B3B3B),
                onSelected: (String result) {
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                    child: Text('Borrar', style: TextStyle(color: Colors.white ,fontFamily: 'Montserrat',fontStyle: FontStyle.italic)),
                  ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'destacar',
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                    child: Text('Destacar', style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontStyle: FontStyle.italic)),
                      ),
                    ),
                  const PopupMenuItem<String>(
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                    child: Text('Editar', style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontStyle: FontStyle.italic)),
                  ),
                  ),
                  const PopupMenuItem<String>(
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                    child: Text('Guardar', style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontStyle: FontStyle.italic)),
                  ),
                  ),
                  const PopupMenuItem<String>(
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                    child: Text('Ocultar', style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontStyle: FontStyle.italic)),
                  ),
                  )
                ],
              ),

            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              color: Colors.black,
              child: Center(
                child: Image.asset('assets/images/Logo.png', fit: BoxFit.fitWidth),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
