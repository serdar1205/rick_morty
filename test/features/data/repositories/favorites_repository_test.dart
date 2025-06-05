import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/features/data/datasources/local/entity/favorites_local_entity.dart';
import 'package:rick_morty/features/data/models/character_model.dart';
import 'package:rick_morty/features/data/reposotories/favorites_repository_impl.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';
import 'package:rick_morty/features/domain/enums/sort_enums.dart';
import 'package:rick_morty/features/domain/usecases/favorites/filter_favorites_usecase.dart';

import '../../../fixtures/json_reader.dart';
import '../../helper/test_helper.mocks.dart';


void main() {
  late FavoritesRepositoryImpl repository;
  late MockFavoritesLocalDatasource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  final String jsonName = 'character';
  final testJson = readJson(jsonName);
  final jsonList = json.decode(testJson)['results'] as List;

  final tEntities = <CharacterEntity>[];
  final tCacheModels = <FavoritesLocalEntity>[];

  for (final item in jsonList) {
    final model = CharacterModel.fromMap(item);
    tEntities.add(model.toEntity());
    tCacheModels.add(model.toFavCacheEntity());
  }
  final testCharacter = tEntities.first;
  final favoritesLocalEntity = tCacheModels.first;

  setUp(() {
    mockLocalDataSource = MockFavoritesLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = FavoritesRepositoryImpl(
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('addToFavorite', () {
    test('should return Right(true) when insert succeeds', () async {
      when(mockLocalDataSource.insertFavorite(any)).thenAnswer((_) async {});

      final result = await repository.addToFavorite(testCharacter);

      verify(mockLocalDataSource.insertFavorite(any));
      expect(result, Right(true));
    });

    test('should return Left(EmptyCacheFailure) on exception', () async {
      when(mockLocalDataSource.insertFavorite(any)).thenThrow(Exception('Db fail'));

      final result = await repository.addToFavorite(testCharacter);

      expect(result.isLeft(), true);
      expect(result, isA<Left<Failure, bool>>());
    });
  });

  group('deleteFavoriteOne', () {
    test('should return Right(true) when item is successfully deleted', () async {
      when(mockLocalDataSource.deleteFavoriteOne(1)).thenAnswer((_) async {});
      when(mockLocalDataSource.getFavorites()).thenAnswer((_) async => []);

      final result = await repository.deleteFavoriteOne(1);

      expect(result, Right(true));
    });

    test('should return Right(false) if item still exists after deletion', () async {
      when(mockLocalDataSource.deleteFavoriteOne(1)).thenAnswer((_) async {});
      when(mockLocalDataSource.getFavorites())
          .thenAnswer((_) async => [favoritesLocalEntity]);

      final result = await repository.deleteFavoriteOne(1);

      expect(result, Right(false));
    });

    test('should return Left(EmptyCacheFailure) on exception', () async {
      when(mockLocalDataSource.deleteFavoriteOne(1)).thenThrow(Exception());

      final result = await repository.deleteFavoriteOne(1);

      expect(result.isLeft(), true);
    });
  });

  group('deleteFavorites', () {
    test('should return Right(true) when all favorites are deleted', () async {
      when(mockLocalDataSource.deleteFavorites()).thenAnswer((_) async {});
      when(mockLocalDataSource.getFavorites()).thenAnswer((_) async => []);

      final result = await repository.deleteFavorites();

      expect(result, Right(true));
    });

    test('should return Right(false) when favorites still exist', () async {
      when(mockLocalDataSource.deleteFavorites()).thenAnswer((_) async {});
      when(mockLocalDataSource.getFavorites())
          .thenAnswer((_) async => [favoritesLocalEntity]);

      final result = await repository.deleteFavorites();

      expect(result, Right(false));
    });

    test('should return Left(EmptyCacheFailure) on exception', () async {
      when(mockLocalDataSource.deleteFavorites()).thenThrow(Exception());

      final result = await repository.deleteFavorites();

      expect(result.isLeft(), true);
    });
  });

  group('getFavorites', () {
    test('should return Right with list of favorites when local data exists', () async {
      when(mockLocalDataSource.getFavorites())
          .thenAnswer((_) async => [favoritesLocalEntity]);

      final result = await repository.getFavorites();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isA<List<CharacterEntity>>());
    });

    test('should return Right([]) when local data is empty', () async {
      when(mockLocalDataSource.getFavorites()).thenAnswer((_) async => []);

      final result = await repository.getFavorites();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), []);
    });



    test('should return Left(EmptyCacheFailure) on exception', () async {
      when(mockLocalDataSource.getFavorites()).thenThrow(Exception());

      final result = await repository.getFavorites();

      expect(result.isLeft(), true);
    });
  });

  group('filterFavorites', () {
    test('should return Right(filtered list)', () async {
      when(mockLocalDataSource.getFavorites())
          .thenAnswer((_) async => [favoritesLocalEntity]);

      final result = await repository.filterFavorites(
        FilterCharacterParams(
          genderFilter: CharacterGenders.male,
          locationFilter: CharacterLocations.earth,
        ),
      );

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isA<List<CharacterEntity>>());
    });

    test('should return Left(EmptyCacheFailure) on exception', () async {
      when(mockLocalDataSource.getFavorites()).thenThrow(Exception());

      final result = await repository.filterFavorites(
        FilterCharacterParams(
          genderFilter: CharacterGenders.male,
          locationFilter: CharacterLocations.earth,
        ),
      );

      expect(result.isLeft(), true);
    });
  });
}
