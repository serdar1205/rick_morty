import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';
import 'package:rick_morty/features/domain/usecases/get_all_characters_usecase.dart';
import 'package:rick_morty/locator.dart';

part 'characters_event.dart';

part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc() : super(CharactersLoading()) {
    on<GetCharacters>(_onGetAllCharacters);
    on<AddCharacterToFavorite>(_onAddCharacterToFavorite);
    on<DeleteCharacterFromFavorites>(_onDeleteCharacterFromFavorites);
    on<DeleteAllCharacterFromFavorites>(_onDeleteAllCharacterFromFavorites);
  }

  final GetAllCharactersUseCase _useCase =
      GetAllCharactersUseCase(repository: locator());
  bool canLoad = true;
  List<CharacterEntity> _allCharacters = [];

  Future<void> _onGetAllCharacters(
      GetCharacters event, Emitter<CharactersState> emit) async {
    final result = await _useCase.execute(event.page);

    result.fold((failure) {
      if (failure is ConnectionFailure) {
        emit(CharactersConnectionError());
      } else {
        emit(CharactersError());
      }
    }, (success) {
      canLoad = success.isNotEmpty;
      if (event.page == 1) {
        _allCharacters = success;
      } else {
        _allCharacters.addAll(success);
      }

      emit(CharactersLoaded(_allCharacters));
    });
  }

  Future<void> _onAddCharacterToFavorite(
      AddCharacterToFavorite event, Emitter<CharactersState> emit) async {
    for (var item in _allCharacters.where((e) => e.id == event.id)) {
      item.isFavorite = true;
    }

    emit(CharactersLoaded(_allCharacters));
  }

  Future<void> _onDeleteCharacterFromFavorites(
      DeleteCharacterFromFavorites event, Emitter<CharactersState> emit) async {
    for (var item in _allCharacters.where((e) => e.id == event.id)) {
      item.isFavorite = false;
    }

    emit(CharactersLoaded(_allCharacters));
  }

  Future<void> _onDeleteAllCharacterFromFavorites(
      DeleteAllCharacterFromFavorites event,
      Emitter<CharactersState> emit) async {
    for (var item in _allCharacters.where((e) => e.isFavorite)) {
      item.isFavorite = false;
    }

    emit(CharactersLoaded(_allCharacters));
  }
}
