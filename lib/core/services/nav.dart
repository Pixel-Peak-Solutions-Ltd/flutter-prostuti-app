import 'package:flutter/material.dart';

class Nav {
  static final Nav _instance = Nav._internal();

  factory Nav() {
    return _instance;
  }

  Nav._internal();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Route _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 150),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // Push a new screen (widget class)
  Future<void> push(Widget page) async {
    await navigatorKey.currentState?.push(_createPageRoute(page));
  }

  // Pop the current screen
  void pop() {
    navigatorKey.currentState?.pop();
  }

  // Push a new screen and remove all previous screens
  Future<void> pushAndRemoveUntil(Widget page) async {
    await navigatorKey.currentState?.pushAndRemoveUntil(
      _createPageRoute(page),
      (route) => false,
    );
  }

  // Replace the current screen with a new one
  Future<void> pushReplacement(Widget page) async {
    await navigatorKey.currentState?.pushReplacement(_createPageRoute(page));
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
