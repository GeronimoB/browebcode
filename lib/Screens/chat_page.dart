import 'dart:convert';
import 'dart:io';

import 'package:bro_app_to/Screens/agent/bottom_navigation_bar.dart';
import 'package:bro_app_to/Screens/player/bottom_navigation_bar_player.dart';
import 'package:bro_app_to/components/avatar_placeholder.dart';
import 'package:bro_app_to/components/chat_item.dart';
import 'package:bro_app_to/components/file_item.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/utils/api_constants.dart';
import 'package:bro_app_to/utils/message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../common/sizes.dart';
import '../components/image_item.dart';
import '../infrastructure/firebase_message_repository.dart';
import '../src/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ChatPage extends StatefulWidget {
  final UserModel friend;

  const ChatPage({
    super.key,
    required this.friend,
  });

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool isMute = false;
  bool isPinned = false;
  OverlayEntry? _overlayEntry;
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    init();
  }

  void init() async {
    final aux = await FirebaseMessageRepository()
        .isMuted2(_buildSenderId(), _buildReceiverId());
    final aux2 = await FirebaseMessageRepository()
        .isPinned(_buildSenderId(), _buildReceiverId());
    setState(() {
      isMute = aux;
      isPinned = aux2;
    });
  }

  String _buildSenderId() {
    final user = userProvider.getCurrentUser();
    return user.isAgent ? "agente_${user.userId}" : "jugador_${user.userId}";
  }

  String _buildReceiverId() {
    final friend = widget.friend;
    return friend.isAgent
        ? "agente_${friend.userId}"
        : "jugador_${friend.userId}";
  }

  void _sendMessage() async {
    final String text = _messageController.text;
    if (text.isNotEmpty) {
      Message message = Message(
        senderId: _buildSenderId(),
        receiverId: _buildReceiverId(),
        message: text,
      );
      _messageController.clear();
      _messageFocusNode.unfocus();
      final user = userProvider.getCurrentUser();

      final friendName = '${user.name} ${user.lastName}';
      try {
        await FirebaseMessageRepository().sendMessage(message, friendName);
        _scrollController.jumpTo(0);
      } catch (e) {
        print(e);
      }
    }
  }

  void _sendImage(String imageUrl) async {
    final user = userProvider.getCurrentUser();

    final friendName = '${user.name} ${user.lastName}';
    try {
      await FirebaseMessageRepository().sendImage(
        _buildSenderId(),
        _buildReceiverId(),
        imageUrl,
        friendName,
      );
      _scrollController.jumpTo(0);
    } catch (e) {
      print(e);
    }
  }

  void muteFriend() async {
    await FirebaseMessageRepository()
        .muteFriend(_buildSenderId(), _buildReceiverId(), !isMute);
  }

  void pinFriend() async {
    await FirebaseMessageRepository()
        .pinChat(_buildSenderId(), _buildReceiverId(), !isMute);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Sizes.initSizes(width, height);
    return WillPopScope(
      onWillPop: () async {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final user = userProvider.getCurrentUser();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => user.isAgent
                  ? const CustomBottomNavigationBar(initialIndex: 2)
                  : const CustomBottomNavigationBarPlayer(initialIndex: 3)),
        );

        return false;
      },
      child: Container(
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
            scrolledUnderElevation: 0,
            toolbarHeight: 100,
            backgroundColor: Colors.transparent,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => AvatarPlaceholder(40),
                    errorWidget: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/fot.png',
                        fit: BoxFit.fill,
                        width: 40,
                        height: 40,
                      );
                    },
                    imageUrl: widget.friend.imageUrl,
                    fit: BoxFit.fill,
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  "${widget.friend.name} ${widget.friend.lastName}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Color(0xFF00E050),
                    size: 32,
                  ),
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
                size: 32,
              ),
              onPressed: () {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                final user = userProvider.getCurrentUser();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => user.isAgent
                          ? const CustomBottomNavigationBar(initialIndex: 2)
                          : const CustomBottomNavigationBarPlayer(
                              initialIndex: 3)),
                );
              },
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(_buildSenderId())
                        .collection('messages')
                        .doc(_buildReceiverId())
                        .collection('chats')
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.docs.length < 1) {
                          return Center(
                            child: Text(
                              "Saluda!",
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                            controller: _scrollController,
                            itemCount: snapshot.data.docs.length,
                            physics: const BouncingScrollPhysics(),
                            reverse: true,
                            itemBuilder: (context, index) {
                              Timestamp timestamp =
                                  snapshot.data.docs[index]['date'];
                              DateTime dateTime = timestamp.toDate();
                              if (snapshot.data.docs[index]['type'] == "text") {
                                return chatItem(
                                  snapshot.data.docs[index]['message'],
                                  dateTime,
                                  snapshot.data.docs[index]['sent'],
                                  snapshot.data.docs[index]['read'],
                                );
                              } else if (snapshot.data.docs[index]['type'] ==
                                  "image") {
                                return imageItem(
                                  snapshot.data.docs[index]['url'],
                                  dateTime,
                                  snapshot.data.docs[index]['sent'],
                                  snapshot.data.docs[index]['read'],
                                );
                              } else {
                                return fileItem(
                                    snapshot.data.docs[index]['url'],
                                    dateTime,
                                    snapshot.data.docs[index]['sent'],
                                    snapshot.data.docs[index]['read'],
                                    context);
                              }
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                        ),
                      );
                    }),
              ),
              _buildTextComposer(),
            ],
          ),
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
              onPressed: () async {
                await _handleImageSelection();
              },
            ),
            IconButton(
              icon: const Icon(Icons.attach_file,
                  color: Color(0xff00E050), size: 26),
              onPressed: () async {
                await _handleFileSelection();
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

  Future<void> _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final file = File(result.path);
      final bytes = await file.readAsBytes();
      final image = await decodeImageFromList(bytes);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}/auth/upload-file'),
      );

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: MediaType('image', 'jpg'),
      ));
      var response = await request.send();
      var imageUrl = '';
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        imageUrl = jsonDecode(responseBody)["url"];
        _sendImage(imageUrl);
      } else {
        debugPrint(
            'Failed to upload image. Error code: ${response.statusCode}');
      }
    }
  }

  Future<void> _handleFileSelection() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final PlatformFile file = result.files.first;
      final String filePath = file.path ?? '';
      final String fileName = file.name;

      final bytes = await File(filePath).readAsBytes();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}/auth/upload-file'),
      );

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
        contentType: MediaType('application', 'octet-stream'),
      ));

      var response = await request.send();
      var fileUrl = '';

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        fileUrl = jsonDecode(responseBody)["url"];
        final user = userProvider.getCurrentUser();

        final friendName = '${user.name} ${user.lastName}';
        try {
          await FirebaseMessageRepository().sendFile(
            _buildSenderId(),
            _buildReceiverId(),
            fileUrl,
            fileName,
            friendName,
          );
          _scrollController.jumpTo(0);
        } catch (e) {
          print(e);
        }
      } else {
        debugPrint('Failed to upload file. Error code: ${response.statusCode}');
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _showCustomMenu(BuildContext context) {
    _overlayEntry?.remove();
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);
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
            top: offset.dy + 95,
            width: 220,
            child: Material(
              borderRadius: BorderRadius.circular(15),
              elevation: 5.0,
              shadowColor: Colors.black.withOpacity(
                  0.4), // Ajusta la opacidad de la sombra según sea necesario
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
                    if (userProvider.getCurrentUser().isAgent)
                      ListTile(
                        title: const Text('Ver Perfil',
                            style: const TextStyle(color: Colors.white)),
                        onTap: () {
                          _overlayEntry?.remove();
                          _overlayEntry = null;
                        },
                      ),
                    ListTile(
                      title: Text(
                          isPinned ? 'Dejar de anclar' : 'Anclar arriba',
                          style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        pinFriend();
                        init();
                        _overlayEntry?.remove();
                        _overlayEntry = null;
                      },
                    ),
                    // ListTile(
                    //   title: const Text('Buscar',
                    //       style: const TextStyle(color: Colors.white)),
                    //   onTap: () {
                    //     _overlayEntry?.remove();
                    //     _overlayEntry = null;
                    //   },
                    // ),
                    ListTile(
                      title: Text(
                          isMute
                              ? 'Dejar de silenciar'
                              : 'Silenciar notificaciones',
                          style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        muteFriend();
                        init();
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
