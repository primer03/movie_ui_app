part of 'changepassword_bloc.dart';

sealed class ChangepasswordEvent extends Equatable {
  const ChangepasswordEvent();

  @override
  List<Object> get props => [];
}

final class ChangePassword extends ChangepasswordEvent {
  final String oldPassword;
  final String newPassword;

  const ChangePassword({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [oldPassword, newPassword];
}