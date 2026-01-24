import '../enums/permission_type.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 权限异常
///
/// Date: 2024年12月09日 22:45:44 Monday
///
//////////////////////////////////////////////////////////////////////////

class PermissionException implements Exception {
  final PermissionType type;

  final String message;

  PermissionException(this.type, this.message);
}
