part of 'utils.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 配置文件
///
/// Date: 2024年11月28日 22:23:07 Thursday
///
//////////////////////////////////////////////////////////////////////////

class _Config {
  _Config._();

  bool _isInit = false;

  late final Directory directory;

  /// 压缩输出路径
  late String compressedOutputPath;

  /// 应用名称
  String appName = 'Template';

  Future<void> init() async {
    if (_isInit) return;
    _isInit = true;
    directory = await getApplicationSupportDirectory();
    compressedOutputPath = p.join(directory.path, 'compress');
    await Directory(compressedOutputPath).create(recursive: true);

    debugPrint(directory.path);
  }
}
