import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/core/usecase/usecase.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';
import 'package:rick_morty/features/domain/usecases/add_favorites_usecase.dart';
import 'package:rick_morty/features/domain/usecases/delete_favorite_one_usecase.dart';
import 'package:rick_morty/features/domain/usecases/delete_favorites_usecase.dart';
import 'package:rick_morty/features/domain/usecases/get_favorites_usecase.dart';
import 'package:rick_morty/features/presentation/blocs/characters_bloc/characters_bloc.dart';
import 'package:rick_morty/features/presentation/widgets/sort_characters_widget.dart';
import 'package:rick_morty/locator.dart';

part 'favorites_event.dart';

part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesLoading()) {
    on<GetFavorites>(_onGetFavorites);
    on<DeleteFavorites>(_onDeleteFavorites);
    on<DeleteFavoritesOne>(_onDeleteFavoriteOne);
    on<AddToFavorites>(_onAddToFavorites);
    on<SortFavorites>(_onSortFavorites);
  }

  final GetFavoritesUseCase _getFavoritesUseCase =
      GetFavoritesUseCase(repository: locator());
  final DeleteFavoritesUseCase _deleteFavoritesUseCase =
      DeleteFavoritesUseCase(repository: locator());
  final DeleteFavoriteOneUseCase _deleteFavoriteOneUseCase =
      DeleteFavoriteOneUseCase(repository: locator());
  final AddFavoritesUseCase _addFavoritesUseCase =
      AddFavoritesUseCase(repository: locator());

  final characterBloc = locator<CharactersBloc>();

  final List<CharacterEntity> favorites = List.empty(growable: true);
  List<CharacterEntity> sortedFavorites = [];

  CharacterGenders selectedGender = CharacterGenders.all;

  CharacterLocations selectedLocation = CharacterLocations.all;

  String? gender;
  String? location;
  String? other;

  final male = 'Male';
  final female = 'Female';
  final earth = 'Earth';
  final planet = 'other';

  void selectGender(CharacterGenders genders) {
    switch (genders) {
      case CharacterGenders.all:
        gender = null;
        break;
      case CharacterGenders.male:
        gender = male;
        break;
      case CharacterGenders.female:
        gender = female;
        break;
    }

    selectedGender = genders;
    applyFilters();
  }

  void selectLocation(CharacterLocations locations) {
    switch (locations) {
      case CharacterLocations.all:
        location = null;
        other = null;
        break;
      case CharacterLocations.earth:
        location = earth;
        other = null;
        break;
      case CharacterLocations.others:
        location = null;
        other = planet;
        break;
    }

    selectedLocation = locations;
    applyFilters();
  }

  void applyFilters() {
    sortedFavorites = favorites.where((e) {
      final matchesGender = gender == null || e.gender == gender;
      final matchesLocation = location == null
          ? other == null || !e.location.contains(earth)
          : e.location.contains(location!);

      return matchesGender && matchesLocation;
    }).toList();
  }

  Future<void> _onSortFavorites(
      SortFavorites event, Emitter<FavoritesState> emit) async {
    emit(FavoritesLoaded(sortedFavorites.toList()));
  }

  Future<void> _onGetFavorites(
      GetFavorites event, Emitter<FavoritesState> emit) async {
    final result = await _getFavoritesUseCase.execute(NoParams());

    result.fold((failure) {
      emit(FavoritesError());
    }, (success) {
      if (success.isEmpty) {
        emit(FavoritesEmpty());
      } else {
        favorites.clear();
        favorites.addAll(success);
        selectedGender = CharacterGenders.all;
        selectedLocation = CharacterLocations.all;
        location = earth;
        other = null;
        gender = null;

        emit(FavoritesLoaded(success));
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
        favorites.clear();
        selectedGender = CharacterGenders.all;
        selectedLocation = CharacterLocations.all;
        location = earth;
        other = null;
        gender = null;

        characterBloc.add(DeleteAllCharacterFromFavorites());
      }
    });
  }

  Future<void> _onDeleteFavoriteOne(
      DeleteFavoritesOne event, Emitter<FavoritesState> emit) async {
    final result = await _deleteFavoriteOneUseCase.execute(event.id);

    result.fold((failure) {
      emit(FavoritesError());
    }, (success) {
      if (success) {
        favorites.removeWhere((item) => item.id == event.id);

        if (favorites.isEmpty) {
          emit(FavoritesEmpty());
        } else {
          emit(FavoritesLoaded(favorites.toList()));
        }

        characterBloc.add(DeleteCharacterFromFavorites(event.id));
      }
    });
  }

  Future<void> _onAddToFavorites(
      AddToFavorites event, Emitter<FavoritesState> emit) async {
    final result = await _addFavoritesUseCase.execute(event.character);

    result.fold((failure) {
      emit(FavoritesError());
    }, (success) {
      if (success) {
        favorites.add(event.character);
        emit(FavoritesLoaded(favorites.toList()));

        characterBloc.add(AddCharacterToFavorite(event.character.id));
      }
    });
  }
}
