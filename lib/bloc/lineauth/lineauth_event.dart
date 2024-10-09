part of 'lineauth_bloc.dart';

sealed class LineauthEvent extends Equatable {
  const LineauthEvent();

  @override
  List<Object> get props => [];
}

final class LineauthLogin extends LineauthEvent {
  String email;
  String password;
  String gender;
  String brithday;
  String username;
  String imgUrl;
  
  LineauthLogin({
    required this.email,
    required this.password,
    required this.gender,
    required this.brithday,
    required this.username,
    required this.imgUrl,
  });

  @override
  List<Object> get props =>
      [email, password, gender, brithday, username, imgUrl];
}
