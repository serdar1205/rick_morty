import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_morty/core/usecase/usecase.dart';
import 'package:rick_morty/features/data/models/character_model.dart';
import 'package:rick_morty/features/domain/usecases/favorites/get_favorites_usecase.dart';
import '../../../../fixtures/json_reader.dart';
import '../../../helper/test_helper.mocks.dart';

void main() {
  late MockFavoritesRepository repository;
  late GetFavoritesUseCase useCase;

  final jsonName = 'character';
  final testJson = readJson(jsonName);
  final responseBody = json.decode(testJson)['results'] as List;
  final dataList =
  responseBody.map((e) => CharacterModel.fromMap(e).toEntity()).toList();

  setUp(() {
    repository = MockFavoritesRepository();
    useCase = GetFavoritesUseCase(repository: repository);
  });

  test("should return List<CharacterEntity> when getFavorites succeeds",
          () async {
        when(repository.getFavorites())
            .thenAnswer((_) async => Right(dataList));

        final result = await useCase.execute(NoParams());

        expect(result, Right(dataList));
        verify(repository.getFavorites()).called(1);
        verifyNoMoreInteractions(repository);
      });
}