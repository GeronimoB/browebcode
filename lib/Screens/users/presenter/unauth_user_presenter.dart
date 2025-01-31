import 'dart:convert';

import 'package:bro_app_to/Screens/users/interface/unauth_user_interface.dart';

import '../../../utils/api_client.dart';
import '../../../utils/initial_video_model.dart';

class UnauthUserPresenter {
  UnauthUserPresenter({required this.page});

  UnauthUserInterface page;

  Future<void> fetchVideoUrls(String initialVideoId) async {
    page.showLoading();
    try {
      final response = await ApiClient()
          .post('auth/unauth-random-videos/$initialVideoId', {});

      final videos = jsonDecode(response.body)["video"];
      List<InitialVideoModel> videosMapeados = mapListToInitialVideos(videos);
      page.hideLoading();
      page.setVideos(videosMapeados);
    } catch (error) {
      page.hideLoading();
      page.setVideos([]);
    }
  }
}
