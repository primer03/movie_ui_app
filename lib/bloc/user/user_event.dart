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
  final String? password;
  final String type;

  const UserLoginremember(
      {required this.user, this.password, required this.type});

  @override
  List<Object> get props => [user, if (password != null) password!, type];
}

class RegisterUser extends UserEvent {
  final String username;
  final String email;
  final String password;
  final String date;
  final String gender;

  const RegisterUser(
      {required this.username,
      required this.email,
      required this.password,
      required this.date,
      required this.gender});

  @override
  List<Object> get props => [username, email, password, date, gender];
}

class ResetStateEvent extends UserEvent {
  const ResetStateEvent();
}

class LoadProfile extends UserEvent {
  final User user;
  final String? password;
  final String? username;
  final String type;

  const LoadProfile(
      {required this.user, this.password, this.username, required this.type});

  @override
  List<Object> get props => [
        user,
        if (password != null) password!,
        if (username != null) username!,
        type
      ];
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
