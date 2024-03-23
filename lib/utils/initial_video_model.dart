class InitialVideoModel {
  String url;
  int userId;

  InitialVideoModel({required this.url, required this.userId});
  factory InitialVideoModel.fromJson(Map<String, dynamic> json) {
    return InitialVideoModel(
      url: json['video_url'],
      userId: json['user_id'],
    );
  }
}

List<InitialVideoModel> mapListToInitialVideos(List<dynamic> lista) {
  return lista.map((item) => InitialVideoModel.fromJson(item)).toList();
}
