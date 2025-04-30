part of 'characters_bloc.dart';

sealed class CharactersState {}

final class CharactersLoading extends CharactersState {}

final class CharactersLoaded extends CharactersState {
  final List<CharacterEntity> data;

  CharactersLoaded(this.data);
}

final class CharactersError extends CharactersState {}

final class CharactersConnectionError extends CharactersState {}
