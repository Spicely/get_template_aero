// ignore_for_file: library_private_types_in_public_api

part of 'theme_custom.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 扩展自定义颜色
///
/// Date: 2024年11月28日 16:42:23 Thursday
///
//////////////////////////////////////////////////////////////////////////
class ExtendTheme extends ThemeExtension<ExtendTheme> {
  /// 主题色
  final Color themeColor;

  final Color gray;

  final Color subColor;

  final List<Color> gradientColors;

  final Color unSelectedColor;

  final Color selectedColor;

  const ExtendTheme({
    required this.themeColor,
    required this.gray,
    required this.subColor,
    required this.gradientColors,
    required this.unSelectedColor,
    required this.selectedColor,
  });

  @override
  ThemeExtension<ExtendTheme> copyWith() {
    return ExtendTheme(
      themeColor: themeColor,
      gray: gray,
      subColor: subColor,
      gradientColors: gradientColors,
      unSelectedColor: unSelectedColor,
      selectedColor: selectedColor,
    );
  }

  @override
  ThemeExtension<ExtendTheme> lerp(ThemeExtension<ExtendTheme> other, double t) {
    if (other is! ExtendTheme) {
      return this;
    }
    return ExtendTheme(
      themeColor: Color.lerp(themeColor, other.themeColor, t)!,
      gray: Color.lerp(gray, other.gray, t)!,
      subColor: Color.lerp(subColor, other.subColor, t)!,
      gradientColors: gradientColors,
      unSelectedColor: Color.lerp(unSelectedColor, other.unSelectedColor, t)!,
      selectedColor: Color.lerp(selectedColor, other.selectedColor, t)!,
    );
  }

  static const light = ExtendTheme(
    themeColor: Colors.white,
    gray: Color.fromRGBO(179, 179, 179, 1),
    subColor: Color.fromRGBO(127, 127, 127, 1),
    gradientColors: [Color.fromRGBO(37, 234, 231, 1), Color.fromRGBO(136, 249, 146, 1)],
    unSelectedColor: Color.fromRGBO(246, 246, 246, 1),
    selectedColor: Color.fromRGBO(229, 250, 240, 1),
  );

  static const dark = ExtendTheme(
    themeColor: Color.fromRGBO(32, 31, 41, 1),
    gray: Color.fromRGBO(179, 179, 179, 1),
    subColor: Color.fromRGBO(127, 127, 127, 1),
    gradientColors: [Color.fromRGBO(37, 234, 231, 1), Color.fromRGBO(136, 249, 146, 1)],
    unSelectedColor: Color.fromRGBO(246, 246, 246, 1),
    selectedColor: Color.fromRGBO(229, 250, 240, 1),
  );
}

class _ExtendTheme {
  final ExtendTheme? extendColors;

  _ExtendTheme._(this.extendColors);

  Color? get themeColor => extendColors?.themeColor;

  Color? get gray => extendColors?.gray;

  Color? get subColor => extendColors?.subColor;

  Color? get unSelectedColor => extendColors?.unSelectedColor;

  Color? get selectedColor => extendColors?.selectedColor;

  List<Color> get gradientColors => extendColors?.gradientColors ?? [];

  Color unlockColor = const Color.fromRGBO(27, 38, 31, 1);

  BorderRadius borderRadius = BorderRadius.circular(8.r);

  List<Color> tagGradientColors = const [Color.fromRGBO(255, 109, 63, 1), Color.fromRGBO(255, 97, 75, 1)];

  Color scaffoldBackgroundColor = const Color.fromRGBO(247, 247, 247, 1);

  /// 排行颜色
  final List<Color> colors = const [Color.fromRGBO(224, 46, 34, 1), Color.fromRGBO(255, 82, 27, 1), Color.fromRGBO(252, 195, 44, 1)];
}

/// 扩展BuildContext
extension BuildContextExtendColors on BuildContext {
  _ExtendTheme get eTheme => _ExtendTheme._(Theme.of(this).extension<ExtendTheme>());
}
