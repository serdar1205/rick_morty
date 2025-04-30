import 'dart:async';
import 'package:floor/floor.dart';
import 'package:rick_morty/features/data/datasources/local/dao/characters_dao.dart';
import 'package:rick_morty/features/data/datasources/local/dao/favorites_dao.dart';
import 'package:rick_morty/features/data/datasources/local/entity/character_local_entity.dart';
import 'package:rick_morty/features/data/datasources/local/entity/favorites_local_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [
  CharacterLocalEntity,
  FavoritesLocalEntity,
])
abstract class AppDataBase extends FloorDatabase {
  CharactersDao get charactersDao;

  FavoritesDao get favoritesDao;
}
