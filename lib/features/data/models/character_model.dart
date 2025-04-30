import 'package:rick_morty/features/data/datasources/local/entity/character_local_entity.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';

class CharacterModel {
  final int id;
  final String name;
  final String species;
  final String type;
  final String gender;
  final String location;
  final String image;
  final bool isFavorite;

  CharacterModel({
    required this.id,
    required this.name,
    required this.species,
    required this.type,
    required this.gender,
    required this.location,
    required this.image,
    required this.isFavorite,
  });

  factory CharacterModel.fromMap(Map<String, dynamic> json) => CharacterModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        species: json["species"] ?? '',
        type: json["type"] ?? '',
        gender: json["gender"] ?? '',
        location: json["location"] != null ? json["location"]['name'] : '',
        image: json["image"] ?? '',
        isFavorite: false,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "species": species,
        "type": type,
        "gender": gender,
        "location": location,
        "image": image,
        "isFavorite": isFavorite,
      };

  CharacterEntity toEntity() {
    return CharacterEntity(
      id: id,
      name: name,
      species: species,
      type: type,
      gender: gender,
      location: location,
      image: image,
      isFavorite: isFavorite,
    );
  }

  CharacterLocalEntity toCacheEntity() {
    return CharacterLocalEntity(
      id: id,
      name: name,
      species: species,
      type: type,
      gender: gender,
      location: location,
      image: image,
      isFavorite: isFavorite,
    );
  }
}
