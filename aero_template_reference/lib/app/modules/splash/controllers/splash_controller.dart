import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../components/dialog/privacy_dialog/privacy_dialog.dart';
import '../../../controllers/global_controller.dart';
import '../../../data/utils/utils.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  GlobalController g = Get.find<GlobalController>();

  AssetGenImage splash = Assets.images.splash;

  @override
  void onReady() {
    super.onReady();
    if (utils.db.config.isAgreement) {
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed(Routes.HOME);
      });
    } else {
      Get.dialog(PrivacyDialog(privacyUrl: 'https://www.google.com', userAgreementUrl: 'https://www.google.com', onAgree: onAgree));
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  }

  @override
  void onClose() {
    super.onClose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  }

  void onAgree() {
    Get.offAllNamed(Routes.HOME);
    utils.db.config.isAgreement = true;
  }
}
