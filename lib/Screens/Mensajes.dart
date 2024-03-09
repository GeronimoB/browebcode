import 'package:flutter/material.dart';

class MensajesPage extends StatelessWidget {
  const MensajesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Mensajes',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C2C2C), Colors.black],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: ChatWidget(
                        key: ValueKey(index), // Unique key for Dismissible
                        imageURL: 'assets/jugador.png',
                        title: 'Juan Lopez',
                        description: 'Delantero',
                        onDelete: () {
                          // Aquí manejarías la eliminación real del chat
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class ChatWidget extends StatelessWidget {
  final String imageURL;
  final String title;
  final String description;
  final VoidCallback onDelete;

  const ChatWidget({
    super.key,
    required this.imageURL,
    required this.title,
    required this.description,
    required this.onDelete,
  });

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
        child: const Image(image: AssetImage('assets/X.png')),
      ),
      child: Container(
        height: 101,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(
            top: BorderSide(color: Colors.green, width: 1.0),
            bottom: BorderSide(color: Colors.green, width: 1.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const SizedBox(width: 16.0),
              CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage(imageURL),
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
