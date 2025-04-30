import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'internet_event.dart';

part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  late StreamSubscription<InternetConnectionStatus> _connectivitySubscription;

  final connectionChecker = InternetConnectionChecker.instance;

  bool hasInternet = false;

  InternetBloc() : super(InternetInitial()) {
    on<ConnectivityChanged>((event, emit) {
      if (event.isConnected) {
        emit(InternetConnected(event.isConnected));
        hasInternet = true;
      } else {
        emit(InternetDisConnected());
        hasInternet = false;
      }
    });

    _connectivitySubscription = connectionChecker.onStatusChange.listen(
      (InternetConnectionStatus status) {
        if (status == InternetConnectionStatus.connected) {
          add(ConnectivityChanged(true));
        } else {
          add(ConnectivityChanged(false));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
