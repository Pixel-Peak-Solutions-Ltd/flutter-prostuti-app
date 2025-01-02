import 'package:flutter/material.dart';

class Nav {
  static final Nav _instance = Nav._internal();

  factory Nav() {
    return _instance;
  }

  Nav._internal();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Push a new screen (widget class)
  Future<void> push(Widget page) async {
    await navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (context) => page));
  }

  // Pop the current screen
  void pop() {
    navigatorKey.currentState?.pop(true);
  }

  // Push a new screen and remove all previous screens
  Future<void> pushAndRemoveUntil(Widget page) async {
    await navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }

  // Replace the current screen with a new one
  Future<void> pushReplacement(Widget page) async {
    await navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Pop until a specific screen
  void popUntil(Widget page) {
    navigatorKey.currentState
        ?.popUntil((route) => route.settings.name == page.toString());
  }

  // Pop to the root screen
  void popToRoot() {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }
}
