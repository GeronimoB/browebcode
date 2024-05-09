class InitialVideoModel {
  String url;
  int userId;
  String user;
  String description;
  bool verificado;

  InitialVideoModel({
    required this.url,
    required this.userId,
    required this.user,
    required this.description,
    required this.verificado,
  });
  factory InitialVideoModel.fromJson(Map<String, dynamic> json) {
    return InitialVideoModel(
      url: json['video_url'],
      userId: json['user_id'],
      user: '${json['name']} ${json['lastname']}',
      description: json['description'] ?? '',
      verificado: json['aprobado'] ?? false,
    );
  }
}

class UserFilter {
  int userId;
  String user;

  UserFilter({
    required this.userId,
    required this.user,
  });
}

List<InitialVideoModel> mapListToInitialVideos(List<dynamic> lista) {
  return lista.map((item) => InitialVideoModel.fromJson(item)).toList();
}

List<UserFilter> listFilterUserFromVideos(List<InitialVideoModel> lista) {
  return lista
      .map((item) => UserFilter(user: item.user, userId: item.userId))
      .toList();
}
