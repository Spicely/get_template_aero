part of '../utils.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 应用更新
///
/// Date: 2024年12月09日 22:44:35 Monday
///
//////////////////////////////////////////////////////////////////////////

class _Upgrade with PermissionMixin {
  RxBool isUpgrade = false.obs;

  RxBool isDownloading = false.obs;

  /// 进度
  RxDouble progress = 0.0.obs;

  Rx<UpgradeModel> data = UpgradeModel().obs;

  /// 更新APP
  void inspect({bool callToast = true}) {
    if (isUpgrade.value) return;
    isUpgrade.value = true;
    utils.tools.exceptionCapture(() async {
      data.value = await checkUpgrade();
      if (data.value.isUpgrade) {
        if (data.value.isSilentUpgrade) {
          upgrade();
        } else {
          Get.dialog(const UpgradeDialog(), barrierDismissible: false);
        }
      } else {
        isUpgrade.value = false;
        if (callToast) {
          noUpgradeToast();
        }
      }
    });
  }

  /// 返回更新信息
  Future<UpgradeModel> checkUpgrade() async {
    return UpgradeModel();
  }

  /// 无更新提示
  void noUpgradeToast() {}

  /// 取消更新
  void cancelUpgrade() {
    if (!isDownloading.value) {
      isUpgrade.value = false;
    }
  }

  /// 开始更新
  Future<void> upgrade() async {
    if (isDownloading.value) return;
    isDownloading.value = true;

    if (Platform.isAndroid || Platform.isWindows || Platform.isMacOS) {
      await _downloadFile();
    } else {
      await _install(data.value.fileUrl);
    }
  }

  /// 下载apk
  Future<void> _downloadFile() async {
    try {
      /// 保存地址
      String directory = p.join(utils.config.directory.path, 'downloads');
      Directory(directory).createSync(recursive: true);

      /// 文件名
      String filename = p.basename(data.value.fileUrl);

      String savePath = p.join(directory, filename);

      /// 判断文件是否存在
      if (File(savePath).existsSync()) {
        // await _install(savePath);
        // return;
      }

      /// 开始下载
      await Dio().download(
        data.value.fileUrl,
        savePath,
        onReceiveProgress: (count, total) {
          progress.value = count / total;
        },
      );
      await _install(savePath);
    } catch (e) {
      isUpgrade.value = false;
      isDownloading.value = false;
      progress.value = 0.0;
      utils.logger.e('下载失败,请检查网络连接');
    }
  }

  /// 安装应用
  Future<void> _install(String filePath) async {
    await requestStoragePermission();
    const types = {
      '.apk': 'application/vnd.android.package-archive',
      '.exe': 'application/octet-stream',
    };

    switch (Platform.operatingSystem) {
      case 'android':
      case 'windows':
        await requestInstallPermission();
        final extension = p.extension(filePath);
        await OpenFile.open(filePath, type: types[extension]);
        break;

      case 'ios':
        Uri uri = Uri.parse('https://apps.apple.com/cn/app/id$filePath');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          utils.logger.e('无法打开App Store链接,请联系客服');
        }
        break;
    }

    isUpgrade.value = false;
    isDownloading.value = false;
  }
}
