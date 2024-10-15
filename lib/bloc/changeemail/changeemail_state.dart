part of 'changeemail_bloc.dart';

sealed class ChangeemailState extends Equatable {
  const ChangeemailState();

  @override
  List<Object> get props => [];
}

final class ChangeemailInitial extends ChangeemailState {}

final class ChangeemailLoading extends ChangeemailState {}

final class ChangeemailSuccess extends ChangeemailState {
  final Map<String, dynamic> message;

  const ChangeemailSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class ChangeemailFailure extends ChangeemailState {
  final String error;

  const ChangeemailFailure({required this.error});

  @override
  List<Object> get props => [error];
}