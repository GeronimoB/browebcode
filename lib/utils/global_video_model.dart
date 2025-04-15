class GlobalVideoModel {
  int videoId;
  String url;
  String? shareUrl;
  String? downloadUrl;
  String? imageUrl;
  int userId;
  String user;
  String fullName;
  String description;
  bool verificado;
  int likesCount;
  int commentsCount;
  bool isLiked;
  bool isHidden;
  bool isFavorite;
  String? suscriptionId;

  GlobalVideoModel({
    required this.url,
    this.shareUrl,
    this.downloadUrl,
    required this.userId,
    required this.videoId,
    required this.user,
    required this.fullName,
    required this.imageUrl,
    required this.description,
    required this.verificado,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    this.isHidden = false,
    this.isFavorite = false,
    this.suscriptionId,
  });
  factory GlobalVideoModel.fromJson(Map<String, dynamic> json) {
    return GlobalVideoModel(
      url: json['video_url'],
      imageUrl: json['placeholder_url'],
      shareUrl: json['share_video_url'],
      downloadUrl: json['download_video_url'],
      videoId: json['id'],
      userId: json['user_id'],
      user: json['username'],
      fullName: '${json['name'].trim()} ${json['lastname']}',
      description: json['description'] ?? '',
      verificado: json['aprobado'] ?? false,
      likesCount: json['likeCount'] ?? 0,
      commentsCount: json['commentCount'] ?? 0,
      isLiked: json['userLiked'] ?? false,
      isFavorite: json['destacado'] == 1 ? true : false,
      isHidden: json['destacado'] == 1 ? true : false,
      suscriptionId: json['suscription_id'],
    );
  }
}

List<GlobalVideoModel> mapListToGlobalVideos(List<dynamic> lista) {
  return lista.map((item) => GlobalVideoModel.fromJson(item)).toList();
}
