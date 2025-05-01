// import 'dart:convert';
// import 'package:rick_morty/features/data/models/character_model.dart';
// import '../../../fixtures/json_reader.dart';
//
// void main() {
//   final jsonName = 'character';
//   final testJson = readJson(jsonName);
//   final responseBody = json.decode(testJson)['results'] as List;
//   final dataList =
//       responseBody.map((e) => CharacterModel.fromMap(e).toEntity()).toList();
//   final data = dataList.first;
//
//   final CharacterModel characterModel = CharacterModel(
//     id: data.id,
//     name: data.name,
//     species: data.species,
//     type: data.type,
//     gender: data.gender,
//     location: data.location,
//     image: data.image,
//     isFavorite: data.isFavorite,
//   );
//
// }
