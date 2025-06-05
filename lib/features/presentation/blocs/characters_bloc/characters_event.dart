part of 'characters_bloc.dart';

sealed class CharactersEvent {}

class GetCharacters extends CharactersEvent {
  final int page;

  GetCharacters(this.page);
}

class ToggleFavoriteStatus extends CharactersEvent {
  final int characterId;
  ToggleFavoriteStatus(this.characterId);
}

class DeleteAllCharacterFromFavorites extends CharactersEvent {
  DeleteAllCharacterFromFavorites();
}
