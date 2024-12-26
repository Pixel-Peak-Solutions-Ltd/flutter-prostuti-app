import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/course/my_course/view/my_course_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EasyCheckout extends StatelessWidget {
  final String url;

  const EasyCheckout({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
          backgroundColor: Colors.white,
          onPageStarted: (String url) {
            print(url);
            if (url.contains("paid/success")) {
              Nav().pushReplacement(MyCourseView());
            } else if (url.contains("paid/failed")) {
              Nav().pop();
              Fluttertoast.showToast(msg: "Failed to purchase the course.");
            } else if (url.contains("paid/cancelled")) {
              Nav().pop();
            }
          },
        ),
      ),
    );
  }
}
