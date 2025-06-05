import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_morty/features/data/datasources/local/entity/character_local_entity.dart';
import 'package:rick_morty/features/data/datasources/local/local_datasources/character_local_datasource.dart';

import '../../../helper/test_helper.mocks.dart';

void main() {
  late CharactersLocalDataSourceImpl dataSource;
  late MockCharactersDao mockDao;

  setUp(() {
    mockDao = MockCharactersDao();
    dataSource = CharactersLocalDataSourceImpl(mockDao);
  });

  final tCharacter = CharacterLocalEntity(
    id: 1,
    name: 'Rick Sanchez',
    species: 'Human',
    type: '',
    gender: 'Male',
    location: 'Earth (C-137)',
    image: 'https://image.url',
    isFavorite: true,
  );

  test('should call insertCharacter on DAO with correct data', () async {
    when(mockDao.insertCharacter(tCharacter))
        .thenAnswer((_) async => Future.value());

    await dataSource.insertCharacter(tCharacter);

    verify(mockDao.insertCharacter(tCharacter)).called(1);
  });

  test('should return list of characters from DAO', () async {
    final tList = [tCharacter];
    when(mockDao.getAllCharacters()).thenAnswer((_) async => tList);

    final result = await dataSource.getAllCharacters();

    expect(result, equals(tList));
    verify(mockDao.getAllCharacters()).called(1);
  });

  test('should call deleteAll on DAO', () async {
    when(mockDao.deleteAll()).thenAnswer((_) async => Future.value());

    await dataSource.deleteAll();

    verify(mockDao.deleteAll()).called(1);
  });
}
