import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/payment/view/paymet_successful.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EasyCheckout extends StatefulWidget {
  final String url;

  const EasyCheckout({Key? key, required this.url}) : super(key: key);

  @override
  State<EasyCheckout> createState() => _EasyCheckoutState();
}

class _EasyCheckoutState extends State<EasyCheckout> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) {
            print("change.url - ${change.url}");
            if (change.url!
                .contains("https://www.google.com/payment/success")) {
              Nav().pushReplacement(const PaymetSuccessful());
            } else if (change.url!
                .contains("https://www.google.com/payment/failed")) {
              Nav().pop();
              Fluttertoast.showToast(msg: "Failed to purchase the course.");
            } else if (change.url!
                .contains("https://www.google.com/payment/cancelled")) {
              Nav().pop();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
