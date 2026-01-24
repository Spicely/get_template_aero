part of 'utils.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 错误类
///
/// Date: 2024年12月09日 13:38:43 Monday
///
//////////////////////////////////////////////////////////////////////////

class _Error {
  _Error._();

  void dioError(DioException dioError) {
    utils.logger.e(dioError);
  }

  void error(Object error) {
    utils.logger.e(error);
    if (error is PermissionException) {
      Get.dialog(PermissionDialog(exception: error), barrierDismissible: false, useSafeArea: false);
      return;
    }
  }
}
