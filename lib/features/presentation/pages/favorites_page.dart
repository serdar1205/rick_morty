import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/core/constants/strings/app_strings.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.favorites),
        actions: [
          IconButton(
              onPressed: () {
                favoriteBloc.add(DeleteFavorites());
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
                  mainAxisExtent: 305,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final isFavorite = data[index].isFavorite;

                  return ItemCard(
                    item: data[index],
                    isFavorite: data[index].isFavorite,
                    onTap: () {
                      if (isFavorite) {
                        favoriteBloc.add(DeleteFavoritesOne(data[index].id));
                      } else {
                        favoriteBloc.add(AddToFavorites(data[index]));
                      }
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
    final selectedLanguage = ValueNotifier(favoriteBloc.selectedLocation);

    showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: false,
        backgroundColor: Theme.of(context).cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        builder: (ctx) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SortBooksWidget(
                selectGender: (CharacterGenders value) {
                  favoriteBloc.selectGender(value);
                },
                selectLocation: (CharacterLocations value) {
                  favoriteBloc.selectLocation(value);
                },
                onResult: () {
                  favoriteBloc.add(SortFavorites());
                  Navigator.pop(context);
                },
                selectedGender: selectedType,
                selectedLocation: selectedLanguage,
              ),
            ));
  }
}
