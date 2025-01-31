import 'package:bro_app_to/utils/initial_video_model.dart';

abstract class UnauthUserInterface {
  void showLoading() {}
  void hideLoading() {}
  void setVideos(List<InitialVideoModel> videos) {}
}
