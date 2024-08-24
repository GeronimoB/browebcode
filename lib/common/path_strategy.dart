import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class CustomPathStrategy extends PathUrlStrategy {
  final String appTitle;

  CustomPathStrategy({required this.appTitle});

  @override
  void pushState(Object? state, String title, String url) {
    final pageTitle = title == "flutter" ? appTitle : title;
    super.pushState(state, pageTitle, url);
  }

  @override
  void replaceState(Object? state, String title, String url) {
    final pageTitle = title == "flutter" ? appTitle : title;
    super.pushState(state, pageTitle, url);
  }
}
