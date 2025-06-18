import 'package:bro_app_to/Screens/player/home_page/home_page_presenter.dart';
import 'package:bro_app_to/components/item_video.dart';
import 'package:bro_app_to/Screens/player/home_page/widgets/item_video_global.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:bro_app_to/utils/global_video_model.dart';
import 'package:bro_app_to/utils/initial_video_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/current_state.dart';
import 'home_page_interface.dart';

class HomePageVideosScreen extends StatefulWidget {
  const HomePageVideosScreen({super.key});

  @override
  HomePageVideosScreenState createState() => HomePageVideosScreenState();
}

class HomePageVideosScreenState extends State<HomePageVideosScreen>
    implements HomePageInterface {
  late HomePagePresenter presenter;
  List<GlobalVideoModel> videos = [];
  bool isLoading = false;

  bool isFirstVideo = true;
  String userId = '';

  @override
  void initState() {
    super.initState();
    presenter = HomePagePresenter(page: this);
    userId = Provider.of<UserProvider>(context, listen: false)
        .getCurrentUser()
        .userId;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => presenter.fetchVideoUrls(userId));
  }

  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingWidget()
        : videos.isEmpty
            ? emptyWidget()
            : GestureDetector(
                onVerticalDragUpdate: (details) {
                  _pageController.jumpTo(
                    _pageController.offset - details.primaryDelta!,
                  );
                },
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  children: videos
                      .map(
                        (video) => ItemVideoGlobal(
                          video: video,
                          isFirstVideo: isFirstVideo,
                          updateFirstVideo: () => setState(() {
                            isFirstVideo = false;
                          }),
                        ),
                      )
                      .toList(),
                ),
              );
  }

  Widget loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05FF00))),
          const SizedBox(height: 20),
          Text(
            translations!["LoadingVideos..."],
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              height: 1,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget emptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              presenter.fetchVideoUrls(userId);
            },
            icon: const Icon(
              Icons.refresh,
              size: 48,
              color: Color(0xffffffff),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            translations!["EndOfVideos"],
            style: const TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void setVideos(List<GlobalVideoModel> resultVideos) {
    setState(() {
      videos = resultVideos;
    });
  }

  @override
  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }
}
