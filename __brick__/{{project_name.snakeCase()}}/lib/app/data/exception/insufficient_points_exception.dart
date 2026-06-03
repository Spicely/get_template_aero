/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 积分不足异常
///
/// Date: 2026年06月03日
///
//////////////////////////////////////////////////////////////////////////
library;

class InsufficientPointsException implements Exception {
  const InsufficientPointsException();

  @override
  String toString() => 'InsufficientPointsException: 积分余额不足';
}
