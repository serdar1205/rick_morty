import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_morty/features/domain/usecases/favorites/delete_favorite_one_usecase.dart';
import '../../../helper/test_helper.mocks.dart';

void main() {
  late MockFavoritesRepository repository;
  late DeleteFavoriteOneUseCase useCase;

  setUp(() {
    repository = MockFavoritesRepository();
    useCase = DeleteFavoriteOneUseCase(repository: repository);
  });

  test('should return true when deleteFavoriteOne succeeds', () async {
    when(repository.deleteFavoriteOne(argThat(isA<int>())))
        .thenAnswer((_) async => Right(true));

    final result = await useCase.execute(1);

    expect(result, Right(true));
    verify(repository.deleteFavoriteOne(1)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
