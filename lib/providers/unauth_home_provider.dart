import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../utils/initial_video_model.dart';

class UnauthHomeProvider extends ChangeNotifier {
  List<InitialVideoModel> videos = [];
  bool isLoading = false;
  VideoPlayerController? currentController;
  VideoPlayerController? nextController;
  int currentIndex = 0;
  double xOffset = 0;
  double rotation = 0;

  void setVideos(List<InitialVideoModel> initialVideos) {
    videos.clear();
    videos.addAll(initialVideos);
    notifyListeners();
  }

  void showLoading() {
    isLoading = true;
    notifyListeners();
  }

  void hideLoading() {
    isLoading = false;
    notifyListeners();
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    currentController?.dispose();
    currentController = nextController;

    currentIndex = (currentIndex + 1) % videos.length;

    currentController?.play();

    xOffset = 0;
    rotation = 0;

    notifyListeners();
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    xOffset += details.primaryDelta!;
    rotation = -xOffset / 2000;

    notifyListeners();
  }
}
