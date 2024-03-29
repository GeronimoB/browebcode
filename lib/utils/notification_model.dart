class NotificationModel {
  String title = '';
  String content = '';

  NotificationModel({required this.title, this.content = ''});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
