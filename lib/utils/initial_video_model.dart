class InitialVideoModel {
  String url;
  String? shareUrl;
  String? downloadUrl;
  int userId;
  String user;
  String description;
  bool verificado;

  InitialVideoModel({
    required this.url,
    this.shareUrl,
    this.downloadUrl,
    required this.userId,
    required this.user,
    required this.description,
    required this.verificado,
  });
  factory InitialVideoModel.fromJson(Map<String, dynamic> json) {
    return InitialVideoModel(
      url: json['video_url'],
      shareUrl: json['share_video_url'],
      downloadUrl: json['download_video_url'],
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
  Set<int> userIds = {};
  List<UserFilter> uniqueUserFilters = [];

  for (var item in lista) {
    if (!userIds.contains(item.userId)) {
      userIds.add(item.userId);
      uniqueUserFilters.add(UserFilter(user: item.user, userId: item.userId));
    }
  }

  return uniqueUserFilters;
}
