import 'package:floor/floor.dart';
import 'package:rick_morty/features/data/datasources/local/entity/character_local_entity.dart';

@dao
abstract class CharactersDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCharacter(CharacterLocalEntity news);

  @Query('SELECT * FROM CharacterLocalEntity')
  Future<List<CharacterLocalEntity>?> getAllCharacters();

  @Query('DELETE FROM CharacterLocalEntity WHERE 1==1')
  Future<void> deleteAll();
}
