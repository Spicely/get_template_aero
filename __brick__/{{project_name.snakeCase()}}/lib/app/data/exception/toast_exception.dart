/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 弹窗异常
///
/// Date: 2026年06月03日
///
//////////////////////////////////////////////////////////////////////////
library;

class ToastException implements Exception {
  final String message;

  const ToastException(this.message);

  @override
  String toString() => message;
}
