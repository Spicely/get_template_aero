import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 空组件样式
//// Date: 2020年06月19日 20:33:24 Friday
//////////////////////////////////////////////////////////////////////////

class Empty extends StatefulWidget {
  final bool? isEmpty;

  final Widget? child;

  /// 空组件样式
  final Widget? emptyChild;

  final String emptyText;

  const Empty({
    super.key,
    this.child,
    this.emptyChild,
    this.isEmpty,
    this.emptyText = '暂无数据',
  });

  @override
  State<StatefulWidget> createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  /// 错误状态
  ///
  /// true显示 false 不显示
  bool _status = false;

  @override
  initState() {
    _status = widget.isEmpty ?? false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Empty oldWidget) {
    if (oldWidget.isEmpty != _status) {
      setState(() {
        _status = widget.isEmpty ?? false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  /// 网络状态
  ///
  /// true 有网络 false 无网络
  // bool _network = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.child != null) widget.child!,
        Offstage(
          offstage: widget.isEmpty == null ? !_status : !widget.isEmpty!,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.emptyChild ??
                      Column(
                        children: [
                          // Assets.images.draftEmpty.image(width: 138.w),
                          10.verticalSpace,
                          Text(widget.emptyText, style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                        ],
                      ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Future<bool> _getNetwork() async {
  //   ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
  //   if (connectivityResult == ConnectivityResult.none) {
  //     return false;
  //   }
  //   return true;
  // }
}
