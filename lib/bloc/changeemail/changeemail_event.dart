part of 'changeemail_bloc.dart';

sealed class ChangeemailEvent extends Equatable {
  const ChangeemailEvent();

  @override
  List<Object> get props => [];
}

final class ChangeEmail extends ChangeemailEvent {
  final String oldEmail;
  final String newEmail;

  const ChangeEmail({required this.oldEmail, required this.newEmail});

  @override
  List<Object> get props => [oldEmail, newEmail];
}
