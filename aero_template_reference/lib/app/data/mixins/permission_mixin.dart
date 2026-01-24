import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../enums/permission_type.dart';
import '../exception/permission_exception.dart';
import '../utils/utils.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 权限获取
///
/// Date: 2024年11月28日 22:12:27 Thursday
///
//////////////////////////////////////////////////////////////////////////

mixin PermissionMixin {
  /// 获取定位权限
  Future<void> requestLocationPermission() async {
    if (await Permission.location.request().isGranted) {
      return;
    }
    throw PermissionException(PermissionType.location, '定位权限获取失败');
  }

  /// 获取相机权限
  Future<void> requestCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      return;
    }
    throw PermissionException(PermissionType.camera, '相机权限获取失败');
  }

  /// 获取麦克风权限
  Future<void> requestMicrophonePermission() async {
    if (await Permission.microphone.request().isGranted) {
      return;
    }
    throw PermissionException(PermissionType.microphone, '麦克风权限获取失败');
  }

  /// 获取存储权限
  Future<void> requestStoragePermission() async {
    if (Platform.isIOS) {
      PermissionStatus status = await Permission.photos.status;
      if (status.isGranted) {
        return;
      } else if (status.isDenied || status.isPermanentlyDenied) {
        _snackbar(
          '相册权限使用说明',
          '${utils.config.appName}正在向您获取"存储权限"，同意后，用于为您提供图片保存/视频保存/文件下载功能',
        );
        status = await Permission.photos.request();
        if (status.isGranted) {
          return;
        }
      }
      Get.closeCurrentSnackbar();
      throw PermissionException(PermissionType.storage, '存储权限获取失败');
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    bool storagePermission = await Permission.storage.isGranted;
    bool manageExternal = await Permission.manageExternalStorage.isGranted;
    String release = androidInfo.version.release;
    int sdkInt = androidInfo.version.sdkInt;
    if (sdkInt >= 34) {
      // Android 15 (UpsideDownCake)
      // Android 15 及以上版本，请求 READ_MEDIA_IMAGES 和 READ_MEDIA_VIDEO
      PermissionStatus imagesStatus = await Permission.photos.status;
      PermissionStatus videoStatus = await Permission.videos.status;

      if (!videoStatus.isGranted || !imagesStatus.isGranted) {
        _snackbar(
          '相册权限使用说明',
          '${utils.config.appName}正在向您获取"存储权限"，同意后，用于为您提供图片保存/视频保存/文件下载功能',
        );
        imagesStatus = await Permission.photos.request();
        videoStatus = await Permission.videos.request();
        Get.back();
      }
      Get.closeCurrentSnackbar();
      if (imagesStatus.isGranted && videoStatus.isGranted) {
        return;
      } else {
        throw PermissionException(PermissionType.storage, '存储权限获取失败');
      }
    } else if (sdkInt == 33) {
      // Android 13 (Tiramisu)
      // Android 13，请求 READ_MEDIA_IMAGES 和 READ_MEDIA_VIDEO
      PermissionStatus imagesStatus = await Permission.photos.status;
      PermissionStatus videoStatus = await Permission.videos.status;

      if (!imagesStatus.isGranted || !videoStatus.isGranted) {
        _snackbar(
          '相册权限使用说明',
          '${utils.config.appName}正在向您获取"存储权限"，同意后，用于为您提供图片保存/视频保存/文件下载功能',
        );
        imagesStatus = await Permission.photos.request();
        videoStatus = await Permission.videos.request();
      }
      Get.closeCurrentSnackbar();
      if (imagesStatus.isGranted && videoStatus.isGranted) {
        return;
      } else {
        throw PermissionException(PermissionType.storage, '存储权限获取失败');
      }
    } else {
      if (release.isNotEmpty) {
        List<String> releaseList = release.split('.');
        int firstValue = int.parse(releaseList.first);
        if (firstValue < 10) {
          manageExternal = true;
        }
      }
      if (!storagePermission || !manageExternal) {
        if (!storagePermission) {
          _snackbar(
            '相册权限使用说明',
            '${utils.config.appName}正在向您获取"存储权限"，同意后，用于为您提供图片保存/视频保存/文件下载功能',
          );
          storagePermission = await Permission.storage.request().isGranted;
        }
        if (!manageExternal) {
          manageExternal = await Permission.manageExternalStorage.request().isGranted;
        }
      }
      Get.closeCurrentSnackbar();
      if (storagePermission || manageExternal) {
        return;
      }
      throw PermissionException(PermissionType.storage, '存储权限获取失败');
    }
  }

  /// 安装权限
  Future<void> requestInstallPermission() async {
    if (await Permission.requestInstallPackages.isGranted) {
      return;
    }
    _snackbar(
      '应用安装权限使用说明',
      '${utils.config.appName}正在向您获取"应用安装权限"，同意后，用于在应用内打开应用的安装页面，以便用户安装最新的应用。',
    );
    await Future.delayed(const Duration(seconds: 2));
    if (await Permission.requestInstallPackages.request().isGranted) {
      Get.closeCurrentSnackbar();
      return;
    }
    Get.closeCurrentSnackbar();
    throw PermissionException(PermissionType.installPackages, '安装权限获取失败');
  }

  void _snackbar(String title, String message) {
    Get.rawSnackbar(
      titleText: Text(
        title,
        style: TextStyle(color: const Color.fromRGBO(25, 25, 25, 1), fontWeight: FontWeight.bold, fontSize: 18.sp),
      ),
      messageText: Text(
        message,
        style: TextStyle(color: const Color.fromRGBO(129, 129, 129, 1), fontSize: 13.sp),
      ),
      margin: EdgeInsets.symmetric(horizontal: 15.w).copyWith(top: 54.h),
      borderRadius: 8.r,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      isDismissible: false,
      duration: null,
    );
  }
}
