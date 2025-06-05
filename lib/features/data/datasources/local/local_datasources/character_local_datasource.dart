import 'package:rick_morty/features/data/datasources/local/dao/characters_dao.dart';
import 'package:rick_morty/features/data/datasources/local/entity/character_local_entity.dart';

abstract class CharactersLocalDataSource {
  Future<void> insertCharacter(CharacterLocalEntity character);

  Future<List<CharacterLocalEntity>?> getAllCharacters();

  Future<void> deleteAll();
}

class CharactersLocalDataSourceImpl implements CharactersLocalDataSource {
  final CharactersDao _dao;

  CharactersLocalDataSourceImpl(this._dao);

  @override
  Future<void> insertCharacter(CharacterLocalEntity character) {
    return _dao.insertCharacter(character);
  }

  @override
  Future<List<CharacterLocalEntity>?> getAllCharacters() {
    return _dao.getAllCharacters();
  }

  @override
  Future<void> deleteAll() {
    return _dao.deleteAll();
  }
}
