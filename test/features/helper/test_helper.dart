import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:rick_morty/core/network/api_provider.dart';
import 'package:rick_morty/core/network/network.dart';
import 'package:rick_morty/features/data/datasources/local/dao/characters_dao.dart';
import 'package:rick_morty/features/data/datasources/local/dao/favorites_dao.dart';
import 'package:rick_morty/features/data/datasources/local/local_datasources/character_local_datasource.dart';
import 'package:rick_morty/features/data/datasources/local/local_datasources/favorites_local_datasource.dart';
import 'package:rick_morty/features/data/datasources/remote/characters_remote_datasource.dart';
import 'package:rick_morty/features/domain/reposotories/character_repository.dart';
import 'package:rick_morty/features/domain/reposotories/favorites_repository.dart';

@GenerateNiceMocks([
  MockSpec<ApiProvider>(),
  MockSpec<InternetConnectionChecker>(),
  MockSpec<CharacterRepository>(),
  MockSpec<FavoritesRepository>(),
  MockSpec<CharactersDao>(),
  MockSpec<FavoritesDao>(),
  MockSpec<CharactersRemoteDatasource>(),
  MockSpec<CharactersLocalDataSource>(),
  MockSpec<FavoritesLocalDatasource>(),
  MockSpec<NetworkInfo>(),
])
void main(){}