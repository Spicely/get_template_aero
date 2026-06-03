/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 登录取消或失败异常
///
/// Date: 2026年06月03日
///
//////////////////////////////////////////////////////////////////////////
library;

class LoginCancelException implements Exception {
  final bool showPrompt;

  const LoginCancelException({this.showPrompt = true});

  @override
  String toString() => 'LoginCancelException: 用户取消了登录或登录失败';
}
