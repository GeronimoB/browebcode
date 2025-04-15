class Comment {
  final int id;
  final int userId;
  final int parentId;
  final String name;
  final String lastName;
  final String username;
  final String comment;
  final int likes;
  final DateTime createdAt;
  final bool isLikedByCurrentUser;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.userId,
    required this.name,
    required this.lastName,
    required this.username,
    required this.comment,
    required this.likes,
    required this.createdAt,
    required this.isLikedByCurrentUser,
    required this.parentId,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['user_id'],
      parentId: json['parent_id'] ?? 0,
      name: json['name'],
      lastName: json['lastname'],
      username: json['username'],
      comment: json['comment'],
      likes: json['likes_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      isLikedByCurrentUser: json['liked_by_user'] ?? false,
      replies: json['replies'] != null
          ? List<Comment>.from(
              json['replies'].map((reply) => Comment.fromJson(reply)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'lastname': lastName,
      'username': username,
      'comment': comment,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'isLikedByCurrentUser': isLikedByCurrentUser,
      'replies': replies.map((reply) => reply.toJson()).toList(),
    };
  }

  Comment copyWith({
    int? id,
    int? userId,
    int? parentId,
    String? name,
    String? lastName,
    String? comment,
    String? username,
    int? likes,
    DateTime? createdAt,
    bool? isLikedByCurrentUser,
    List<Comment>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      comment: comment ?? this.comment,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
      replies: replies ?? this.replies,
      username: username ?? this.username,
    );
  }
}
