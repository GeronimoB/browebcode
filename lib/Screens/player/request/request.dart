class Request {
  final int id;
  final int followerId;
  final String userName;
  final String fullName;
  final String image;

  Request({
    required this.id,
    required this.followerId,
    required this.userName,
    required this.fullName,
    required this.image,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      followerId: json['follower_id'],
      userName: json['username'],
      fullName: '${json['name']} ${json['lastname']}',
      image: json['image_url'],
    );
  }
}
