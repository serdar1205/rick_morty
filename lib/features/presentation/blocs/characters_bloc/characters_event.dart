part of 'characters_bloc.dart';

sealed class CharactersEvent {}

class GetCharacters extends CharactersEvent {
  final int page;

  GetCharacters(this.page);
}

class AddCharacterToFavorite extends CharactersEvent {
  final int id;

  AddCharacterToFavorite(this.id);
}

class DeleteCharacterFromFavorites extends CharactersEvent {
  final int id;

  DeleteCharacterFromFavorites(this.id);
}

class DeleteAllCharacterFromFavorites extends CharactersEvent {
  DeleteAllCharacterFromFavorites();
}
