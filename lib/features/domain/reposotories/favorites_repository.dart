import 'package:dartz/dartz.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';
import 'package:rick_morty/features/domain/usecases/favorites/filter_favorites_usecase.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, bool>> addToFavorite(CharacterEntity character);
  Future<Either<Failure, List<CharacterEntity>>> getFavorites();
  Future<Either<Failure, List<CharacterEntity>>> filterFavorites(FilterCharacterParams params);
  Future<Either<Failure, bool>> deleteFavorites();
  Future<Either<Failure, bool>> deleteFavoriteOne(int id);
}
