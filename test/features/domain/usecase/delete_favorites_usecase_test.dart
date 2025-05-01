import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_morty/core/usecase/usecase.dart';
import 'package:rick_morty/features/domain/usecases/delete_favorites_usecase.dart';

import '../../helper/test_helper.mocks.dart';

void main(){

  late MockCharacterRepository repository;
  late DeleteFavoritesUseCase useCase;

  setUp((){
    repository = MockCharacterRepository();
    useCase = DeleteFavoritesUseCase(repository: repository);
  });

  test('should return true when deleteFavorites succeeds', ()async{
    when(repository.deleteFavorites()).thenAnswer((_)async => Right(true));

    final result = await useCase.execute(NoParams());

    expect(result, Right(true));
    verify(repository.deleteFavorites()).called(1);
    verifyNoMoreInteractions(repository);  });


}