import 'package:rick_morty/core/constants/strings/endpoints.dart';
import 'package:rick_morty/core/network/api_provider.dart';
import 'package:rick_morty/features/data/models/character_model.dart';

abstract class CharactersRemoteDatasource {
  Future<List<CharacterModel>> getAllCharacters(int page);
}

class CharactersRemoteDatasourceImpl implements CharactersRemoteDatasource {
  final ApiProvider apiProvider;

  CharactersRemoteDatasourceImpl({required this.apiProvider});

  @override
  Future<List<CharacterModel>> getAllCharacters(int page) async {
    final response = await apiProvider.get(
      endPoint: ApiEndpoints.character,
      query: {
        'page': page,
      },
    );

    final responseBody = response.data['results'] as List;

    final result = responseBody.map((e) => CharacterModel.fromMap(e)).toList();

    return result;
  }
}
