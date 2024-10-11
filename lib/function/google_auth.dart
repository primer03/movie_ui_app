import 'dart:convert';
import 'package:bloctest/bloc/novel/novel_bloc.dart';
import 'package:bloctest/models/user_model.dart' as userModel;
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/pages/auth/social_last_regis.dart';
import 'package:bloctest/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:toastification/toastification.dart';

Future<UserCredential?> signInWithGoogle(BuildContext context) async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Check if the user canceled the sign-in process
    if (googleUser == null) {
      print('Sign in aborted by user');
      return null; // Return null if user cancels the sign-in
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Access the user information
    User? user = userCredential.user;

    if (user != null) {
      // Print the user's display name
      print('Login successful! User: ${user.displayName}');
      UserRepository userRepository = UserRepository();
      bool check = await userRepository.registersocial(
        username: user.displayName!,
        email: user.email!,
        identifier: await getDevice(),
        firstRegis: true,
      );
      if (check) {
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
              socialType: 'google',
            );
          }));
        } else {
          showToastification(
            context: context,
            message: 'เข้าสู่ระบบสำเร็จ',
            type: ToastificationType.success,
            style: ToastificationStyle.minimal,
          );
          // print('Login successful! User: ${usertokenHive}');
          await novelBox.put('loginsocial', true);
          await novelBox.put('socialType', 'google');
          await novelBox.put(
              'user', json.encode(userModel.User.fromJson(userHive).toJson()));
          print('user: ${await novelBox.get('user')}');
          BlocProvider.of<NovelBloc>(context).add(FetchNovels());
          await Future.delayed(const Duration(seconds: 2));
          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        }
      }
    } else {
      print('No user information found');
    }

    return userCredential;
  } catch (e) {
    print('Error during Google sign-in: $e');
    return null;
  }
}

Future<void> signOut() async {
  try {
    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Sign out from Google
    await GoogleSignIn().signOut();

    print('User successfully logged out');
  } catch (e) {
    print('Error during sign out: $e');
  }
}
