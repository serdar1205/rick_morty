import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:rick_morty/core/network/api_provider.dart';
import 'package:rick_morty/features/domain/reposotories/character_repository.dart';

@GenerateNiceMocks([
  MockSpec<ApiProvider>(),
  MockSpec<InternetConnectionChecker>(),
  MockSpec<CharacterRepository>(),
  // MockSpec<CharactersRemoteDatasourceImpl>(),

])
void main(){}