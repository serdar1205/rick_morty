part of 'internet_bloc.dart';

sealed class InternetState extends Equatable {
  @override
  List<Object> get props => [];
}

final class InternetInitial extends InternetState {}

final class InternetConnected extends InternetState {
  final bool isConnected;

  InternetConnected(this.isConnected);

  @override
  List<Object> get props => [isConnected];
}

final class InternetDisConnected extends InternetState {}
