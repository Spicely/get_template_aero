part of 'utils.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 数据库管理
///
/// Date: 2025年06月04日 13:59:53 Wednesday
///
//////////////////////////////////////////////////////////////////////////

class _DB {
  final database = AppDatabase();

  late ConfigManager config;

  _DB._();

  Future<void> init() async {
    config = await ConfigManager.create(database);
  }
}
