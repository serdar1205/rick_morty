import 'package:floor/floor.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';

@entity
class CharacterLocalEntity {
  @primaryKey
  final int id;
  final String name;
  final String species;
  final String type;
  final String gender;
  final String location;
  final String image;
  final bool isFavorite;

  CharacterLocalEntity({
    required this.id,
    required this.name,
    required this.species,
    required this.type,
    required this.gender,
    required this.location,
    required this.image,
    required this.isFavorite,
  });

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
}
