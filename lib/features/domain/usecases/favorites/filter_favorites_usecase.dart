import 'package:dartz/dartz.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/core/usecase/usecase.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';
import 'package:rick_morty/features/domain/enums/sort_enums.dart';
import 'package:rick_morty/features/domain/reposotories/favorites_repository.dart';

class FilterFavoritesUseCase extends BaseUseCase<FilterCharacterParams, List<CharacterEntity>> {
  final FavoritesRepository repository;

  FilterFavoritesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CharacterEntity>>> execute(input) async {
    return await repository.filterFavorites(input);
  }
}

class FilterCharacterParams {
  final CharacterGenders genderFilter;
  final CharacterLocations locationFilter;

  FilterCharacterParams({
    required this.genderFilter,
    required this.locationFilter,
  });
}