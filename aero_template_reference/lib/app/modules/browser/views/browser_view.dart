import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../data/theme/theme_custom.dart';
import '../controllers/browser_controller.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: webview
///
/// Date: 2024年11月30日 02:04:40 Saturday
///
//////////////////////////////////////////////////////////////////////////

class BrowserView extends GetView<BrowserController> {
  const BrowserView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(
            () => controller.progressValue > 0 && controller.progressValue < 1
                ? LinearProgressIndicator(
                    value: controller.progressValue.value,
                    minHeight: 2,
                    backgroundColor: context.eTheme.subColor,
                    valueColor: AlwaysStoppedAnimation(context.theme.primaryColor),
                  )
                : Container(),
          ),
          Expanded(
            child: WebViewWidget(controller: controller.controller),
          ),
        ],
      ),
    );
  }
}
