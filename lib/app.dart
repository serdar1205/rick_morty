import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/features/presentation/blocs/characters_bloc/characters_bloc.dart';
import 'core/config/routes/app_router.dart';
import 'core/config/theme/app_theme.dart';
import 'core/config/theme_cubit/theme_cubit.dart';
import 'core/constants/strings/app_strings.dart';
import 'features/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'locator.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (context) => locator<ThemeCubit>()),
          BlocProvider<CharactersBloc>(
              create: (context) => locator<CharactersBloc>()),
          BlocProvider<FavoritesBloc>(
              create: (context) => locator<FavoritesBloc>()),
        ],
        child: Builder(builder: (context) {
          final themeState =
              context.select((ThemeCubit cubit) => cubit.state.themeMode);
          return MaterialApp.router(
            title: AppStrings.appName,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            debugShowCheckedModeBanner: false,
            themeMode: themeState,
            routerConfig: goRouter,
          );
        }));
  }
}
