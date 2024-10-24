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
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';
import 'package:toastification/toastification.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserRepository _userRepository = UserRepository();
  final Logger _logger = Logger();

  static const String _errorDuplicateLogin =
      'มีการล็อคอินซ้อนอยู่ในเบาว์เซอร์อื่น';

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await _handleGoogleSignIn();
      if (googleUser == null) return null;

      final credential = await _getGoogleCredential(googleUser);
      showLoadingDialog(context);

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await _handleUserRegistration(context, user);
      }

      return userCredential;
    } catch (e) {
      _handleError(context, e);
      return null;
    }
  }

  Future<GoogleSignInAccount?> _handleGoogleSignIn() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      _logger.i('Sign in aborted by user');
    }
    return googleUser;
  }

  Future<OAuthCredential> _getGoogleCredential(
      GoogleSignInAccount googleUser) async {
    final googleAuth = await googleUser.authentication;
    return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  Future<void> _handleUserRegistration(BuildContext context, User user) async {
    try {
      final isRegistered = await _userRepository.registersocial(
        username: user.displayName!,
        email: user.email!,
        identifier: await getDevice(),
        firstRegis: true,
      );

      if (isRegistered) {
        await _processSuccessfulRegistration(context, user);
      }
    } catch (e) {
      await _handleRegistrationError(context, e);
    }
  }

  Future<void> _processSuccessfulRegistration(
      BuildContext context, User user) async {
    Navigator.pop(context); // ยังจำเป็น เพราะต้องปิด loading dialog

    final usertoken = await novelBox.get('usertoken');
    final userDetail = JwtDecoder.decode(usertoken);

    if (userDetail['detail']['gender'] == null) {
      await _handleNewUserRegistration(context, user);
    } else {
      await _handleExistingUserLogin(context);
    }
  }

  Future<void> _handleNewUserRegistration(
      BuildContext context, User user) async {
    String photoPath = '';
    if (user.photoURL != null) {
      photoPath = await downloadImage(user.photoURL!);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SocialLastRegis(
          displayName: user.displayName!,
          email: user.email!,
          imgUrl: photoPath,
          userId: user.uid,
          socialType: 'google',
        ),
      ),
    );
  }

  Future<void> _handleExistingUserLogin(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _showSuccessToast(context);

    await _saveUserData();

    BlocProvider.of<NovelBloc>(context).add(FetchNovels());

    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
  }

  void _showSuccessToast(BuildContext context) {
    showToastification(
      context: context,
      message: 'เข้าสู่ระบบสำเร็จ',
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
    );
  }

  Future<void> _saveUserData() async {
    final usertoken = await novelBox.get('usertoken');
    final userDetail = JwtDecoder.decode(usertoken);

    await novelBox.put('loginsocial', true);
    await novelBox.put('socialType', 'google');
    await novelBox.put(
        'user', json.encode(userModel.User.fromJson(userDetail).toJson()));
  }

  Future<void> _handleRegistrationError(
      BuildContext context, dynamic error) async {
    Navigator.pop(context); // ยังจำเป็น เพราะต้องปิด loading dialog

    final errorMessage = _parseErrorMessage(error);
    if (errorMessage['message'] == _errorDuplicateLogin) {
      _showDuplicateLoginDialog(context);
    } else {
      showToastification(
        context: context,
        message: errorMessage['message'],
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
      );
    }
  }

  Map<String, dynamic> _parseErrorMessage(dynamic error) {
    String rawMessage = error.toString().split('Exception: ').last;
    String formattedMessage = rawMessage
        .replaceAll('{', '{"')
        .replaceAll('}', '"}')
        .replaceAll(': ', '": "')
        .replaceAll(', ', '", "');

    try {
      return json.decode(formattedMessage);
    } catch (e) {
      signOut();
      _logger.e('Failed to decode JSON: $e');
      return {'message': 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง'};
    }
  }

  void _showDuplicateLoginDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => _buildDuplicateLoginDialog(context),
    );
  }

  Widget _buildDuplicateLoginDialog(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          padding: const EdgeInsets.fromLTRB(20, 55, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _errorDuplicateLogin,
                style: GoogleFonts.athiti(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decorationColor: Colors.black,
                  decoration: TextDecoration.none,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              _buildLogoutButton(context),
            ],
          ),
        ),
        _buildMascotImage(),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleLogout(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          'ออกจากระบบ',
          style: GoogleFonts.athiti(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildMascotImage() {
    return Positioned(
      top: 190,
      child: Stack(
        children: [
          Opacity(
            opacity: 1,
            child: Image.network(
              "https://serverimges.bookfet.com/mascot/6.png",
              width: 200,
              height: 200,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 6,
            left: 9,
            child: Image.network(
              "https://serverimges.bookfet.com/mascot/6.png",
              width: 180,
              height: 180,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    await signOut();
    await _handleOverlappingUser();
    Navigator.pop(context); // ยังจำเป็น เพราะต้องปิด dialog

    showToastification(
      context: context,
      message: 'เข้าสู่ระบบใหม่อีกครั้ง',
      type: ToastificationType.info,
      style: ToastificationStyle.minimal,
    );
  }

  Future<void> _handleOverlappingUser() async {
    try {
      final userlog = await novelBox.get('useroverlap');
      if (userlog != null) {
        final useroverlap = userModel.User.fromJson(json.decode(userlog));
        await _userRepository.logoutUser(useroverlap.userid);
        await novelBox.delete('useroverlap');
        await novelBox.delete('usertoken');
      }
    } catch (e) {
      _logger.e('Error handling overlapping user: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _logger.i('User successfully logged out');
    } catch (e) {
      _logger.e('Error during sign out: $e');
    }
  }

  void _handleError(BuildContext context, dynamic error) {
    Navigator.pop(context); // ยังจำเป็น เพราะต้องปิด loading dialog
    showToastification(
      context: context,
      message: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง',
      type: ToastificationType.error,
      style: ToastificationStyle.minimal,
    );
    _logger.e('Error during Google sign-in: $error');
  }
}
