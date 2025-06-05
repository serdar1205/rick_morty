import 'package:dartz/dartz.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/core/usecase/usecase.dart';
import 'package:rick_morty/features/domain/reposotories/favorites_repository.dart';

class DeleteFavoritesUseCase extends BaseUseCase<NoParams, bool> {
  final FavoritesRepository repository;

  DeleteFavoritesUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> execute(input) async {
    return await repository.deleteFavorites();
  }
}