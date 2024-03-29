import 'package:bro_app_to/Screens/chat_page.dart';
import 'package:bro_app_to/components/chat_avatar.dart';
import 'package:bro_app_to/src/auth/data/models/user_model.dart';
import 'package:bro_app_to/utils/chat_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../infrastructure/firebase_message_repository.dart';
import '../providers/user_provider.dart';

class MensajesPage extends StatelessWidget {
  MensajesPage({super.key});
  final FirebaseMessageRepository messageRepository =
      FirebaseMessageRepository();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.getCurrentUser();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
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
                  height: 1),
            ),
          ),
        ),
        FutureBuilder<List<ChatPreview>>(
            future: messageRepository.getLastMessagesWithUsers(
                user.userId, user.isAgent),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.green), // Color del loader
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Expanded(
                  child: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              } else {
                final messagesWithUsers = snapshot.data ?? [];

                return Expanded(
                  child: ListView.builder(
                    itemCount: messagesWithUsers.length,
                    itemBuilder: (context, index) {
                      final chat = messagesWithUsers[index];
                      return GestureDetector(
                        onTap: () async {
                          final userParsedId = user.isAgent
                              ? "agente_${user.userId}"
                              : "jugador_${user.userId}";
                          final friendParsedId = chat.friendUser.isAgent
                              ? "agente_${chat.friendUser.userId}"
                              : "jugador_${chat.friendUser.userId}";
                          await FirebaseMessageRepository()
                              .markAllMessagesAsRead(
                                  userParsedId, friendParsedId);

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                friend: chat.friendUser,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ChatWidget(
                            key: ValueKey(index),
                            chat: chat,
                            onDelete: () {},
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }),
      ],
    );
  }
}

class ChatWidget extends StatefulWidget {
  final ChatPreview chat;
  final VoidCallback onDelete;
  const ChatWidget({
    Key? key,
    required this.chat,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget>
    with SingleTickerProviderStateMixin {
  late final controller = SlidableController(this);
  Color backgroundColor = Colors.transparent;
  @override
  void initState() {
    super.initState();
    controller.animation.addListener(() {
      setState(() {
        final currentRatio = controller.animation.value;
        if (currentRatio > 0) {
          backgroundColor = Colors.grey;
        } else {
          backgroundColor = Colors.transparent;
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: widget.key!,
      controller: controller,
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: const [
          SlidableAction(
            flex: 1,
            onPressed: null,
            backgroundColor: Colors.transparent,
            foregroundColor: Color(0xff05FF00),
            icon: Icons.close,
            label: null,
            spacing: 8,
          ),
        ],
      ),
      child: Container(
        height: 101,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 62, 62, 62),
              Color.fromARGB(0, 44, 44, 44),
            ],
          ),
          color: backgroundColor,
          border: Border(
            top: BorderSide(color: Color.fromARGB(255, 62, 174, 100), width: 2),
            bottom:
                BorderSide(color: Color.fromARGB(255, 62, 174, 100), width: 2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const SizedBox(width: 16.0),
              chatAvatar(widget.chat.count, widget.chat.friendUser.imageUrl),
              const SizedBox(width: 30.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.chat.friendUser.name} ${widget.chat.friendUser.lastName}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.chat.message,
                      style: const TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.chat.time,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color.fromARGB(255, 204, 203, 203),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
