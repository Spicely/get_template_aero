import '../database.dart';

class ConfigManager {
  final AppDatabase _db;

  late ConfigModelData _config;

  ConfigManager._(this._db);

  static Future<ConfigManager> create(AppDatabase db) async {
    final manager = ConfigManager._(db);
    await manager._init();
    return manager;
  }

  Future<void> _init() async {
    final configs = await _db.select(_db.configModel).get();
    if (configs.isEmpty) {
      // 初始化默认配置
      final id = await _db.into(_db.configModel).insert(
            ConfigModelCompanion.insert(),
          );
      _config = ConfigModelData(id: id, isAgreement: false);
    } else {
      _config = configs.first;
    }
  }

  bool get isAgreement => _config.isAgreement;

  set isAgreement(bool value) {
    _config = _config.copyWith(isAgreement: value);
    _db.update(_db.configModel).replace(_config);
  }
}
