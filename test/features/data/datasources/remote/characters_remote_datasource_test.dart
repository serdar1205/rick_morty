import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_morty/core/constants/strings/endpoints.dart';
import 'package:rick_morty/features/data/datasources/remote/characters_remote_datasource.dart';
import 'package:rick_morty/features/data/models/character_model.dart';

import '../../../../fixtures/json_reader.dart';
import '../../../helper/test_helper.mocks.dart';

void main() {
  late MockApiProvider apiProvider;
  late CharactersRemoteDatasourceImpl datasource;

  final String jsonName = 'character';
  final testJson = readJson(jsonName);
  final jsonList = json.decode(testJson)['results'] as List;

  setUp(() {
    apiProvider = MockApiProvider();
    datasource = CharactersRemoteDatasourceImpl(apiProvider: apiProvider);
  });

  group('CharactersRemoteDatasourceImpl getAllCharacters()', () {
    test('GET request should return list of CharacterModel on success',
        () async {
      const page = 1;
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        data: {
          'results': jsonList,
        },
        statusCode: 200,
      );

      when(apiProvider.get(
        endPoint: ApiEndpoints.character,
        query: {
          'page': page,
        },
      )).thenAnswer((_) async => response);

      final result = await datasource.getAllCharacters(page);

      expect(result, isA<List<CharacterModel>>());
      expect(result.first.id, 1);
      expect(result.first.name, 'Rick Sanchez');
      verify(apiProvider.get(
        endPoint: ApiEndpoints.character,
        query: {
          'page': page,
        },
      )).called(1);
      verifyNoMoreInteractions(apiProvider);
    });

    test('GET request should throw an exception on 500 error', () async {
      const page = 1;

      when(apiProvider.get(
        endPoint: ApiEndpoints.character,
        query: {
          'page': page,
        },
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 500,
            data: 'Internal Server Error',
            requestOptions: RequestOptions(path: ''),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
            () async => await datasource.getAllCharacters(page),
        throwsA(isA<DioException>()),
      );

      verify(apiProvider.get(
        endPoint: ApiEndpoints.character,
        query: {
          'page': page,
        },
      )).called(1);
      verifyNoMoreInteractions(apiProvider);
    });


  });
}
