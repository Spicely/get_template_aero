import 'package:drift/drift.dart';

class ConfigModel extends Table {
  IntColumn get id => integer().autoIncrement()();

  BoolColumn get isAgreement => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id}; // 设置主键为 id
}
