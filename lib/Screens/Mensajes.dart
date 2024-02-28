import 'package:flutter/material.dart';

class MensajesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Mensajes')), // Título centrado en la AppBar
        backgroundColor: Colors.black, // Color de fondo de la AppBar
        elevation: 0, // Sin sombra
      ),
      backgroundColor: Colors.black, // Fondo negro de toda la pantalla
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
            child: Text(
              'Mensajes',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat', // Fuente Montserrat
                color: Colors.white,
              ),
              textAlign: TextAlign.center, // Centrar el texto
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 4, // Número de chats (aquí puedes usar el número real de chats)
              itemBuilder: (context, index) {
                // Generar cada chat
                return ChatWidget(
                  imageURL: 'assets/jugador.png', // Vector de imagen del perfil
                  title: 'Juan Lopez', // Título del chat
                  description: 'Delantero', // Descripción del último mensaje
                  onDelete: () {
                    // Eliminar chat
                    print('Chat eliminado');
                    // Aquí puedes agregar la lógica para eliminar el chat
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para representar cada chat
class ChatWidget extends StatefulWidget {
  final String imageURL; // Vector de imagen del perfil
  final String title; // Título del chat
  final String description; // Descripción del último mensaje
  final VoidCallback onDelete; // Función para eliminar el chat

  ChatWidget({
    required this.imageURL,
    required this.title,
    required this.description,
    required this.onDelete,
  });

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // Duración de la animación
    );
    _colorAnimation = ColorTween(
      begin: Colors.black, // Color inicial (negro)
      end: Colors.grey, // Color final (gris)
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Dismissible(
          key: UniqueKey(), // Clave única para el chat
          direction: DismissDirection.endToStart, // Desplazamiento solo hacia la izquierda
          onDismissed: (direction) {
            // Acción al desplazar el chat hacia la izquierda (eliminar)
            widget.onDelete();
          },
          background: Container(
            color: _colorAnimation.value, // Color de fondo dinámico
            alignment: Alignment.centerRight, // Alineación a la derecha
            padding: EdgeInsets.only(right: 20.0), // Padding solo a la derecha
            child: Image.asset('assets/X.png'), // Imagen de X
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent, // Sin color de fondo
              border: Border(
                top: BorderSide(color: Colors.green, width: 1.0), // Borde superior verde
                bottom: BorderSide(color: Colors.green, width: 1.0), // Borde inferior verde
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0), // Espaciado interno
              child: Row(
                children: [
                  // Imagen del perfil a la izquierda (circular)
                  Container(
                    width: 65.0,
                    height: 65.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(widget.imageURL),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter, // Alinea la imagen en la parte superior
                      ),
                    ),
                  ),
                  SizedBox(width: 30.0), // Espacio entre la imagen y el texto
                  // Columna de texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat', // Fuente Montserrat
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.0), // Espacio entre el título y la descripción
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Montserrat', // Fuente Montserrat
                            color: Colors.grey, // Color gris para la descripción
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
