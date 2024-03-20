import 'package:bro_app_to/Screens/Chatpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MensajesPage extends StatelessWidget {
  const MensajesPage({Key? key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 35.0),
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: const Center(
            child: Text(
              'Mensajes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        name: 'Juan Lopez',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ChatWidget(
                    key: ValueKey(index),
                    imageURL: 'assets/images/jugador23.png',
                    title: 'Juan Lopez',
                    description: 'Delantero',
                    onDelete: () {
                      // Implementa la eliminación aquí
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ChatWidget extends StatelessWidget {
  final String imageURL;
  final String title;
  final String description;
  final VoidCallback onDelete;

  const ChatWidget({
    Key? key,
    required this.imageURL,
    required this.title,
    required this.description,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: SvgPicture.asset(
          width: 104,
          'assets/images/icons/X.svg',
        ),
      ),
      child: Container(
        height: 101,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(
            top: BorderSide(color: Color.fromARGB(255, 62, 174, 100), width: 2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const SizedBox(width: 16.0),
              Container(
                width: 64, 
                height: 64, 
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors
                      .black, // Cambia el color de fondo según sea necesario
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                          0.1), // Cambia el color y la opacidad de la sombra según sea necesario
                      blurRadius:
                          10, // Cambia el radio de desenfoque según sea necesario
                      offset: Offset(0,
                          3), // Cambia el desplazamiento de la sombra según sea necesario
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    imageURL,
                    fit: BoxFit.contain,
                    width: 64, // Doble del radio del círculo
                    height: 64, // Doble del radio del círculo
                  ),
                ),
              ),
              const SizedBox(width: 35.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Montserrat',
                        color: Colors.grey,
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
  }
}
