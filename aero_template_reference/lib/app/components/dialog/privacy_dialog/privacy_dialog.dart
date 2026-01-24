import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/utils/utils.dart';
import '../../../routes/app_pages.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 隐私政策弹窗
///
/// Date: 2024年11月29日 17:21:37 Friday
///
//////////////////////////////////////////////////////////////////////////

class PrivacyDialog extends StatelessWidget {
  /// 隐私地址
  final String privacyUrl;

  /// 用户协议地址
  final String userAgreementUrl;

  /// 同意
  final VoidCallback? onAgree;

  const PrivacyDialog({
    super.key,
    required this.privacyUrl,
    required this.userAgreementUrl,
    this.onAgree,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: CupertinoAlertDialog(
        title: Text('欢迎使用 ${utils.config.appName}'),
        content: SizedBox(
          height: 120,
          child: ListView(
            children: [
              const Text('我们非常重视您的隐私保护，特此向您说明我们如何收集、使用、存储和保护您的个人信息。'),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '《隐私协议》',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(Routes.BROWSER, parameters: {'url': privacyUrl, 'title': '隐私协议'});
                        },
                      style: const TextStyle(color: Colors.blue),
                    ),
                    TextSpan(
                      text: '《用户协议》',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(Routes.BROWSER, parameters: {'url': userAgreementUrl, 'title': '用户协议'});
                        },
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const Text('请仔细阅读并理解以下隐私政策：'),
              const Text('1. 我们会收集您的设备信息、位置信息、日志信息等，以便为您提供更好的服务和体验。'),
              const Text('2. 我们会使用您的个人信息进行数据分析，以便为您提供个性化的服务和推荐。'),
              const Text('3. 我们会采取合理的安全措施保护您的个人信息，防止未经授权的访问、使用、披露或破坏。'),
              const Text('4. 您有权访问、修改、删除您的个人信息，并有权要求我们停止收集、使用您的个人信息。'),
              const Text('5. 我们会根据法律法规的要求，及时更新隐私政策，并在必要时通知您。'),
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('不同意', style: TextStyle(color: Colors.black)),
            onPressed: () {
              exit(0);
            },
          ),
          CupertinoDialogAction(
            onPressed: onAgree,
            child: const Text('同意', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
