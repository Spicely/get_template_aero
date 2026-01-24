part of 'utils.dart';

class _ExtendUpgrade extends _Upgrade {
  _ExtendUpgrade._();

  @override
  Future<UpgradeModel> checkUpgrade() async {
    // try {
    //  Map<String, dynamic> res = await utils.apis.getLatestVersion(channel, utils.config.projectId);

    //   String version = res["versionCode"].toString().toUpperCase().replaceAll('V', '');

    //   /// 本地
    //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //   String localVersion = packageInfo.version;

    //   /// 比对
    //   List<int> localVersionParts = localVersion.split('.').map(int.parse).toList();
    //   List<int> serviceVersionParts = version.split('.').map(int.parse).toList();

    //   int maxLength = max(localVersionParts.length, serviceVersionParts.length);
    //   bool isUpgrade = false;

    //   for (int i = 0; i < maxLength; i++) {
    //     int localPart = i < localVersionParts.length ? localVersionParts[i] : 0;
    //     int servicePart = i < serviceVersionParts.length ? serviceVersionParts[i] : 0;

    //     if (servicePart > localPart) {
    //       isUpgrade = true;
    //       break;
    //     } else if (servicePart < localPart) {
    //       break;
    //     }
    //   }

    //   return UpgradeModel(
    //     isUpgrade: isUpgrade,
    //     isForceUpgrade: res['isForce'] == 1,
    //     isSilentUpgrade: false,
    //     versionCode: res['versionCode'],
    //     fileUrl: res['fileUrl'],
    //     versionDesc: res['notice'],
    //   );
    // } catch (e) {
    //   utils.logger.e(e);
    return UpgradeModel();
    // }
  }

  @override
  void noUpgradeToast() {
    // EasyLoading.showToast('已经是最新版本了');
  }
}
