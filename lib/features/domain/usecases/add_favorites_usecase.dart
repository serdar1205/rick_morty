import 'package:dartz/dartz.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/core/usecase/usecase.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';
import 'package:rick_morty/features/domain/reposotories/character_repository.dart';

class AddFavoritesUseCase extends BaseUseCase<CharacterEntity, bool> {
  final CharacterRepository repository;

  AddFavoritesUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> execute(input) async {
    return await repository.addToFavorite(input);
  }
}
