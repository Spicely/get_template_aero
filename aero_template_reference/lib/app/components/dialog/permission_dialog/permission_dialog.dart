import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/exception/permission_exception.dart';

class PermissionDialog extends StatelessWidget {
  final PermissionException exception;

  const PermissionDialog({super.key, required this.exception});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(exception.message),
      content: const SizedBox(
        height: 60,
        child: Center(child: Text('是否打开应用设置')),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: Get.back,
          child: const Text('取消', style: TextStyle(color: Colors.black)),
        ),
        CupertinoDialogAction(
          onPressed: () {
            Get.back();
            openAppSettings();
          },
          child: const Text('确认', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
