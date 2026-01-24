// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ConfigModelTable extends ConfigModel
    with TableInfo<$ConfigModelTable, ConfigModelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfigModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _isAgreementMeta =
      const VerificationMeta('isAgreement');
  @override
  late final GeneratedColumn<bool> isAgreement = GeneratedColumn<bool>(
      'is_agreement', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_agreement" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, isAgreement];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'config_model';
  @override
  VerificationContext validateIntegrity(Insertable<ConfigModelData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('is_agreement')) {
      context.handle(
          _isAgreementMeta,
          isAgreement.isAcceptableOrUnknown(
              data['is_agreement']!, _isAgreementMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfigModelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfigModelData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      isAgreement: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_agreement'])!,
    );
  }

  @override
  $ConfigModelTable createAlias(String alias) {
    return $ConfigModelTable(attachedDatabase, alias);
  }
}

class ConfigModelData extends DataClass implements Insertable<ConfigModelData> {
  final int id;
  final bool isAgreement;
  const ConfigModelData({required this.id, required this.isAgreement});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['is_agreement'] = Variable<bool>(isAgreement);
    return map;
  }

  ConfigModelCompanion toCompanion(bool nullToAbsent) {
    return ConfigModelCompanion(
      id: Value(id),
      isAgreement: Value(isAgreement),
    );
  }

  factory ConfigModelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfigModelData(
      id: serializer.fromJson<int>(json['id']),
      isAgreement: serializer.fromJson<bool>(json['isAgreement']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isAgreement': serializer.toJson<bool>(isAgreement),
    };
  }

  ConfigModelData copyWith({int? id, bool? isAgreement}) => ConfigModelData(
        id: id ?? this.id,
        isAgreement: isAgreement ?? this.isAgreement,
      );
  ConfigModelData copyWithCompanion(ConfigModelCompanion data) {
    return ConfigModelData(
      id: data.id.present ? data.id.value : this.id,
      isAgreement:
          data.isAgreement.present ? data.isAgreement.value : this.isAgreement,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfigModelData(')
          ..write('id: $id, ')
          ..write('isAgreement: $isAgreement')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, isAgreement);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfigModelData &&
          other.id == this.id &&
          other.isAgreement == this.isAgreement);
}

class ConfigModelCompanion extends UpdateCompanion<ConfigModelData> {
  final Value<int> id;
  final Value<bool> isAgreement;
  const ConfigModelCompanion({
    this.id = const Value.absent(),
    this.isAgreement = const Value.absent(),
  });
  ConfigModelCompanion.insert({
    this.id = const Value.absent(),
    this.isAgreement = const Value.absent(),
  });
  static Insertable<ConfigModelData> custom({
    Expression<int>? id,
    Expression<bool>? isAgreement,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isAgreement != null) 'is_agreement': isAgreement,
    });
  }

  ConfigModelCompanion copyWith({Value<int>? id, Value<bool>? isAgreement}) {
    return ConfigModelCompanion(
      id: id ?? this.id,
      isAgreement: isAgreement ?? this.isAgreement,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isAgreement.present) {
      map['is_agreement'] = Variable<bool>(isAgreement.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfigModelCompanion(')
          ..write('id: $id, ')
          ..write('isAgreement: $isAgreement')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ConfigModelTable configModel = $ConfigModelTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [configModel];
}

typedef $$ConfigModelTableCreateCompanionBuilder = ConfigModelCompanion
    Function({
  Value<int> id,
  Value<bool> isAgreement,
});
typedef $$ConfigModelTableUpdateCompanionBuilder = ConfigModelCompanion
    Function({
  Value<int> id,
  Value<bool> isAgreement,
});

class $$ConfigModelTableFilterComposer
    extends Composer<_$AppDatabase, $ConfigModelTable> {
  $$ConfigModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAgreement => $composableBuilder(
      column: $table.isAgreement, builder: (column) => ColumnFilters(column));
}

class $$ConfigModelTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfigModelTable> {
  $$ConfigModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAgreement => $composableBuilder(
      column: $table.isAgreement, builder: (column) => ColumnOrderings(column));
}

class $$ConfigModelTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfigModelTable> {
  $$ConfigModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isAgreement => $composableBuilder(
      column: $table.isAgreement, builder: (column) => column);
}

class $$ConfigModelTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConfigModelTable,
    ConfigModelData,
    $$ConfigModelTableFilterComposer,
    $$ConfigModelTableOrderingComposer,
    $$ConfigModelTableAnnotationComposer,
    $$ConfigModelTableCreateCompanionBuilder,
    $$ConfigModelTableUpdateCompanionBuilder,
    (
      ConfigModelData,
      BaseReferences<_$AppDatabase, $ConfigModelTable, ConfigModelData>
    ),
    ConfigModelData,
    PrefetchHooks Function()> {
  $$ConfigModelTableTableManager(_$AppDatabase db, $ConfigModelTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfigModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfigModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfigModelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> isAgreement = const Value.absent(),
          }) =>
              ConfigModelCompanion(
            id: id,
            isAgreement: isAgreement,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> isAgreement = const Value.absent(),
          }) =>
              ConfigModelCompanion.insert(
            id: id,
            isAgreement: isAgreement,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConfigModelTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConfigModelTable,
    ConfigModelData,
    $$ConfigModelTableFilterComposer,
    $$ConfigModelTableOrderingComposer,
    $$ConfigModelTableAnnotationComposer,
    $$ConfigModelTableCreateCompanionBuilder,
    $$ConfigModelTableUpdateCompanionBuilder,
    (
      ConfigModelData,
      BaseReferences<_$AppDatabase, $ConfigModelTable, ConfigModelData>
    ),
    ConfigModelData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ConfigModelTableTableManager get configModel =>
      $$ConfigModelTableTableManager(_db, _db.configModel);
}
