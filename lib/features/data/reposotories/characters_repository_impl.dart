import 'package:dartz/dartz.dart';
import 'package:rick_morty/core/constants/strings/app_strings.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/core/network/network.dart';
import 'package:rick_morty/features/data/datasources/db/app_database.dart';
import 'package:rick_morty/features/data/datasources/local/entity/favorites_local_entity.dart';
import 'package:rick_morty/features/data/datasources/remote/characters_remote_datasource.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';
import 'package:rick_morty/features/domain/reposotories/character_repository.dart';

class CharactersRepositoryImpl implements CharacterRepository {
  final CharactersRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;
  final AppDataBase localDataSource;

  CharactersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CharacterEntity>>> getAllCharacters(
      int page) async {
    final bool isConnected = await networkInfo.isConnected;
    final dao = localDataSource.charactersDao;
    if (isConnected) {
      try {
        final response = await remoteDataSource.getAllCharacters(page);

        final result = response.map((e) => e.toEntity()).toList();

        for (var item in response) {
          await dao.insertCharacter(item.toCacheEntity());
        }

        return Right(result);
      } catch (error) {
        return await _getLocalCharacters(isConnected);
      }
    } else {
      return await _getLocalCharacters(isConnected);
    }
  }

  Future<Either<Failure, List<CharacterEntity>>> _getLocalCharacters(
      bool isConnected) async {
    final dao = localDataSource.charactersDao;
    final localData = await dao.getAllCharacters();

    if (localData != null && localData.isNotEmpty) {
      final localItems = localData.map((e) => e.toEntity()).toList();
      return Right(localItems);
    } else {
      if (isConnected) {
        return Left(ServerFailure(''));
      } else {
        return Left(ConnectionFailure(AppStrings.noInternet));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> addToFavorite(CharacterEntity character) async {
    final dao = localDataSource.favoritesDao;
    try {
      await dao.insertFavorite(FavoritesLocalEntity(
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
    final dao = localDataSource.favoritesDao;
    try {
      await dao.deleteFavoriteOne(id);
      final localData = await dao.getFavorites();
      final localItemsId = localData?.map((e) => e.id).toList() ?? [];
      final isDeleted = !localItemsId.contains(id);

      return Right(isDeleted);
    } catch (error) {
      return Left(EmptyCacheFailure('Empty db $error'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteFavorites() async {
    final dao = localDataSource.favoritesDao;
    try {
      await dao.deleteFavorites();
      final localData = await dao.getFavorites();
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
    final dao = localDataSource.favoritesDao;

    try {
      final localData = await dao.getFavorites();

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
}
