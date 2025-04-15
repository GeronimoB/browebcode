import '../../../utils/global_video_model.dart';

abstract class HomePageInterface {
  void showLoading() {}
  void hideLoading() {}
  void setVideos(List<GlobalVideoModel> videos) {}
}
