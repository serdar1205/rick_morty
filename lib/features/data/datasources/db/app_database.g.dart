// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDataBaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDataBaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDataBaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDataBase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDataBase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDataBaseBuilderContract databaseBuilder(String name) =>
      _$AppDataBaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDataBaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDataBaseBuilder(null);
}

class _$AppDataBaseBuilder implements $AppDataBaseBuilderContract {
  _$AppDataBaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDataBaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDataBaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDataBase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDataBase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDataBase extends AppDataBase {
  _$AppDataBase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CharactersDao? _charactersDaoInstance;

  FavoritesDao? _favoritesDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
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
            'CREATE TABLE IF NOT EXISTS `CharacterLocalEntity` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `species` TEXT NOT NULL, `type` TEXT NOT NULL, `gender` TEXT NOT NULL, `location` TEXT NOT NULL, `image` TEXT NOT NULL, `isFavorite` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FavoritesLocalEntity` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `species` TEXT NOT NULL, `type` TEXT NOT NULL, `gender` TEXT NOT NULL, `location` TEXT NOT NULL, `image` TEXT NOT NULL, `isFavorite` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CharactersDao get charactersDao {
    return _charactersDaoInstance ??= _$CharactersDao(database, changeListener);
  }

  @override
  FavoritesDao get favoritesDao {
    return _favoritesDaoInstance ??= _$FavoritesDao(database, changeListener);
  }
}

class _$CharactersDao extends CharactersDao {
  _$CharactersDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _characterLocalEntityInsertionAdapter = InsertionAdapter(
            database,
            'CharacterLocalEntity',
            (CharacterLocalEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'species': item.species,
                  'type': item.type,
                  'gender': item.gender,
                  'location': item.location,
                  'image': item.image,
                  'isFavorite': item.isFavorite ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CharacterLocalEntity>
      _characterLocalEntityInsertionAdapter;

  @override
  Future<List<CharacterLocalEntity>?> getAllCharacters() async {
    return _queryAdapter.queryList('SELECT * FROM CharacterLocalEntity',
        mapper: (Map<String, Object?> row) => CharacterLocalEntity(
            id: row['id'] as int,
            name: row['name'] as String,
            species: row['species'] as String,
            type: row['type'] as String,
            gender: row['gender'] as String,
            location: row['location'] as String,
            image: row['image'] as String,
            isFavorite: (row['isFavorite'] as int) != 0));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM CharacterLocalEntity WHERE 1==1');
  }

  @override
  Future<void> insertCharacter(CharacterLocalEntity news) async {
    await _characterLocalEntityInsertionAdapter.insert(
        news, OnConflictStrategy.replace);
  }
}

class _$FavoritesDao extends FavoritesDao {
  _$FavoritesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _favoritesLocalEntityInsertionAdapter = InsertionAdapter(
            database,
            'FavoritesLocalEntity',
            (FavoritesLocalEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'species': item.species,
                  'type': item.type,
                  'gender': item.gender,
                  'location': item.location,
                  'image': item.image,
                  'isFavorite': item.isFavorite ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FavoritesLocalEntity>
      _favoritesLocalEntityInsertionAdapter;

  @override
  Future<List<FavoritesLocalEntity>?> getFavorites() async {
    return _queryAdapter.queryList('SELECT * FROM FavoritesLocalEntity',
        mapper: (Map<String, Object?> row) => FavoritesLocalEntity(
            id: row['id'] as int,
            name: row['name'] as String,
            species: row['species'] as String,
            type: row['type'] as String,
            gender: row['gender'] as String,
            location: row['location'] as String,
            image: row['image'] as String,
            isFavorite: (row['isFavorite'] as int) != 0));
  }

  @override
  Future<void> deleteFavoriteOne(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM FavoritesLocalEntity WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteFavorites() async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM FavoritesLocalEntity WHERE 1==1');
  }

  @override
  Future<void> insertFavorite(FavoritesLocalEntity news) async {
    await _favoritesLocalEntityInsertionAdapter.insert(
        news, OnConflictStrategy.replace);
  }
}
