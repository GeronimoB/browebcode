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
  
OverlayEntry? _overlayEntry;

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
            IconButton(
              icon: const Icon(Icons.more_horiz, color: Color(0xFF00E050)),
              onPressed: () {
                _showCustomMenu(context);
              },
            ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF00E050),
            ),
            onPressed: () => Navigator.of(context).pop(),
            ),

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
void _showCustomMenu(BuildContext context) {
  _overlayEntry?.remove();
  _overlayEntry = _createOverlayEntry(context);
  Overlay.of(context)?.insert(_overlayEntry!);
}

OverlayEntry _createOverlayEntry(BuildContext context) {
  RenderBox renderBox = context.findRenderObject() as RenderBox;
  var size = renderBox.size;
  var offset = renderBox.localToGlobal(Offset.zero);

  return OverlayEntry(
  builder: (context) => Stack(
    children: [
      GestureDetector(
        onTap: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.transparent,
        ),
      ),
      Positioned(
        left: offset.dx + size.width - 230,
        top: offset.dy + 80, 
        width: 220, 
        child: Material(
          borderRadius: BorderRadius.circular(15),
          elevation: 5.0,
          shadowColor: Colors.black.withOpacity(0.4), // Ajusta la opacidad de la sombra según sea necesario
          color: const Color(0xFF3B3B3B), 
          child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff3B3B3B),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4), 
                blurRadius: 10,
                offset: const Offset(5, 4),
              ),
            ],
          ),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: const Text('Ver Perfil', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                  },
                ),
                ListTile(
                  title: const Text('Anclar arriba', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                  },
                ),
                ListTile(
                  title: const Text('Buscar', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                  },
                ),
                ListTile(
                  title: const Text('Silenciar notificaciones', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                  },
                ),
                ListTile(
                  title: const Text('Bloquear', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                  },
                ),
                ListTile(
                  title: const Text('Buscar Archivos', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
);
}
}
