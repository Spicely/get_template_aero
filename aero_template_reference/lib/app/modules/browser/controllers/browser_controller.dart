import 'dart:ui';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserController extends GetxController {
  String title = Get.parameters['title'] ?? '';

  String url = Get.parameters['url'] ?? '';

  RxDouble progressValue = 0.0.obs;

  double xx = 0.3;

  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000));

  @override
  void onInit() {
    controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // loadProgress(progress);
          loadProgress(progress);
        },
        onPageStarted: (String url) {
          // Log.i("=======112333");
        },
        onPageFinished: (String url) {
          // Log.i("=======1123334444");
        },
        onWebResourceError: (WebResourceError error) {},
      ),
    );
    super.onInit();

    loadHtmlAction();
  }

  void loadProgress(int value) {
    progressValue.value = value / 100.0;
  }

  void loadHtmlAction() {
    controller.loadRequest(Uri.parse(url));
  }
}
