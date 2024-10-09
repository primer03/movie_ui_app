part of 'lineauth_bloc.dart';

sealed class LineauthState extends Equatable {
  const LineauthState();
  
  @override
  List<Object> get props => [];
}

final class LineauthInitial extends LineauthState {}

final class LineauthLoading extends LineauthState {}

final class LineauthSuccess extends LineauthState {
  final String message;

  const LineauthSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class LineauthFailure extends LineauthState {
  final String message;

  const LineauthFailure(this.message);

  @override
  List<Object> get props => [message];
}
