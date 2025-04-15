import 'package:bro_app_to/Screens/users/presenter/unauth_user_presenter.dart';
import 'package:bro_app_to/components/item_video.dart';
import 'package:bro_app_to/providers/unauth_home_provider.dart';
import 'package:bro_app_to/utils/initial_video_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../components/slidedable_video.dart';
import '../../utils/current_state.dart';
import '../intro.dart';
import 'interface/unauth_user_interface.dart';

class UnauthUserScreen extends StatefulWidget {
  const UnauthUserScreen({super.key, required this.videoId});

  final String videoId;

  @override
  UnauthUserScreenState createState() => UnauthUserScreenState();
}

class UnauthUserScreenState extends State<UnauthUserScreen>
    implements UnauthUserInterface {
  late UnauthUserPresenter presenter;
  List<InitialVideoModel> videos = [];
  bool isLoading = false;

  bool isFirstVideo = true;

  @override
  void initState() {
    super.initState();
    presenter = UnauthUserPresenter(page: this);

    WidgetsBinding.instance
        .addPostFrameCallback((_) => presenter.fetchVideoUrls(widget.videoId));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 530
        ? 530
        : MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              isLoading
                  ? loadingWidget()
                  : videos.isEmpty
                      ? emptyWidget()
                      : Positioned.fill(
                          child: PageView(
                            scrollDirection: Axis.vertical,
                            children: videos
                                .map(
                                  (video) => ItemVideo(
                                    video: video,
                                    isFirstVideo: isFirstVideo,
                                    updateFirstVideo: () => setState(() {
                                      isFirstVideo = false;
                                    }),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                child: Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(8),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        ),
                        icon: const Icon(
                          Icons.login,
                          size: 36,
                          color: Color(0xFF00E050),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

  Widget errorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              presenter.fetchVideoUrls(widget.videoId);
            },
            icon: const Icon(
              Icons.refresh,
              size: 48,
              color: Color(0xffffffff),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            translations!["ErrorLoadingVideos!"],
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

  Widget emptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              presenter.fetchVideoUrls(widget.videoId);
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
  void setVideos(List<InitialVideoModel> resultVideos) {
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
