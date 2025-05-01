import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'internet_event.dart';

part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  late StreamSubscription<InternetConnectionStatus> _connectivitySubscription;

  final InternetConnectionChecker connectionChecker;

  InternetBloc(this.connectionChecker) : super(InternetInitial()) {
    on<ConnectivityChanged>((event, emit) {
      if (event.isConnected) {
        emit(InternetConnected(event.isConnected));
      } else {
        emit(InternetDisConnected());
      }
    });

    _connectivitySubscription = connectionChecker.onStatusChange.listen(
      (InternetConnectionStatus status) {
        add(ConnectivityChanged(status == InternetConnectionStatus.connected));

      },
    );
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
