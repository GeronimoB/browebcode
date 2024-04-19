class InitialVideoModel {
  String url;
  int userId;
  String user;
  String description;

  InitialVideoModel(
      {required this.url,
      required this.userId,
      required this.user,
      required this.description});
  factory InitialVideoModel.fromJson(Map<String, dynamic> json) {
    return InitialVideoModel(
      url: json['video_url'],
      userId: json['user_id'],
      user: '${json['name']} ${json['lastname']}',
      description: json['description'],
    );
  }
}

List<InitialVideoModel> mapListToInitialVideos(List<dynamic> lista) {
  return lista.map((item) => InitialVideoModel.fromJson(item)).toList();
}
