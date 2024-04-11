import 'package:bro_app_to/Screens/intro.dart';
import 'package:bro_app_to/Screens/agent/bottom_navigation_bar.dart';
import 'package:bro_app_to/Screens/agent/config_profile.dart';
import 'package:bro_app_to/Screens/player/bottom_navigation_bar_player.dart';
import 'package:bro_app_to/main.dart';
import 'package:bro_app_to/src/auth/presentation/screens/sign_in.dart';
import 'package:get/get.dart';

import '../Screens/player/config_profile_player.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String intro = '/intro';
  static const String configAgent = '/config-agent';
  static const String configPlayer = '/config-player';
  static const String homePlayer = '/home-player/:initialIndex';
  static const String homeAgent = '/home-agent/:initialIndex';
  static String getInitialRoute() => initial;
  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const MySplashScreen()),
    GetPage(name: intro, page: () => const SignInPage()),
    GetPage(name: login, page: () => const SignInScreen()),
    GetPage(name: configAgent, page: () => const ConfigProfile()),
    GetPage(name: configPlayer, page: () => const ConfigProfilePlayer()),
    GetPage(
      name: homePlayer,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final initialIndex = args['initialIndex'] ?? 0;
        return CustomBottomNavigationBarPlayer(initialIndex: initialIndex);
      },
    ),
    GetPage(
      name: homeAgent,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final initialIndex = args['initialIndex'] ?? 0;
        return CustomBottomNavigationBar(initialIndex: initialIndex);
      },
    ),
  ];
}
