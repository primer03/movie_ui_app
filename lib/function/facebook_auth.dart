import 'dart:convert';

import 'package:bloctest/bloc/novel/novel_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/pages/auth/social_last_regis.dart';
import 'package:bloctest/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:toastification/toastification.dart';
import 'package:bloctest/models/user_model.dart' as userModel;

Future<void> signInWithFacebook(BuildContext context) async {
  try {
    // Trigger the sign-in flow
    showLoadingDialog(context);
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Check if login was successful
    if (loginResult.status == LoginStatus.success) {
      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      // Access the user information
      User? user = userCredential.user;
      if (user != null) {
        print('Login successful! User: ${user.displayName}');
        if (user.email != null) {
          UserRepository userRepository = UserRepository();
          bool check = await userRepository.registersocial(
            username: user.displayName!,
            email: user.email!,
            identifier: await getDevice(),
            firstRegis: true,
          );
          if (check) {
            Navigator.pop(context);
            final usertokenHive = await novelBox.get('usertoken');
            final userHive = JwtDecoder.decode(usertokenHive);

            print('user: ${userHive['detail']['gender']}');
            if (userHive['detail']['gender'] == null) {
              print('gender is null');
              print(user.photoURL);
              String downloadedImagePath = '';
              if (user.photoURL != null) {
                downloadedImagePath = await downloadImage(user.photoURL!);
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SocialLastRegis(
                  displayName: user.displayName!,
                  email: user.email!,
                  imgUrl: downloadedImagePath,
                  userId: user.uid,
                  socialType: 'facebook',
                );
              }));
            } else {
              await Future.delayed(const Duration(seconds: 2));
              showToastification(
                context: context,
                message: 'เข้าสู่ระบบสำเร็จ',
                type: ToastificationType.success,
                style: ToastificationStyle.minimal,
              );
              await novelBox.put('loginsocial', true);
              await novelBox.put('socialType', 'facebook');
              await novelBox.put('user',
                  json.encode(userModel.User.fromJson(userHive).toJson()));
              print('user: ${await novelBox.get('user')}');
              BlocProvider.of<NovelBloc>(context).add(FetchNovels());
              await Future.delayed(const Duration(seconds: 2));
              await Future.delayed(const Duration(milliseconds: 500));
              Navigator.pushNamedAndRemoveUntil(
                  context, '/main', (route) => false);
            }
          } else {
            Navigator.pop(context);
            showToastification(
              context: context,
              message: 'เข้าสู่ระบบไม่สำเร็จ',
              type: ToastificationType.error,
              style: ToastificationStyle.minimal,
            );
          }
        } else {
          Navigator.pop(context);
          showToastification(
            context: context,
            message: 'กรุณายืนยันอีเมล',
            type: ToastificationType.error,
            style: ToastificationStyle.minimal,
          );
        }
      } else {
        Navigator.pop(context);
        showToastification(
          context: context,
          message: 'เข้าสู่ระบบไม่สำเร็จ',
          type: ToastificationType.error,
          style: ToastificationStyle.minimal,
        );
      }
    } else if (loginResult.status == LoginStatus.cancelled) {
      Navigator.pop(context);
      showToastification(
        context: context,
        message: 'ยกเลิกการเข้าสู่ระบบ',
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
      );
      return; // User cancelled the login
    } else {
      Navigator.pop(context);
      showToastification(
        context: context,
        message: 'เข้าสู่ระบบไม่สำเร็จ',
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
      );
      return;
    }
  } catch (e) {
    Navigator.pop(context);
    showToastification(
      context: context,
      message: 'Error during Facebook sign-in: $e',
      type: ToastificationType.error,
      style: ToastificationStyle.minimal,
    );
    return;
  }
}

Future<void> signOutFacebook() async {
  try {
    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Sign out from Facebook
    await FacebookAuth.instance.logOut();

    print('User successfully logged out');
  } catch (e) {
    print('Error during sign out: $e');
  }
}
