import 'package:bloc/bloc.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:bloctest/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoginUser>(_onLoginUser);
    on<UserLoginremember>(_onLoginSuccess);
    on<RegisterUser>(_onRegister);
    on<ResetStateEvent>(_onResetState);
    on<LoadProfile>(_onLoadProfile);
  }

  void _onLoadProfile(LoadProfile event, Emitter<UserState> emit) async {
    // emit(UserLoadingProfile());
    try {
      User user = await userRepository.loginUser(
        email: event.user.detail.email,
        password: event.password!,
        identifier: event.user.ag,
      );
      emit(UserLoadedProfile(user));
      emit(UserLoginrememberSate(user));
    } catch (e) {
      emit(UserLoadedProfileFailed(e.toString()));
    }
  }

  void _onResetState(ResetStateEvent event, Emitter<UserState> emit) {
    emit(UserInitial());
  }

  void _onLoginUser(LoginUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      User user = await userRepository.loginUser(
        email: event.email,
        password: event.password,
        identifier: event.identifier,
      );
      emit(UserLoginSuccess(user));
    } catch (e) {
      emit(UserLoginFailed(e.toString()));
    }
  }

  void _onLoginSuccess(UserLoginremember event, Emitter<UserState> emit) async {
    try {
      User user = event.user;
      User userlogin;
      if (event.password != null) {
        userlogin = await userRepository.loginUser(
            email: user.detail.email,
            password: event.password!,
            identifier: user.ag);
      } else {
        userlogin = user;
      }
      emit(UserLoginrememberSate(userlogin));
    } catch (e) {
      emit(UserLoginRemeberFailed(e.toString()));
    }
  }

  void _onRegister(RegisterUser event, Emitter<UserState> emit) async {
    emit(RegisterLoading());
    try {
      await userRepository.registerUser(
        username: event.username,
        email: event.email,
        password: event.password,
        date: event.date,
        gender: event.gender,
      );
      emit(RegisterUserSuccess());
    } catch (e) {
      emit(RegisterUserFailed(e.toString()));
    }
  }
}
