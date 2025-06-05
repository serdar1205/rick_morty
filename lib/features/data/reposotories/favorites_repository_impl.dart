import 'package:dartz/dartz.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/core/network/network.dart';
import 'package:rick_morty/features/data/datasources/local/entity/favorites_local_entity.dart';
import 'package:rick_morty/features/data/datasources/local/local_datasources/favorites_local_datasource.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';
import 'package:rick_morty/features/domain/enums/sort_enums.dart';
import 'package:rick_morty/features/domain/reposotories/favorites_repository.dart';
import 'package:rick_morty/features/domain/usecases/favorites/filter_favorites_usecase.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final NetworkInfo networkInfo;
  final FavoritesLocalDatasource localDataSource;

  FavoritesRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> addToFavorite(CharacterEntity character) async {
    try {
      await localDataSource.insertFavorite(FavoritesLocalEntity(
          id: character.id,
          name: character.name,
          species: character.species,
          type: character.type,
          gender: character.gender,
          location: character.location,
          image: character.image,
          isFavorite: true));
      return Right(true);
    } catch (error) {
      return Left(EmptyCacheFailure('Empty db $error'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteFavoriteOne(int id) async {
    try {
      await localDataSource.deleteFavoriteOne(id);
      final localData = await localDataSource.getFavorites();
      final localItemsId = localData?.map((e) => e.id).toList() ?? [];
      final isDeleted = !localItemsId.contains(id);

      return Right(isDeleted);
    } catch (error) {
      return Left(EmptyCacheFailure('Empty db $error'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteFavorites() async {
    try {
      await localDataSource.deleteFavorites();
      final localData = await localDataSource.getFavorites();
      if (localData == null || localData.isEmpty) {
        return Right(true);
      } else {
        return Right(false);
      }
    } catch (error) {
      return Left(EmptyCacheFailure('Empty db $error'));
    }
  }

  @override
  Future<Either<Failure, List<CharacterEntity>>> getFavorites() async {
    try {
      final localData = await localDataSource.getFavorites();

      if (localData != null && localData.isNotEmpty) {
        final localItems = localData.map((e) => e.toEntity()).toList();
        return Right(localItems);
      } else {
        return Right([]);
      }
    } catch (e) {
      return Left(EmptyCacheFailure('Empty db $e'));
    }
  }

  @override
  Future<Either<Failure, List<CharacterEntity>>> filterFavorites(
      FilterCharacterParams params) async {
    try {
      final localData = await localDataSource.getFavorites();
      final items = localData?.map((e) => e.toEntity()).toList() ?? [];

      final filtered = items.where((e) {
        final genderMatches = switch (params.genderFilter) {
          CharacterGenders.all => true,
          CharacterGenders.male => e.gender == 'Male',
          CharacterGenders.female => e.gender == 'Female',
        };

        final locationMatches = switch (params.locationFilter) {
          CharacterLocations.all => true,
          CharacterLocations.earth => e.location.contains('Earth'),
          CharacterLocations.others => !e.location.contains('Earth'),
        };

        return genderMatches && locationMatches;
      }).toList();

      return Right(filtered);
    } catch (e) {
      return Left(EmptyCacheFailure('Empty db $e'));
    }
  }
}
