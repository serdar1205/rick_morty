part of 'favorites_bloc.dart';

sealed class FavoritesEvent {}

class GetFavorites extends FavoritesEvent {}

class FilterFavorites extends FavoritesEvent {
  final FilterCharacterParams params;

  FilterFavorites(this.params);
}
class ToggleFavorites extends FavoritesEvent {
  final CharacterEntity character;

  ToggleFavorites(this.character);
}
class DeleteFavorites extends FavoritesEvent {}


