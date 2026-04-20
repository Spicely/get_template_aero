import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../empty/empty.dart';
import '../future_layout_builder/future_layout_builder.dart';
import '../theme_config/theme_config.dart';

class SmartRefresh extends StatelessWidget {
  final EasyRefreshController controller;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final Future<dynamic> Function()? initData;

  /// 响应式的判空方法，用于自动展示空组件
  final bool Function()? isEmpty;

  final String emptyText;
  final Widget Function(BuildContext context, ScrollPhysics physics) childBuilder;
  final Widget? loadingWidget;

  const SmartRefresh({
    super.key,
    required this.controller,
    this.onRefresh,
    this.onLoadMore,
    this.initData,
    this.isEmpty,
    this.emptyText = '暂无数据',
    required this.childBuilder,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      controller: controller,
      header: ClassicHeader(
        dragText: '下拉刷新',
        armedText: '松开刷新',
        readyText: '刷新中...',
        processingText: '刷新中...',
        processedText: '刷新成功',
        noMoreText: '没有更多了',
        failedText: '刷新失败',
        showMessage: false,
        textStyle: TextStyle(color: const Color(0xFF6B7280), fontSize: 14.sp),
        iconTheme: const IconThemeData(color: Color(0xFF6B7280)),
      ),
      footer: ClassicFooter(
        dragText: '继续上拉',
        armedText: '松开加载',
        readyText: '加载中...',
        processingText: '加载中...',
        processedText: '加载成功',
        noMoreText: '- 没有更多数据了 -',
        failedText: '加载失败',
        showMessage: false,
        noMoreIcon: const SizedBox.shrink(),
        textStyle: TextStyle(color: const Color(0xFF6B7280), fontSize: 14.sp),
        iconTheme: const IconThemeData(color: Color(0xFF6B7280)),
        infiniteOffset: 400,
        clamping: false,
      ),
      onRefresh: onRefresh,
      onLoad: onLoadMore,
      childBuilder: (context, physics) {
        if (initData == null && isEmpty == null) {
          return childBuilder(context, physics);
        }

        Widget content = childBuilder(context, physics);

        if (isEmpty != null) {
          content = Obx(() {
            return Empty(
              isEmpty: isEmpty!(),
              emptyText: emptyText,
              child: childBuilder(context, physics),
            );
          });
        }

        if (initData != null) {
          Widget innerContent = content;
          content = FutureLayoutBuilder(
            future: initData,
            config: loadingWidget != null ? ThemeConfig(loadingWidget: (_) => loadingWidget!) : null,
            builder: (_) => innerContent,
          );
        }

        return content;
      },
    );
  }
}
