import 'package:equatable/equatable.dart';

class CharacterEntity extends Equatable {
  final int id;
  final String name;
  final String species;
  final String type;
  final String gender;
  final String location;
  final String image;
  bool isFavorite;

  CharacterEntity({
    required this.id,
    required this.name,
    required this.species,
    required this.type,
    required this.gender,
    required this.location,
    required this.image,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        species,
        type,
        gender,
        location,
        image,
      ];
}
