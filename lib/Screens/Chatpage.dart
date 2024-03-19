import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String name;

  const ChatPage({
    super.key,
    required this.name,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage() {
    final String text = _messageController.text;
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(text);
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/images/jugador23.png'), // Reemplazar con tu imagen.
            ),
            SizedBox(width: 10),
            Text(widget.name, style: TextStyle(color: Colors.white)),
            Spacer(),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.green),
              onPressed: () {
                // Acciones de los 3 puntos verticales.
              },
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(108, 4, 255, 0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _messages[index],
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildTextComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _messageController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enviar un mensaje...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.photo_camera, color: Colors.green),
            onPressed: () {
              // Acciones para enviar imágenes.
            },
          ),
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.green),
            onPressed: () {
              // Acciones para adjuntar archivos.
            },
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.green),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
