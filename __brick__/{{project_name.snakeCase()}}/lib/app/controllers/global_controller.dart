import 'package:get/get.dart';

import '../data/models/menu_item_model/menu_item_model.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 全局控制器
///
/// Date: 2024年12月09日 22:45:19 Monday
///
//////////////////////////////////////////////////////////////////////////

class GlobalController extends GetxController {
  GlobalController();

  final menuItems = <MenuItemModel>[].obs;

  Future<void> fetchMenuItems() async {
    // 模拟网络请求
    await Future.delayed(const Duration(milliseconds: 300));
    menuItems.value = [
      MenuItemModel(label: '首页', key: 'home', icon: 'https://aivideoname2.oss-cn-hangzhou.aliyuncs.com/tabs/ai_camera/home.png', activeIcon: 'https://aivideoname2.oss-cn-hangzhou.aliyuncs.com/tabs/ai_camera/home_s.png'),
      MenuItemModel(label: '做同款', key: 'make_same', icon: 'https://aivideoname2.oss-cn-hangzhou.aliyuncs.com/tabs/ai_camera/tk.png', activeIcon: 'https://aivideoname2.oss-cn-hangzhou.aliyuncs.com/tabs/ai_camera/tk_s.png'),
      MenuItemModel(label: '作品', key: 'works', icon: 'https://aivideoname2.oss-cn-hangzhou.aliyuncs.com/tabs/ai_camera/work.png', activeIcon: 'https://aivideoname2.oss-cn-hangzhou.aliyuncs.com/tabs/ai_camera/work_s.png'),
      MenuItemModel(label: '我的', key: 'mine', icon: 'https://aivideoname2.oss-cn-hangzhou.aliyuncs.com/tabs/ai_camera/mine.png', activeIcon: 'https://aivideoname2.oss-cn-hangzhou.aliyuncs.com/tabs/ai_camera/mine_s.png'),
    ];
  }
}
