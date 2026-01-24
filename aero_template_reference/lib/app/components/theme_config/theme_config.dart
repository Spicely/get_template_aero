import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 主题配置
///
/// Date: 2024年12月17日 18:12:46 Tuesday
///
//////////////////////////////////////////////////////////////////////////

Widget _loadingWidget(BuildContext context) {
  return Center(
    child: SpinKitThreeBounce(
      size: 20,
      color: Theme.of(context).colorScheme.primary,
    ),
  );
}

Widget _loadFailWidget(BuildContext context, Object error, void reload) {
  return Center(
    child: Text(error is DioException ? error.message ?? '' : error.toString()),
  );
}

class ThemeConfig {
  final double radius;

  /// 加载动画
  Widget Function(BuildContext context) loadingWidget;

  /// 加载失败
  Widget Function(BuildContext context, Object error, Function() reload) loadFailWidget;

  ThemeConfig({
    this.loadingWidget = _loadingWidget,
    this.loadFailWidget = _loadFailWidget,
    this.radius = 8,
  });
}

final themeConfig = ThemeConfig();
