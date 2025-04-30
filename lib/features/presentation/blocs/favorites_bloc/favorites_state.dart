part of 'favorites_bloc.dart';

sealed class FavoritesState {}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesLoaded extends FavoritesState {
  final List<CharacterEntity> data;

  FavoritesLoaded(this.data);
}

final class FavoritesEmpty extends FavoritesState {}
final class FavoritesError extends FavoritesState {}
