part of 'favorites_bloc.dart';

sealed class FavoritesEvent {}

class GetFavorites extends FavoritesEvent {}

class SortFavorites extends FavoritesEvent {}

class AddToFavorites extends FavoritesEvent {
  final CharacterEntity character;

  AddToFavorites(this.character);
}

class DeleteFavorites extends FavoritesEvent {}

class DeleteFavoritesOne extends FavoritesEvent {
  final int id;

  DeleteFavoritesOne(this.id);
}
