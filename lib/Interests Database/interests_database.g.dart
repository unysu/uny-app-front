// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interests_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorInterestsDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$InterestsDatabaseBuilder databaseBuilder(String name) =>
      _$InterestsDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$InterestsDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$InterestsDatabaseBuilder(null);
}

class _$InterestsDatabaseBuilder {
  _$InterestsDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$InterestsDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$InterestsDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<InterestsDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$InterestsDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$InterestsDatabase extends InterestsDatabase {
  _$InterestsDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  InterestsDao? _interestsModelDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `InterestsModel` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `type` TEXT, `startColor` TEXT, `endColor` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  InterestsDao get interestsModelDao {
    return _interestsModelDaoInstance ??=
        _$InterestsDao(database, changeListener);
  }
}

class _$InterestsDao extends InterestsDao {
  _$InterestsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _interestsModelInsertionAdapter = InsertionAdapter(
            database,
            'InterestsModel',
            (InterestsModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'type': item.type,
                  'startColor': item.startColor,
                  'endColor': item.endColor
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<InterestsModel> _interestsModelInsertionAdapter;

  @override
  Future<List<InterestsModel>> getAllInterestsByLimit(
      String start, String end) async {
    return _queryAdapter.queryList('SELECT * FROM InterestsModel LIMIT ?1, ?2',
        mapper: (Map<String, Object?> row) => InterestsModel(
            row['id'] as int?,
            row['name'] as String?,
            row['type'] as String?,
            row['startColor'] as String?,
            row['endColor'] as String?),
        arguments: [start, end]);
  }

  @override
  Future<List<InterestsModel>> getTravelingInterestsByLimit(
      String start, String end) async {
    return _queryAdapter.queryList(
        'SELECT * FROM InterestsModel WHERE type = \'traveling\' LIMIT ?1, ?2',
        mapper: (Map<String, Object?> row) => InterestsModel(
            row['id'] as int?,
            row['name'] as String?,
            row['type'] as String?,
            row['startColor'] as String?,
            row['endColor'] as String?),
        arguments: [start, end]);
  }

  @override
  Future<List<InterestsModel>> getGeneralInterestsByLimit(
      String start, String end) async {
    return _queryAdapter.queryList(
        'SELECT * FROM InterestsModel WHERE type = \'general\' LIMIT ?1, ?2',
        mapper: (Map<String, Object?> row) => InterestsModel(
            row['id'] as int?,
            row['name'] as String?,
            row['type'] as String?,
            row['startColor'] as String?,
            row['endColor'] as String?),
        arguments: [start, end]);
  }

  @override
  Future<List<InterestsModel>> getCareerInterestsByLimit(
      String start, String end) async {
    return _queryAdapter.queryList(
        'SELECT * FROM InterestsModel WHERE type = \'career\' LIMIT ?1, ?2',
        mapper: (Map<String, Object?> row) => InterestsModel(
            row['id'] as int?,
            row['name'] as String?,
            row['type'] as String?,
            row['startColor'] as String?,
            row['endColor'] as String?),
        arguments: [start, end]);
  }

  @override
  Future<List<InterestsModel>> getFamilyInterestsByLimit() async {
    return _queryAdapter.queryList(
        'SELECT * FROM InterestsModel WHERE type = \'family\'',
        mapper: (Map<String, Object?> row) => InterestsModel(
            row['id'] as int?,
            row['name'] as String?,
            row['type'] as String?,
            row['startColor'] as String?,
            row['endColor'] as String?));
  }

  @override
  Future<List<InterestsModel>> getSportInterestsByLimit() async {
    return _queryAdapter.queryList(
        'SELECT * FROM InterestsModel WHERE type = \'sport\'',
        mapper: (Map<String, Object?> row) => InterestsModel(
            row['id'] as int?,
            row['name'] as String?,
            row['type'] as String?,
            row['startColor'] as String?,
            row['endColor'] as String?));
  }

  @override
  Future<List<InterestsModel>> filterInterests(String name) async {
    return _queryAdapter.queryList(
        'SELECT * FROM InterestsModel WHERE name LIKE %?1%',
        mapper: (Map<String, Object?> row) => InterestsModel(
            row['id'] as int?,
            row['name'] as String?,
            row['type'] as String?,
            row['startColor'] as String?,
            row['endColor'] as String?),
        arguments: [name]);
  }

  @override
  Future<List<InterestsModel>> getAllInterests() async {
    return _queryAdapter.queryList('SELECT * FROM InterestsModel',
        mapper: (Map<String, Object?> row) => InterestsModel(
            row['id'] as int?,
            row['name'] as String?,
            row['type'] as String?,
            row['startColor'] as String?,
            row['endColor'] as String?));
  }

  @override
  Future<void> insertInterest(List<InterestsModel> interestsModel) async {
    await _interestsModelInsertionAdapter.insertList(
        interestsModel, OnConflictStrategy.replace);
  }
}
