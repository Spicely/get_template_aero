import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'extend_theme.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 自定义主题
///
/// Date: 2024年11月28日 16:42:41 Thursday
///
//////////////////////////////////////////////////////////////////////////

class ThemeCustom {
  static ThemeData light = ThemeData(
    extensions: const <ThemeExtension<ExtendTheme>>[ExtendTheme.light],
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Colors.green,
    ),
  );

  static ThemeData dark = ThemeData(
    extensions: const <ThemeExtension<ExtendTheme>>[ExtendTheme.dark],
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Colors.green,
    ),
  );
}
