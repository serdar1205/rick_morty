import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_morty/features/data/models/character_model.dart';
import 'package:rick_morty/features/domain/usecases/get_all_characters_usecase.dart';
import '../../../fixtures/json_reader.dart';
import '../../helper/test_helper.mocks.dart';

void main() {
  late MockCharacterRepository repository;
  late GetAllCharactersUseCase useCase;

  final jsonName = 'character';
  final testJson = readJson(jsonName);
  final responseBody = json.decode(testJson)['results'] as List;
  final dataList =
      responseBody.map((e) => CharacterModel.fromMap(e).toEntity()).toList();

  setUp(() {
    repository = MockCharacterRepository();
    useCase = GetAllCharactersUseCase(repository: repository);
  });

  test("should return List<CharacterEntity> when getAllCharacters succeeds",
      () async {
    when(repository.getAllCharacters(argThat(isA<int>())))
        .thenAnswer((_) async => Right(dataList));

    final result = await useCase.execute(1);

    expect(result, Right(dataList));
    verify(repository.getAllCharacters(1)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
