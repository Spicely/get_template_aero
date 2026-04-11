import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../gen/assets.gen.dart';
import '../../../data/utils/utils.dart';
import '../../theme_button/theme_button.dart';

class UpgradeDialog extends StatelessWidget {
  const UpgradeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: !utils.upgrade.data.value.isForceUpgrade,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
            child: SizedBox(
              width: 295.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Assets.components.upgradeBg.image(width: 295.w, fit: BoxFit.fitWidth),
                      Positioned(
                        top: 160.w, // 根据设计图调整发现新版本和白色框的位置
                        left: 0,
                        right: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '发现新版本',
                                    style: TextStyle(fontSize: 23.sp, color: const Color.fromRGBO(28, 28, 28, 1), fontWeight: FontWeight.w700),
                                  ),
                                  6.verticalSpace,
                                  Text(
                                    utils.upgrade.data.value.versionCode,
                                    style: TextStyle(fontSize: 13.sp, color: const Color.fromRGBO(102, 102, 102, 1)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18.r), bottomRight: Radius.circular(18.r)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  8.verticalSpace,
                                  Text(
                                    '更新内容：',
                                    style: TextStyle(fontSize: 13.sp, color: const Color.fromRGBO(51, 51, 51, 1)),
                                  ),
                                  SizedBox(
                                    height: 70.h,
                                    child: ListView(
                                      padding: EdgeInsets.zero,
                                      children: [
                                        Html(
                                          data: utils.tools.removePTags(utils.upgrade.data.value.versionDesc),
                                          onLinkTap: (url, attributes, element) async {
                                            if (url != null) {
                                              final Uri uri = Uri.parse(url);
                                              if (await canLaunchUrl(uri)) {
                                                await launchUrl(uri);
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    alignment: Alignment.topCenter,
                                    child: Obx(
                                      () => utils.upgrade.isDownloading.value
                                          ? Column(
                                              children: [
                                                Text(
                                                  '${(utils.upgrade.progress.value * 100).toStringAsFixed(1)}%',
                                                  style: TextStyle(fontSize: 10.sp, color: Colors.grey[600], fontWeight: FontWeight.bold),
                                                ),
                                                8.verticalSpace,
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(6),
                                                  child: LinearProgressIndicator(value: utils.upgrade.progress.value, minHeight: 8.h, borderRadius: BorderRadius.circular(6), backgroundColor: Colors.grey[300], color: context.theme.primaryColor),
                                                ),
                                                10.verticalSpace,
                                                Text(
                                                  '下载中，请稍后',
                                                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                                                ),
                                              ],
                                            )
                                          : utils.upgrade.data.value.isForceUpgrade
                                          ? ThemeButton(
                                              height: 42.h,
                                              onPressed: utils.upgrade.upgrade,
                                              child: Text(
                                                '立即更新',
                                                style: TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.w500),
                                              ),
                                            )
                                          : Row(
                                              spacing: 13.w,
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 42.h,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.white,
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(22.r),
                                                          side: BorderSide(color: const Color.fromRGBO(25, 25, 25, 1), width: 1.w),
                                                        ),
                                                      ),
                                                      onPressed: Get.back,
                                                      child: Center(
                                                        child: Text(
                                                          '取消更新',
                                                          style: TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.w500),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: ThemeButton(
                                                    height: 42.h,
                                                    onPressed: utils.upgrade.upgrade,
                                                    child: Text(
                                                      '立即更新',
                                                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // if (!utils.upgrade.data.value.isForceUpgrade) 17.verticalSpace,
                  // if (!utils.upgrade.data.value.isForceUpgrade)
                  //   Center(
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         utils.upgrade.cancelUpgrade();
                  //         Get.back();
                  //       },
                  //       child: Assets.components.upgradeClose.image(width: 26.w, height: 26.h),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
