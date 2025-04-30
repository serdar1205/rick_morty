import 'package:dartz/dartz.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/core/usecase/usecase.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';
import 'package:rick_morty/features/domain/reposotories/character_repository.dart';

class GetAllCharactersUseCase extends BaseUseCase<int, List<CharacterEntity>> {
  final CharacterRepository repository;

  GetAllCharactersUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CharacterEntity>>> execute(input) async {
    return await repository.getAllCharacters(input);
  }
}