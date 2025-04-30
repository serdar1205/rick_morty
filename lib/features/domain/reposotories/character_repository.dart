import 'package:dartz/dartz.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';

abstract class CharacterRepository {
  Future<Either<Failure, List<CharacterEntity>>> getAllCharacters(int page);

  Future<Either<Failure, bool>> addToFavorite(CharacterEntity character);

  Future<Either<Failure, List<CharacterEntity>>> getFavorites();

  Future<Either<Failure, bool>> deleteFavorites();

  Future<Either<Failure, bool>> deleteFavoriteOne(int id);
}
