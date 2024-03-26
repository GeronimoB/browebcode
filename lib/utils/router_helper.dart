import 'package:bro_app_to/Intro.dart';
import 'package:bro_app_to/main.dart';
import 'package:bro_app_to/src/auth/presentation/screens/Sing_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String intro = '/intro';
  static String getInitialRoute() => '$initial';
  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const MySplashScreen()),
    GetPage(name: intro, page: () => SignInPage()),
    GetPage(name: login, page: () => const SignInScreen()),
  ];
}
