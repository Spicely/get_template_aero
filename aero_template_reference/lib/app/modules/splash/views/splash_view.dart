import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 启动页面
///
/// Date: 2024年11月30日 02:05:05 Saturday
///
//////////////////////////////////////////////////////////////////////////

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.splash.image(fit: BoxFit.cover, width: double.infinity, height: double.infinity),
    );
  }
}
