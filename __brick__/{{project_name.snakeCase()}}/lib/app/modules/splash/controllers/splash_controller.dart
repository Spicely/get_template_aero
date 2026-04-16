import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
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
      onAgree();
    } else {
      Get.dialog(PrivacyDialog(privacyUrl: 'https://www.google.com', userAgreementUrl: 'https://www.google.com', onAgree: onAgree));
    }
  }

  Future<void> onAgree() async {
    await g.fetchMenuItems();
    final context = Get.context!;
    await Future.wait(g.menuItems.expand((item) => [precacheImage(CachedNetworkImageProvider(item.icon), context), precacheImage(CachedNetworkImageProvider(item.activeIcon), context)]));
    utils.db.config.isAgreement = true;
    Get.offAllNamed(Routes.HOME);
  }
}
