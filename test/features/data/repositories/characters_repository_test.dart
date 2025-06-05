import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rick_morty/core/constants/strings/app_strings.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/features/data/datasources/local/entity/character_local_entity.dart';
import 'package:rick_morty/features/data/models/character_model.dart';
import 'package:rick_morty/features/data/reposotories/characters_repository_impl.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';

import '../../../fixtures/json_reader.dart';
import '../../helper/test_helper.mocks.dart';

void main() {
  late CharactersRepositoryImpl repository;
  late MockCharactersRemoteDatasource mockRemoteDataSource;
  late MockCharactersLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockCharactersRemoteDatasource();
    mockLocalDataSource = MockCharactersLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CharactersRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final String jsonName = 'character';
  final testJson = readJson(jsonName);
  final jsonList = json.decode(testJson)['results'] as List;

  final tRemoteModels = <CharacterModel>[];
  final tEntities = <CharacterEntity>[];
  final tCacheModels = <CharacterLocalEntity>[];

  for (final item in jsonList) {
    final model = CharacterModel.fromMap(item);
    tRemoteModels.add(model);
    tEntities.add(model.toEntity());
    tCacheModels.add(model.toCacheEntity());
  }
  final tPage = 1;

  group('getAllCharacters', () {
    test('should return remote data when online and remote call succeeds',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllCharacters(tPage))
          .thenAnswer((_) async => tRemoteModels);
      when(mockLocalDataSource.deleteAll()).thenAnswer((_) async {});
      when(mockLocalDataSource.insertCharacter(any))
          .thenAnswer((_) async => {});

      final result = await repository.getAllCharacters(tPage);

      verify(mockRemoteDataSource.getAllCharacters(tPage));
     verify(mockLocalDataSource.deleteAll());
      verify(mockLocalDataSource.insertCharacter(any)).called(tRemoteModels.length);
      expect(result, isA<Right<Failure, List<CharacterEntity>>>());
      expect(result.getOrElse(() => []), equals(tEntities));    });

    test('should return local data when online but remote throws error',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllCharacters(tPage)).thenThrow(Exception());
      when(mockLocalDataSource.getAllCharacters())
          .thenAnswer((_) async => tCacheModels);

      final result = await repository.getAllCharacters(tPage);

      verify(mockRemoteDataSource.getAllCharacters(tPage));
      verify(mockLocalDataSource.getAllCharacters());
      expect(result, isA<Right<Failure, List<CharacterEntity>>>());
      expect(result.getOrElse(() => []), equals(tEntities));
        });

    test('should return local data when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getAllCharacters())
          .thenAnswer((_) async => tCacheModels);

      final result = await repository.getAllCharacters(tPage);

      verifyNever(mockRemoteDataSource.getAllCharacters(tPage));
      verify(mockLocalDataSource.getAllCharacters());
      expect(result, isA<Right<Failure, List<CharacterEntity>>>());
      expect(result.getOrElse(() => []), equals(tEntities));      });

    test('should return ServerFailure when online and local is empty',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllCharacters(tPage)).thenThrow(Exception());
      when(mockLocalDataSource.getAllCharacters()).thenAnswer((_) async => []);

      final result = await repository.getAllCharacters(tPage);

      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return ConnectionFailure when offline and local is empty',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getAllCharacters()).thenAnswer((_) async => []);

      final result = await repository.getAllCharacters(tPage);

      expect(result, equals(Left(ConnectionFailure(AppStrings.noInternet))));
    });
  });
}
