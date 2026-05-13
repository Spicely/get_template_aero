import 'package:get/get.dart';

import '../../routes/app_pages.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 路由混入，处理应用内各种特殊的页面跳转逻辑，剥离 UI 层的判断
///
/// Date: 2026年04月18日
///
//////////////////////////////////////////////////////////////////////////

mixin RouterMixin {
  /// 跳转到浏览器
  void toBrowser(String url, {String? title}) {
    Get.toNamed(Routes.BROWSER, parameters: {'url': url, 'title': title ?? ''});
  }
}
