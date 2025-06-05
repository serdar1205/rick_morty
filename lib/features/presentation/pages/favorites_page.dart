import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/core/constants/strings/app_strings.dart';
import 'package:rick_morty/features/domain/enums/sort_enums.dart';
import 'package:rick_morty/features/domain/usecases/favorites/filter_favorites_usecase.dart';
import 'package:rick_morty/features/presentation/blocs/characters_bloc/characters_bloc.dart';
import 'package:rick_morty/features/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:rick_morty/features/presentation/widgets/sort_characters_widget.dart';
import 'package:rick_morty/locator.dart';
import '../widgets/item_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final favoriteBloc = locator<FavoritesBloc>();
  final characterBloc = locator<CharactersBloc>();

  @override
  void initState() {
    super.initState();
    favoriteBloc.add(GetFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.favorites),
        actions: [
          IconButton(
              onPressed: () async{
                favoriteBloc.add(DeleteFavorites());
                await Future.delayed(Duration(milliseconds: 300));
                characterBloc.add(DeleteAllCharacterFromFavorites());
              },
              icon: Icon(Icons.delete)),
          IconButton(onPressed: _openSort, icon: Icon(Icons.sort)),
        ],
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          return switch (state) {
            FavoritesLoading() => Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            FavoritesLoaded(:final data) => GridView.builder(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 30),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 260,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];

                  return ItemCard(
                    item: item,
                    onTap: () {
                      favoriteBloc.add(ToggleFavorites(item));
                      characterBloc.add(ToggleFavoriteStatus(item.id));

                    },
                  );
                },
              ),
            FavoritesEmpty() => Center(
                child: Text(AppStrings.emptyFavorites),
              ),
            FavoritesError() => Center(
                child: Text(AppStrings.error),
              ),
          };
        },
      ),
    );
  }

  void _openSort() {
    final selectedType = ValueNotifier(favoriteBloc.selectedGender);
    final selectedLocation = ValueNotifier(favoriteBloc.selectedLocation);

    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: false,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) => SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SortBooksWidget(
              selectedGender: selectedType,
              selectedLocation: selectedLocation,
              selectGender: (CharacterGenders value) {
                selectedType.value = value;
              },
              selectLocation: (CharacterLocations value) {
                selectedLocation.value = value;
              },
              onResult: () {
                favoriteBloc.add(FilterFavorites(
                  FilterCharacterParams(
                    genderFilter: selectedType.value,
                    locationFilter: selectedLocation.value,
                  ),
                ));
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }
}
