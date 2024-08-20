part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class UserLoading extends UserState {}

class RegisterLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;

  const UserLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserLoginSuccess extends UserState {
  final User user;
  final DateTime timestamp;

  UserLoginSuccess(this.user) : timestamp = DateTime.now();

  @override
  List<Object> get props => [user, timestamp];
}

class UserLoginFailed extends UserState {
  final String message;
  final DateTime timestamp;

  UserLoginFailed(this.message) : timestamp = DateTime.now();

  @override
  List<Object> get props => [message, timestamp];
}

class UserNoData extends UserState {}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}

class UserLoginrememberSate extends UserState {
  final User user;

  const UserLoginrememberSate(this.user);

  @override
  List<Object> get props => [user];
}

class UserLoginSuccessState extends UserState {
  final User user;

  const UserLoginSuccessState(this.user);

  @override
  List<Object> get props => [user];
}

class RegisterUserSuccess extends UserState {}

class RegisterUserFailed extends UserState {
  final String message;

  const RegisterUserFailed(this.message);

  @override
  List<Object> get props => [message];
}

class UserLoadingProfile extends UserState {}

class UserLoadedProfile extends UserState {
  final User user;

  const UserLoadedProfile(this.user);

  @override
  List<Object> get props => [user];
}

class UserLoadedProfileFailed extends UserState {
  final String message;

  const UserLoadedProfileFailed(this.message);

  @override
  List<Object> get props => [message];
}

class RegisterUserFailedResetState extends UserState {}
