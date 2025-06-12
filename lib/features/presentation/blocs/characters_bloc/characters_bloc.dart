import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/core/network/network.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';
import 'package:rick_morty/features/domain/usecases/characters/get_all_characters_usecase.dart';
import 'package:rick_morty/features/domain/usecases/favorites/add_favorites_usecase.dart';
import 'package:rick_morty/features/domain/usecases/favorites/delete_favorite_one_usecase.dart';
import 'package:rick_morty/features/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:rick_morty/locator.dart';

part 'characters_event.dart';

part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc(
    this._networkInfo,
    this._allCharactersUseCase,
    this._addFavoritesUseCase,
    this._deleteFavoriteOneUseCase,
  ) : super(CharactersLoading()) {
    on<GetCharacters>(_onGetAllCharacters);
    on<ToggleFavoriteStatus>(_onToggleFavoriteStatus);
    on<DeleteAllCharacterFromFavorites>(_onDeleteAllFromFavorites);
  }

  final NetworkInfo _networkInfo;

  final GetAllCharactersUseCase _allCharactersUseCase;

  final AddFavoritesUseCase _addFavoritesUseCase;

  final DeleteFavoriteOneUseCase _deleteFavoriteOneUseCase;
//todo bloc optimize
  bool canLoad = true;
  List<CharacterEntity> _allCharacters = [];

  final allFavoriteIds = locator<FavoritesBloc>().allFavoriteIds;

  Future<void> _onGetAllCharacters(
      GetCharacters event, Emitter<CharactersState> emit) async {
    final bool hasInternet = await _networkInfo.isConnected;
    if (!hasInternet && _allCharacters.isNotEmpty) {
      canLoad = false;
      return;
    } else if (hasInternet) {
      canLoad = true;
    }

    final allResult = await _allCharactersUseCase.execute(event.page);

    allResult.fold((failure) {
      if (failure is ConnectionFailure) {
        emit(CharactersConnectionError());
      } else {
        emit(CharactersError());
      }
    }, (newData) {
      canLoad = newData.isNotEmpty;

      if (event.page == 1) {
        _allCharacters = newData;
      } else {
        _allCharacters.addAll(newData);
      }

      _allCharacters = _allCharacters.map((c) {
        return c.copyWith(isFavorite: allFavoriteIds.contains(c.id));
      }).toList();

      emit(CharactersLoaded(List.from(_allCharacters)));
    });
  }

  Future<void> _onToggleFavoriteStatus(
      ToggleFavoriteStatus event, Emitter<CharactersState> emit) async {
    CharacterEntity? updatedCharacter;
    bool wasFavorite = false;

    _allCharacters = _allCharacters.map((character) {
      if (character.id == event.characterId) {
        wasFavorite = allFavoriteIds.contains(event.characterId);

        updatedCharacter = character.copyWith(isFavorite: !wasFavorite);
        return updatedCharacter!;
      }
      return character;
    }).toList();

    if (updatedCharacter != null) {
      if (wasFavorite) {
        await _deleteFavoriteOneUseCase.execute(updatedCharacter!.id);
      } else {
        await _addFavoritesUseCase.execute(updatedCharacter!);
      }
    }

    emit(CharactersLoaded(_allCharacters));
  }

  Future<void> _onDeleteAllFromFavorites(DeleteAllCharacterFromFavorites event,
      Emitter<CharactersState> emit) async {
    _allCharacters =
        _allCharacters.map((c) => c.copyWith(isFavorite: false)).toList();

    emit(CharactersLoaded(List.from(_allCharacters)));
  }
}
