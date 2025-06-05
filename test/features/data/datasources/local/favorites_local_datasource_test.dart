import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_morty/features/data/datasources/local/entity/favorites_local_entity.dart';
import 'package:rick_morty/features/data/datasources/local/local_datasources/favorites_local_datasource.dart';

import '../../../helper/test_helper.mocks.dart';

void main() {
  late FaFavoritesLocalDatasourceImpl datasource;
  late MockFavoritesDao mockDao;

  setUp(() {
    mockDao = MockFavoritesDao();
    datasource = FaFavoritesLocalDatasourceImpl(mockDao);
  });

  final tCharacter = FavoritesLocalEntity(
    id: 1,
    name: 'Rick Sanchez',
    species: 'Human',
    type: '',
    gender: 'Male',
    location: 'Earth (C-137)',
    image: 'https://image.url',
    isFavorite: true,
  );

  test('should call insertFavorite', () async {
    when(mockDao.insertFavorite(tCharacter))
        .thenAnswer((_) async => Future.value());

    await datasource.insertFavorite(tCharacter);
    verify(mockDao.insertFavorite(tCharacter)).called(1);
  });

  test('should return list of characters from DAO which are liked', () async {
    final tList = [tCharacter];
    when(mockDao.getFavorites()).thenAnswer((_) async => tList);

    final result = await datasource.getFavorites();

    expect(result, equals(tList));
    verify(mockDao.getFavorites()).called(1);
  });

  group('delete favorite items', () {
    test('should call deleteFavorites on DAO', () async {
      when(mockDao.deleteFavorites()).thenAnswer((_) async => Future.value());

      await datasource.deleteFavorites();

      verify(mockDao.deleteFavorites()).called(1);
    });

    test('should call deleteFavoriteOne', () async {
      when(mockDao.deleteFavoriteOne(argThat(isA<int>())))
          .thenAnswer((_) async => Future.value());

      await datasource.deleteFavoriteOne(1);
      verify(mockDao.deleteFavoriteOne(argThat(isA<int>()))).called(1);
    });
  });
}
