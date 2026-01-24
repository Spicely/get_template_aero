class UpgradeModel {
  /// 强制更新
  final bool isForceUpgrade;

  /// 是否有更新
  final bool isUpgrade;

  /// 静默更新
  final bool isSilentUpgrade;

  /// 版本号
  final String versionCode;

  /// 新版本描述
  final String versionDesc;

  /// 新版本下载地址
  final String fileUrl;

  UpgradeModel({
    this.isForceUpgrade = false,
    this.isSilentUpgrade = false,
    this.isUpgrade = false,
    this.versionCode = '',
    this.versionDesc = '',
    this.fileUrl = '',
  });
}
