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
    EasyLoading.dismiss();
    utils.logger.e(error);
    switch (error) {
      case ToastException():
        EasyLoading.showToast(error.message);
      case PermissionException():
        Get.dialog(PermissionDialog(exception: error), barrierDismissible: false, useSafeArea: false);
      case LoginCancelException(showPrompt: true):
        break;
      case InsufficientPointsException():
        EasyLoading.showToast('积分余额不足');
      case DioException():
        EasyLoading.showToast(error.message ?? '');
      default:
        break;
    }
  }

  void report(Object error, {StackTrace? stack}) async {
    utils.logger.e(error, stackTrace: stack);
  }
}
