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
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final String text = _messageController.text;
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(text);
        _messageController.clear();
      });
      _messageFocusNode.unfocus();
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 44, 44, 44),
            Color.fromARGB(255, 0, 0, 0),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/jugador23.png',
                  width: 40,
                  height: 40,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                widget.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
            ],
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF00E050),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_horiz, color: Color(0xFF00E050)),
              iconSize: 32,
              onPressed: () {
                // Acciones de los 3 puntos verticales.
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
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
                          color: const Color.fromARGB(51, 4, 255, 0),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          border: Border.all(
                            color: const Color.fromARGB(107, 4, 255, 0),
                          )),
                      child: Text(
                        _messages[index],
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.italic),
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
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: const Color(0xff3EAE64), width: 1),
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _messageController,
                focusNode: _messageFocusNode,
                style: const TextStyle(color: Colors.white),
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Enviar un mensaje...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.photo_camera_outlined,
                  color: Color(0xff00E050), size: 26),
              onPressed: () {
                // Acciones para enviar imágenes.
              },
            ),
            IconButton(
              icon: const Icon(Icons.attach_file,
                  color: Color(0xff00E050), size: 26),
              onPressed: () {
                // Acciones para adjuntar archivos.
              },
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xff00E050), size: 26),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
