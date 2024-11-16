import 'package:flutter/material.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleFactorWidth;
  static late double scaleFactorHeight;

  static void init(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;

    // Scale factors based on a standard design size (e.g., 360x640)
    scaleFactorWidth = screenWidth / 360; // Base width of design
    scaleFactorHeight = screenHeight / 640; // Base height of design
  }

  // Scaled width (use like a normal value)
  static double w(double value) {
    return value * scaleFactorWidth;
  }

  // Scaled height (use like a normal value)
  static double h(double value) {
    return value * scaleFactorHeight;
  }
}
