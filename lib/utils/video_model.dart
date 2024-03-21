class Video {
  int? id;
  String? userId;
  String? videoUrl;
  String? videoKey;
  String? imageUrl;
  String? imageKey;

  Video({
    this.id,
    this.userId,
    this.videoUrl,
    this.videoKey,
    this.imageUrl,
    this.imageKey,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      userId: json['user_id'].toString(),
      videoKey: json['video_key'],
      videoUrl: json['video_url'],
      imageUrl: json['placeholder_url'],
      imageKey: json['image_key'],
    );
  }
}

List<Video> mapListToVideos(List<dynamic> lista) {
  return lista.map((item) => Video.fromJson(item)).toList();
}
