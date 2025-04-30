part of 'internet_bloc.dart';

sealed class InternetEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ConnectivityChanged extends InternetEvent {
  final bool isConnected;

  ConnectivityChanged(this.isConnected);

  @override
  List<Object> get props => [isConnected];
}
