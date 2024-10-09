import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'lineauth_event.dart';
part 'lineauth_state.dart';

class LineauthBloc extends Bloc<LineauthEvent, LineauthState> {
  LineauthBloc() : super(LineauthInitial()) {
    on<LineauthLogin>(_regisLineAuth);
  }

  UserRepository userRepository = UserRepository();

  void _regisLineAuth(LineauthLogin event, Emitter<LineauthState> emit) async {
    emit(LineauthLoading());
    UserRepository userRepository = UserRepository();
    try {
      await userRepository.updateProfileUser(
        username: event.username,
        date: event.brithday,
        gender: event.gender,
        phone: '',
        address: '',
        FB: '',
        twitter: '',
      );
      await userRepository.updateImageUser(
        image: File(event.imgUrl),
        type: 'social',
      );
      bool check = await userRepository.registersocial(
        username: event.username,
        email: event.email,
        identifier: await getDevice(),
        firstRegis: false,
      );
      if (check) {
        emit(LineauthSuccess('เข้าสู่ระบบสำเร็จ'));
      }
      // if (check) {
      //   final user = await userRepository.loginUser(
      //     email: event.email,
      //     password: event.password,
      //     identifier: await getDevice(),
      //   );
      //   await novelBox.put('user', json.encode(user.toJson()));
      //   await novelBox.put('loginType', 'normal');
      //   await novelBox.put('socialType', 'line');
      //   print('imgUrl: ${event.imgUrl}');
      //   final token = await novelBox.get('usertoken');
      //   print('token: $token');
      //   if (event.imgUrl.isNotEmpty) {
      //     await userRepository.updateImageUser(
      //       image: File(event.imgUrl),
      //       type: 'social',
      //     );
      //   }
      //   emit(LineauthSuccess('เข้าสู่ระบบสำเร็จ'));
      // } else {
      //   emit(LineauthFailure('เกิดข้อผิดพลาด'));
      // }
    } catch (e) {
      emit(LineauthFailure(e.toString()));
    }
  }
}
