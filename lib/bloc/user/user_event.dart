part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUser extends UserEvent {}

class AddUser extends UserEvent {
  final String name;
  final String email;

  AddUser({required this.name, required this.email});

  @override
  List<Object> get props => [name, email];
}

class LoginUser extends UserEvent {
  final String email;
  final String password;
  final String identifier;

  const LoginUser(
      {required this.email, required this.password, required this.identifier});

  @override
  List<Object> get props => [email, password, identifier];
}

class UserLoginremember extends UserEvent {
  final User user;

  const UserLoginremember({required this.user});

  @override
  List<Object> get props => [user];
}

// class UpdateUser extends UserEvent {
//   final User user;

//   UpdateUser({required this.user});

//   @override
//   List<Object> get props => [user];
// }

// class DeleteUser extends UserEvent {
//   final User user;

//   DeleteUser({required this.user});

//   @override
//   List<Object> get props => [user];
// }

// class SearchUser extends UserEvent {
//   final String query;

//   const SearchUser({required this.query});

//   @override
//   List<Object> get props => [query];
// }
