/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 首页菜单模型
///
/// Date: 2025年12月18日 17:35:00 Thursday
///
//////////////////////////////////////////////////////////////////////////
library;

class MenuItemModel {
  /// 标题
  final String label;

  /// key
  final String key;

  /// 图标
  final String icon;

  /// 选中图标
  final String activeIcon;

  MenuItemModel({
    required this.label,
    required this.key,
    required this.icon,
    required this.activeIcon,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      label: json['label'],
      key: json['key'],
      icon: json['icon'],
      activeIcon: json['activeIcon'],
    );
  }
}
