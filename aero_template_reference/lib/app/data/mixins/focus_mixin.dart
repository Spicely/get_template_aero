import 'package:flutter/material.dart';

mixin FocusMixin {
  BuildContext? context;

  /// 取消焦点
  void unfocus() {
    assert(context != null, 'context is null');
    FocusScope.of(context!).requestFocus(FocusNode());
  }
}
