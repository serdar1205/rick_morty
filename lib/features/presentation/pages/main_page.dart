import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/core/config/theme_cubit/theme_cubit.dart';
import 'package:rick_morty/core/constants/strings/app_strings.dart';
import 'package:rick_morty/features/presentation/blocs/characters_bloc/characters_bloc.dart';
import 'package:rick_morty/features/presentation/pages/components/all_characters.dart';
import 'package:rick_morty/features/presentation/widgets/k_footer.dart';
import 'package:rick_morty/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final charactersBloc = locator<CharactersBloc>();

  int _currentPage = 1;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    charactersBloc.add(GetCharacters(_currentPage));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    _currentPage = 1;
    charactersBloc.add(GetCharacters(_currentPage));
    _refreshController.refreshCompleted();
  }

  void _onLoad() async {
    if (charactersBloc.canLoad) {
      _currentPage++;
      charactersBloc.add(GetCharacters(_currentPage));
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.appName),
          actions: [
            IconButton(
              icon: Icon(
                context.watch<ThemeCubit>().state.themeMode == ThemeMode.dark
                    ? Icons.wb_sunny
                    : Icons.nightlight_round,
              ),
              onPressed: () {
                final themeCubit = context.read<ThemeCubit>();
                final currentTheme = themeCubit.state.themeMode;

                if (currentTheme == ThemeMode.light) {
                  themeCubit.updateTheme(ThemeMode.dark);
                } else {
                  themeCubit.updateTheme(ThemeMode.light);
                }
              },
            ),
          ],
        ),
        body: BlocListener<CharactersBloc, CharactersState>(
          listener: (context, state) {
            if (state is CharactersLoaded) {
              _refreshController.refreshCompleted();
              _refreshController.loadComplete();
            } else if (state is CharactersError || state is CharactersConnectionError || !charactersBloc.canLoad) {
              _refreshController.refreshFailed();
              _refreshController.loadFailed();
            }
          },

          child: SmartRefresher(
            controller: _refreshController,
            enablePullUp: charactersBloc.canLoad,
            onLoading: _onLoad,
            onRefresh: _onRefresh,
            footer: KFooter(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AllCharacters(),
            ),
          ),
        ));
  }
}
