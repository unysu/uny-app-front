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

  FamilyInterestsDao? _familyInterestsDaoInstance;

  CareerInterestsDao? _careerInterestsDaoInstance;

  SportInterestsDao? _sportInterestsDaoInstance;

  TravelingInterestsDao? _travelingInterestsDaoInstance;

  GeneralInterestsDao? _generalInterestsDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `FamilyInterestsModel` (`id` INTEGER, `name` TEXT, `color` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CareerInterestsModel` (`id` INTEGER, `name` TEXT, `color` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SportInterestsModel` (`id` INTEGER, `name` TEXT, `color` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TravellingInterestsModel` (`id` INTEGER, `name` TEXT, `color` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `GeneralInterestsModel` (`id` INTEGER, `name` TEXT, `color` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FamilyInterestsDao get familyInterestsDao {
    return _familyInterestsDaoInstance ??=
        _$FamilyInterestsDao(database, changeListener);
  }

  @override
  CareerInterestsDao get careerInterestsDao {
    return _careerInterestsDaoInstance ??=
        _$CareerInterestsDao(database, changeListener);
  }

  @override
  SportInterestsDao get sportInterestsDao {
    return _sportInterestsDaoInstance ??=
        _$SportInterestsDao(database, changeListener);
  }

  @override
  TravelingInterestsDao get travelingInterestsDao {
    return _travelingInterestsDaoInstance ??=
        _$TravelingInterestsDao(database, changeListener);
  }

  @override
  GeneralInterestsDao get generalInterestsDao {
    return _generalInterestsDaoInstance ??=
        _$GeneralInterestsDao(database, changeListener);
  }
}

class _$FamilyInterestsDao extends FamilyInterestsDao {
  _$FamilyInterestsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _familyInterestsModelInsertionAdapter = InsertionAdapter(
            database,
            'FamilyInterestsModel',
            (FamilyInterestsModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'color': item.color
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FamilyInterestsModel>
      _familyInterestsModelInsertionAdapter;

  @override
  Future<List<FamilyInterestsModel>> getFamilyInterests() async {
    return _queryAdapter.queryList('SELECT * FROM FamilyInterestsModel',
        mapper: (Map<String, Object?> row) => FamilyInterestsModel(
            row['id'] as int?,
            row['name'] as String?,
            row['color'] as String?));
  }

  @override
  Future<void> insertFamilyInterest(
      FamilyInterestsModel familyInterestsModel) async {
    await _familyInterestsModelInsertionAdapter.insert(
        familyInterestsModel, OnConflictStrategy.replace);
  }
}

class _$CareerInterestsDao extends CareerInterestsDao {
  _$CareerInterestsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _careerInterestsModelInsertionAdapter = InsertionAdapter(
            database,
            'CareerInterestsModel',
            (CareerInterestsModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'color': item.color
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CareerInterestsModel>
      _careerInterestsModelInsertionAdapter;

  @override
  Future<List<CareerInterestsModel>> getCareerInterests() async {
    return _queryAdapter.queryList('SELECT * FROM CareerInterestsModel',
        mapper: (Map<String, Object?> row) => CareerInterestsModel(
            row['id'] as int?,
            row['name'] as String?,
            row['color'] as String?));
  }

  @override
  Future<void> insertCareerInterests(
      CareerInterestsModel careerInterestsModel) async {
    await _careerInterestsModelInsertionAdapter.insert(
        careerInterestsModel, OnConflictStrategy.replace);
  }
}

class _$SportInterestsDao extends SportInterestsDao {
  _$SportInterestsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _sportInterestsModelInsertionAdapter = InsertionAdapter(
            database,
            'SportInterestsModel',
            (SportInterestsModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'color': item.color
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SportInterestsModel>
      _sportInterestsModelInsertionAdapter;

  @override
  Future<List<SportInterestsModel>> getSportInterests() async {
    return _queryAdapter.queryList('SELECT * FROM SportInterestsModel',
        mapper: (Map<String, Object?> row) => SportInterestsModel(
            row['id'] as int?,
            row['name'] as String?,
            row['color'] as String?));
  }

  @override
  Future<void> insertSportInterests(
      SportInterestsModel sportInterestsModel) async {
    await _sportInterestsModelInsertionAdapter.insert(
        sportInterestsModel, OnConflictStrategy.replace);
  }
}

class _$TravelingInterestsDao extends TravelingInterestsDao {
  _$TravelingInterestsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _travellingInterestsModelInsertionAdapter = InsertionAdapter(
            database,
            'TravellingInterestsModel',
            (TravellingInterestsModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'color': item.color
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TravellingInterestsModel>
      _travellingInterestsModelInsertionAdapter;

  @override
  Future<List<TravellingInterestsModel>> getTravelingInterests() async {
    return _queryAdapter.queryList('SELECT * FROM TravellingInterestsModel',
        mapper: (Map<String, Object?> row) => TravellingInterestsModel(
            row['id'] as int?,
            row['name'] as String?,
            row['color'] as String?));
  }

  @override
  Future<void> insertTravelingInterests(
      TravellingInterestsModel travellingInterestsModel) async {
    await _travellingInterestsModelInsertionAdapter.insert(
        travellingInterestsModel, OnConflictStrategy.replace);
  }
}

class _$GeneralInterestsDao extends GeneralInterestsDao {
  _$GeneralInterestsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _generalInterestsModelInsertionAdapter = InsertionAdapter(
            database,
            'GeneralInterestsModel',
            (GeneralInterestsModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'color': item.color
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<GeneralInterestsModel>
      _generalInterestsModelInsertionAdapter;

  @override
  Future<List<GeneralInterestsModel>> getGeneralInterests() async {
    return _queryAdapter.queryList('SELECT * FROM GeneralInterestsModel',
        mapper: (Map<String, Object?> row) => GeneralInterestsModel(
            row['id'] as int?,
            row['name'] as String?,
            row['color'] as String?));
  }

  @override
  Future<void> insertGeneralInterests(
      GeneralInterestsModel generalInterestsModel) async {
    await _generalInterestsModelInsertionAdapter.insert(
        generalInterestsModel, OnConflictStrategy.replace);
  }
}
