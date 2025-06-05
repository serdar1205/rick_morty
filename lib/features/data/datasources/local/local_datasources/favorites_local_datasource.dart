import 'package:rick_morty/features/data/datasources/local/dao/favorites_dao.dart';
import 'package:rick_morty/features/data/datasources/local/entity/favorites_local_entity.dart';

abstract class FavoritesLocalDatasource {
  Future<void> insertFavorite(FavoritesLocalEntity news);

  Future<List<FavoritesLocalEntity>?> getFavorites();

  Future<void> deleteFavoriteOne(int id);

  Future<void> deleteFavorites();
}

class FaFavoritesLocalDatasourceImpl extends FavoritesLocalDatasource {
  final FavoritesDao _dao;

  FaFavoritesLocalDatasourceImpl(this._dao);

  @override
  Future<void> insertFavorite(FavoritesLocalEntity news) {
    return _dao.insertFavorite(news);
  }

  @override
  Future<List<FavoritesLocalEntity>?> getFavorites() {
    return _dao.getFavorites();
  }

  @override
  Future<void> deleteFavoriteOne(int id) {
    return _dao.deleteFavoriteOne(id);
  }

  @override
  Future<void> deleteFavorites() {
    return _dao.deleteFavorites();
  }
}
