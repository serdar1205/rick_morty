import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_morty/features/data/models/character_model.dart';
import 'package:rick_morty/features/domain/enums/sort_enums.dart';
import 'package:rick_morty/features/domain/usecases/favorites/filter_favorites_usecase.dart';
import '../../../../fixtures/json_reader.dart';
import '../../../helper/test_helper.mocks.dart';

void main() {
  late MockFavoritesRepository repository;
  late FilterFavoritesUseCase useCase;

  final jsonName = 'character';
  final testJson = readJson(jsonName);
  final responseBody = json.decode(testJson)['results'] as List;
  final dataList =
  responseBody.map((e) => CharacterModel.fromMap(e).toEntity()).toList();
  final testParams = FilterCharacterParams(
    genderFilter: CharacterGenders.male,
    locationFilter: CharacterLocations.earth,
  );

  setUp(() {
    repository = MockFavoritesRepository();
    useCase = FilterFavoritesUseCase(repository: repository);
  });

  test("should return List<CharacterEntity> when getFavorites succeeds",
          () async {
        when(repository.filterFavorites(testParams))
            .thenAnswer((_) async => Right(dataList));

        final result = await useCase.execute(testParams);

        expect(result, Right(dataList));
        verify(repository.filterFavorites(testParams)).called(1);
        verifyNoMoreInteractions(repository);
      });
}