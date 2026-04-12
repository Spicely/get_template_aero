import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'app/controllers/global_controller.dart';
import 'app/data/theme/theme_custom.dart';
import 'app/data/utils/utils.dart';
import 'app/routes/app_pages.dart';
import 'generated/l10n.dart';

void main() async {
  FlutterBugly.postCatchedException(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
      await utils.init();

      Get.put(GlobalController());

      runApp(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) {
            return GetMaterialApp(
              title: utils.config.appName,
              initialRoute: AppPages.INITIAL,
              theme: ThemeCustom.light,
              darkTheme: ThemeCustom.light,
              // themeMode: ThemeMode.system,
              themeMode: ThemeMode.dark,
              localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate, GlobalWidgetsLocalizations.delegate, S.delegate],
              supportedLocales: S.delegate.supportedLocales,
              localeListResolutionCallback: (locales, supportedLocales) {
                debugPrint('当前系统语言环境$locales');
                return;
              },
              localeResolutionCallback: (locale, supportedLocales) {
                debugPrint('当前系统语言环境$locale');
                return locale;
              },
              getPages: AppPages.routes,
              builder: EasyLoading.init(
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                    child: GestureDetector(
                      onTap: () {
                        primaryFocus?.unfocus();
                      },
                      child: child ?? const SizedBox(),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    },
    onException: (FlutterErrorDetails details) {
      // 双上报：发送至腾讯 Bugly 的同时，也记录到自己的服务器异常日志中
      final error = details.exception;
      if (error is DioException) {
        utils.error.dioError(error);
      } else {
        utils.error.report(error, stack: details.stack);
      }
    },
  );
}
