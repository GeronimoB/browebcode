// message.dart (Modelo de datos)
class Message {
  String senderId;
  String receiverId;
  String message;
  // otros campos...

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    // otros campos...
  });
}

// message_use_case.dart (Caso de uso)
abstract class MessageUseCase {
  Future<void> sendMessage(Message message);
}
