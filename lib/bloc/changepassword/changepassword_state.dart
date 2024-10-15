part of 'changepassword_bloc.dart';

sealed class ChangepasswordState extends Equatable {
  const ChangepasswordState();

  @override
  List<Object> get props => [];
}

final class ChangepasswordInitial extends ChangepasswordState {}

final class ChangepasswordLoading extends ChangepasswordState {}

final class ChangepasswordSuccess extends ChangepasswordState {
  final Map<String, dynamic> message;

  const ChangepasswordSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class ChangepasswordFailure extends ChangepasswordState {
  final String error;

  const ChangepasswordFailure({required this.error});

  @override
  List<Object> get props => [error];
}
