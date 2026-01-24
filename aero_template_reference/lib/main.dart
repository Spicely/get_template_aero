import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/controllers/global_controller.dart';
import 'app/data/theme/theme_custom.dart';
import 'app/data/utils/utils.dart';
import 'app/routes/app_pages.dart';
import 'generated/l10n.dart';

void main() async {
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
          darkTheme: ThemeCustom.dark,
          // themeMode: ThemeMode.system,
          themeMode: ThemeMode.dark,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            S.delegate,
          ],
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
          builder: (context, child) {
            return GestureDetector(
              onTap: () {
                primaryFocus?.unfocus();
              },
              child: child ?? const SizedBox(),
            );
          },
        );
      },
    ),
  );
}
