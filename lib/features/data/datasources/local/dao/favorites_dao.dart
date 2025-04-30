import 'package:floor/floor.dart';
import 'package:rick_morty/features/data/datasources/local/entity/favorites_local_entity.dart';

@dao
abstract class FavoritesDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertFavorite(FavoritesLocalEntity news);

  @Query('SELECT * FROM FavoritesLocalEntity')
  Future<List<FavoritesLocalEntity>?> getFavorites();

  @Query('DELETE FROM FavoritesLocalEntity WHERE id = :id')
  Future<void> deleteFavoriteOne(int id);


  @Query('DELETE FROM FavoritesLocalEntity WHERE 1==1')
  Future<void> deleteFavorites();


}
