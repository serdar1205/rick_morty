import 'package:get_it/get_it.dart';
import 'package:rick_morty/features/data/datasources/db/app_database.dart';
import 'package:rick_morty/features/data/datasources/remote/characters_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/theme_cubit/theme_cubit.dart';
import 'core/network/api_provider.dart';
import 'core/network/api_provider_impl.dart';
import 'core/network/internet_bloc/internet_bloc.dart';
import 'core/network/network.dart';
import 'features/data/reposotories/characters_repository_impl.dart';
import 'features/domain/reposotories/character_repository.dart';
import 'features/presentation/blocs/characters_bloc/characters_bloc.dart';
import 'features/presentation/blocs/favorites_bloc/favorites_bloc.dart';

final locator = GetIt.instance;
String documentsDir = '';

Future<void> initLocator() async {
  locator.registerLazySingleton(() => ThemeCubit());

  final database =
      await $FloorAppDataBase.databaseBuilder('app_database.db').build();

  locator.registerSingleton<AppDataBase>(database);

  final sharedPrefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  locator.registerFactory<ApiProvider>(() => ApiProviderImpl());
  locator.registerSingleton<InternetBloc>(InternetBloc());

  ///Data source

  locator.registerLazySingleton<CharactersRemoteDatasource>(
      () => CharactersRemoteDatasourceImpl(apiProvider: locator()));

  ///repo
  locator.registerLazySingleton<CharacterRepository>(() =>
      CharactersRepositoryImpl(
          remoteDataSource: locator(),
          localDataSource: locator(),
          networkInfo: locator()));

  ///bloc

  locator.registerLazySingleton<CharactersBloc>(() => CharactersBloc());
  locator.registerLazySingleton<FavoritesBloc>(() => FavoritesBloc());
}
