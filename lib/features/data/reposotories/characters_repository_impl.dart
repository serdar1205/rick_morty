import 'package:dartz/dartz.dart';
import 'package:rick_morty/core/constants/strings/app_strings.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/core/network/network.dart';
import 'package:rick_morty/features/data/datasources/local/local_datasources/character_local_datasource.dart';
import 'package:rick_morty/features/data/datasources/remote/characters_remote_datasource.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';
import 'package:rick_morty/features/domain/reposotories/character_repository.dart';

class CharactersRepositoryImpl implements CharacterRepository {
  final CharactersRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;
  final CharactersLocalDataSource localDataSource;

  CharactersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CharacterEntity>>> getAllCharacters(
      int page) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final response = await remoteDataSource.getAllCharacters(page);

        final result = response.map((e) => e.toEntity()).toList();

        await localDataSource.deleteAll();

        for (var item in response) {
          await localDataSource.insertCharacter(item.toCacheEntity());
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
    final localData = await localDataSource.getAllCharacters();

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
}
