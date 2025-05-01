import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_morty/core/network/internet_bloc/internet_bloc.dart';

import '../features/helper/test_helper.mocks.dart';

void main() {
  late MockInternetConnectionChecker connectionChecker;
  late StreamController<InternetConnectionStatus> controller;

  setUp(() {
    connectionChecker = MockInternetConnectionChecker();
    controller = StreamController<InternetConnectionStatus>();
    when(connectionChecker.onStatusChange).thenAnswer((_) => controller.stream);
  });
  tearDown(() {
    controller.close();
  });

  blocTest<InternetBloc, InternetState>(
      'emits [InternetDisConnected] when connection status is disconnected',
      build: () => InternetBloc(connectionChecker),
      act: (bloc) {
        controller.add(InternetConnectionStatus.disconnected);
      },
      expect: () => [InternetDisConnected()]);

  blocTest('emits [InternetConnected] when connection status is connected',
      build: () => InternetBloc(connectionChecker),
      act: (bloc) {
        controller.add(InternetConnectionStatus.connected);
      },
      expect: () => [InternetConnected(true)]);
}
