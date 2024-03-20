import 'package:bro_app_to/Screens/Chatpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MensajesPage_player extends StatelessWidget {
  const MensajesPage_player({Key? key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
          child: const Center(
            child: Text(
              'MENSAJE',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatPage(
                        name: 'Luis Garzon',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ChatWidget(
                    key: ValueKey(index),
                    imageURL: 'assets/images/jugador23.png',
                    title: 'Luis Garzon',
                    description: 'Entrenador',
                    onDelete: () {
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
          width: 34,
          'assets/icons/X.svg',
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
              ClipOval(
                child: Image.asset(
                  imageURL,
                  width: 64,
                  height: 64,
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