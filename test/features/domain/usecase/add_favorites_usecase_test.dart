import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_morty/features/data/models/character_model.dart';
import 'package:rick_morty/features/domain/usecases/add_favorites_usecase.dart';

import '../../../fixtures/json_reader.dart';
import '../../helper/test_helper.mocks.dart';

void main(){
  late MockCharacterRepository repository;
  late AddFavoritesUseCase useCase;
  final String jsonName = 'character';

  final testJson = readJson(jsonName);
  final responseBody = json.decode(testJson)['results'] as List;
  final dataList = responseBody.map((e)=>CharacterModel.fromMap(e)).toList();
  final testEntity = dataList.first.toEntity();
  
  setUp((){
    repository = MockCharacterRepository();
    useCase = AddFavoritesUseCase(repository: repository);
  });
  
  test('should return true when addToFavorite succeeds', ()async{
    when(repository.addToFavorite(testEntity)).thenAnswer((_) async => Right(true));

    final result = await useCase.execute(testEntity);

    expect(result, Right(true));
    verify(repository.addToFavorite(testEntity)).called(1);
    verifyNoMoreInteractions(repository);

  });

}