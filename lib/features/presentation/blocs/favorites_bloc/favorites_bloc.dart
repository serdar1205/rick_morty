import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/core/usecase/usecase.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';
import 'package:rick_morty/features/domain/enums/sort_enums.dart';
import 'package:rick_morty/features/domain/usecases/favorites/add_favorites_usecase.dart';
import 'package:rick_morty/features/domain/usecases/favorites/delete_favorite_one_usecase.dart';
import 'package:rick_morty/features/domain/usecases/favorites/delete_favorites_usecase.dart';
import 'package:rick_morty/features/domain/usecases/favorites/filter_favorites_usecase.dart';
import 'package:rick_morty/features/domain/usecases/favorites/get_favorites_usecase.dart';

part 'favorites_event.dart';

part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc(
      this._getFavoritesUseCase,
      this._deleteFavoritesUseCase,
      this._deleteFavoriteOneUseCase,
      this._addFavoritesUseCase,
      this._filterFavoritesUseCase)
      : super(FavoritesLoading()) {
    on<GetFavorites>(_onGetFavorites);
    on<DeleteFavorites>(_onDeleteFavorites);
    on<ToggleFavorites>(_onToggleFavorites);
    on<FilterFavorites>(_onFilterFavorites);
  }

  final GetFavoritesUseCase _getFavoritesUseCase;
  final DeleteFavoritesUseCase _deleteFavoritesUseCase;

  final DeleteFavoriteOneUseCase _deleteFavoriteOneUseCase;
  final AddFavoritesUseCase _addFavoritesUseCase;

  final FilterFavoritesUseCase _filterFavoritesUseCase;

  final List<int> allFavoriteIds = [];

  CharacterGenders selectedGender = CharacterGenders.all;

  CharacterLocations selectedLocation = CharacterLocations.all;

  Future<void> _onFilterFavorites(
      FilterFavorites event, Emitter<FavoritesState> emit) async {
    selectedGender = event.params.genderFilter;
    selectedLocation = event.params.locationFilter;

    emit(FavoritesLoading());

    final result = await _filterFavoritesUseCase.execute(
      FilterCharacterParams(
        genderFilter: selectedGender,
        locationFilter: selectedLocation,
      ),
    );

    result.fold(
      (failure) => emit(FavoritesError()),
      (filteredList) {
        if (filteredList.isEmpty) {
          emit(FavoritesEmpty());
        } else {
          emit(FavoritesLoaded(filteredList));
        }
      },
    );
  }

  Future<void> _onGetFavorites(
      GetFavorites event, Emitter<FavoritesState> emit) async {
    allFavoriteIds.clear();
    final result = await _getFavoritesUseCase.execute(NoParams());

    result.fold((failure) {
      emit(FavoritesError());
    }, (success) {
      if (success.isEmpty) {
        emit(FavoritesEmpty());
      } else {
        emit(FavoritesLoaded(success));

        for (var item in success) {
          allFavoriteIds.add(item.id);
        }
      }
    });
  }

  Future<void> _onDeleteFavorites(
      DeleteFavorites event, Emitter<FavoritesState> emit) async {
    final result = await _deleteFavoritesUseCase.execute(NoParams());

    result.fold((failure) {
      emit(FavoritesError());
    }, (success) {
      if (success) {
        emit(FavoritesEmpty());
      }
    });
  }

  Future<void> _onToggleFavorites(
      ToggleFavorites event, Emitter<FavoritesState> emit) async {
    final isFavorite = allFavoriteIds.contains(event.character.id);

    if (isFavorite) {
      final result =
          await _deleteFavoriteOneUseCase.execute(event.character.id);
      result.fold(
        (failure) => emit(FavoritesError()),
        (success) {
          if (success) add(GetFavorites());
        },
      );
    } else {
      final result = await _addFavoritesUseCase.execute(event.character);
      result.fold(
        (failure) => emit(FavoritesError()),
        (success) {
          if (success) add(GetFavorites());
        },
      );
    }
  }
}
