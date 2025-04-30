import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/core/network/internet_bloc/internet_bloc.dart';
import 'package:rick_morty/features/presentation/blocs/characters_bloc/characters_bloc.dart';
import 'package:rick_morty/features/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:rick_morty/features/presentation/widgets/item_card.dart';
import 'package:rick_morty/locator.dart';
import '../../../../core/constants/strings/app_strings.dart';

class AllCharacters extends StatelessWidget {
  AllCharacters({super.key});

  final favoriteBloc = locator<FavoritesBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetBloc, InternetState>(
      listener: (context, internetState) {
        final characterState = context.read<CharactersBloc>().state;

        if (internetState is InternetConnected) {
          locator<CharactersBloc>().add(GetCharacters(1));
        } else {
          if (characterState is! CharactersLoaded) {
            locator<CharactersBloc>().add(GetCharacters(1));
          }
        }
      },
      child: BlocBuilder<CharactersBloc, CharactersState>(
        builder: (context, state) {
          return switch (state) {
            CharactersLoading() => Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            CharactersLoaded(:final data) => GridView.builder(
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
            CharactersError() => Center(
                child: Text(AppStrings.error),
              ),
            CharactersConnectionError() => Center(
                child: Text(AppStrings.noInternet),
              ),
          };
        },
      ),
    );
  }
}
