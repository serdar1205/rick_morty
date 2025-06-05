import 'package:get_it/get_it.dart';
import 'package:rick_morty/features/data/datasources/db/app_database.dart';
import 'package:rick_morty/features/data/datasources/remote/characters_remote_datasource.dart';
import 'core/config/theme_cubit/theme_cubit.dart';
import 'core/constants/strings/app_db_names.dart';
import 'core/network/api_provider.dart';
import 'core/network/api_provider_impl.dart';
import 'core/network/network.dart';
import 'features/data/datasources/local/local_datasources/character_local_datasource.dart';
import 'features/data/datasources/local/local_datasources/favorites_local_datasource.dart';
import 'features/data/reposotories/characters_repository_impl.dart';
import 'features/data/reposotories/favorites_repository_impl.dart';
import 'features/domain/reposotories/character_repository.dart';
import 'features/domain/reposotories/favorites_repository.dart';
import 'features/domain/usecases/characters/get_all_characters_usecase.dart';
import 'features/domain/usecases/favorites/add_favorites_usecase.dart';
import 'features/domain/usecases/favorites/delete_favorite_one_usecase.dart';
import 'features/domain/usecases/favorites/delete_favorites_usecase.dart';
import 'features/domain/usecases/favorites/filter_favorites_usecase.dart';
import 'features/domain/usecases/favorites/get_favorites_usecase.dart';
import 'features/presentation/blocs/characters_bloc/characters_bloc.dart';
import 'features/presentation/blocs/favorites_bloc/favorites_bloc.dart';

final locator = GetIt.instance;

Future<void> initLocator() async {
  locator.registerLazySingleton(() => ThemeCubit());

  final database = await $FloorAppDataBase
      .databaseBuilder(AppDbNames.charactersDbName)
      .build();

  locator.registerSingleton<AppDataBase>(database);

  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  locator.registerFactory<ApiProvider>(() => ApiProviderImpl());


  locator.registerLazySingleton<CharactersRemoteDatasource>(
      () => CharactersRemoteDatasourceImpl(apiProvider: locator()));

  locator.registerLazySingleton<CharactersLocalDataSource>(() =>
      CharactersLocalDataSourceImpl(locator<AppDataBase>().charactersDao));

  locator.registerLazySingleton<FavoritesLocalDatasource>(() =>
      FaFavoritesLocalDatasourceImpl(locator<AppDataBase>().favoritesDao));

  locator.registerLazySingleton<CharacterRepository>(() =>
      CharactersRepositoryImpl(
          remoteDataSource: locator(),
          localDataSource: locator(),
          networkInfo: locator()));

  locator.registerLazySingleton<FavoritesRepository>(() =>
      FavoritesRepositoryImpl(
          localDataSource: locator(), networkInfo: locator()));

  locator.registerLazySingleton(
      () => GetAllCharactersUseCase(repository: locator()));
  locator
      .registerLazySingleton(() => GetFavoritesUseCase(repository: locator()));

  locator.registerLazySingleton(
      () => DeleteFavoritesUseCase(repository: locator()));
  locator.registerLazySingleton(
      () => DeleteFavoriteOneUseCase(repository: locator()));
  locator
      .registerLazySingleton(() => AddFavoritesUseCase(repository: locator()));
  locator.registerLazySingleton(
      () => FilterFavoritesUseCase(repository: locator()));

  locator.registerLazySingleton<CharactersBloc>(() => CharactersBloc(
        locator(),
        locator(),
        locator(),
        locator(),
      ));
  locator.registerLazySingleton<FavoritesBloc>(() => FavoritesBloc(
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
      ));
}
