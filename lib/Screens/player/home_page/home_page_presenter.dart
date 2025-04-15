import 'dart:convert';

import 'package:bro_app_to/Screens/player/home_page/home_page_interface.dart';

import '../../../utils/api_client.dart';
import '../../../utils/global_video_model.dart';
import '../../../utils/initial_video_model.dart';

class HomePagePresenter {
  HomePagePresenter({required this.page});

  HomePageInterface page;

  Future<void> fetchVideoUrls(String userId) async {
    page.showLoading();
    try {
      final response = await ApiClient().post(
          'security_filter/v1/api/social/user-videos', {'userId': userId});
      final videos = jsonDecode(response.body)["videos"];
      List<GlobalVideoModel> videosMapeados = mapListToGlobalVideos(videos);
      page.hideLoading();
      page.setVideos(videosMapeados);
    } catch (error) {
      page.hideLoading();
      page.setVideos([]);
    }
  }
}
