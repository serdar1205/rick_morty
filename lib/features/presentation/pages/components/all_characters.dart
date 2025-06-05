import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/features/presentation/blocs/characters_bloc/characters_bloc.dart';
import 'package:rick_morty/features/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:rick_morty/features/presentation/widgets/item_card.dart';
import 'package:rick_morty/locator.dart';
import '../../../../core/constants/strings/app_strings.dart';

class AllCharacters extends StatelessWidget {
  AllCharacters({super.key});

  final characterBloc = locator<CharactersBloc>();
  final favoriteBloc = locator<FavoritesBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharactersBloc, CharactersState>(
      builder: (context, state) {
        return switch (state) {
          CharactersLoading() => Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          CharactersLoaded(:final data) => GridView.builder(
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
                  item: data[index],
                  onTap: () {
                    characterBloc.add(ToggleFavoriteStatus(item.id));
                    favoriteBloc.add(ToggleFavorites(item));
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
    );
  }
}
