import 'dart:convert';
import 'dart:io';

import 'package:bloctest/bloc/novel/novel_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:bloctest/pages/auth/social_last_regis.dart';
import 'package:bloctest/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:toastification/toastification.dart';

void lineSDKInit() async {
  await LineSDK.instance.setup("2002469697").then((_) {
    print("LineSDK is Prepared");
  });
}

Future getAccessToken() async {
  try {
    final result = await LineSDK.instance.currentAccessToken;
    return result!.value;
  } on PlatformException catch (e) {
    print(e.message);
  }
}

Future<void> startLineLogin(BuildContext context) async {
  try {
    final result =
        await LineSDK.instance.login(scopes: ["profile", "openid", "email"]);
    // Navigator.of(context).pop();
    Logger().i(result.accessToken.email);
    var accesstoken = await getAccessToken();
    var displayname = result.userProfile?.displayName;
    var statusmessage = result.userProfile?.statusMessage;
    var imgUrl = result.userProfile?.pictureUrl;
    var userId = result.userProfile?.userId;
    var email = result.accessToken.email;

    // print("AccessToken> " + accesstoken);
    // print("DisplayName> " + displayname!);
    // print("StatusMessage> " + statusmessage!);
    // print("ProfileURL> " + imgUrl!);
    // print("userId> " + userId!);
    // print("email> " + email!);
    UserRepository userRepository = UserRepository();
    try {
      if (email != null) {
        bool check = await userRepository.registersocial(
          username: displayname!,
          email: email,
          identifier: await getDevice(),
          firstRegis: true,
        );
        if (check) {
          final usertokenHive = await novelBox.get('usertoken');
          final user = JwtDecoder.decode(usertokenHive);

          print('user: ${user['detail']['gender']}');
          if (user['detail']['gender'] == null) {
            String downloadedImagePath = '';
            if (imgUrl != null) {
              downloadedImagePath = await downloadImage(imgUrl);
            }
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SocialLastRegis(
                displayName: displayname,
                email: email,
                imgUrl: downloadedImagePath,
                userId: userId!,
              );
            }));
          } else {
            showToastification(
              context: context,
              message: 'เข้าสู่ระบบสำเร็จ',
              type: ToastificationType.success,
              style: ToastificationStyle.minimal,
            );
            await novelBox.put('loginsocial', true);
            await novelBox.put('socialType', 'line');
            await novelBox.put(
                'user', json.encode(User.fromJson(user).toJson()));
            BlocProvider.of<NovelBloc>(context).add(FetchNovels());
            await Future.delayed(const Duration(seconds: 2));
            await Future.delayed(const Duration(milliseconds: 500));
            Navigator.pushNamedAndRemoveUntil(
                context, '/main', (route) => false);
          }

          // final user = await novelBox.get('user');
          // await novelBox.put('loginType', 'normal');
          // await novelBox.put('socialType', 'line');
          // await novelBox.put('issocial', true);
          // if (imgUrl != null) {
          //   await userRepository.updateImageUser(
          //     image: File(await downloadImage(imgUrl)),
          //     type: 'social',
          //   );
          // }
          // Logger().i('user: $user');
          // showToastification(
          //   context: context,
          //   message: 'กำลังเข้าสู่ระบบ โปรดรอสักครู่',
          //   type: ToastificationType.info,
          //   style: ToastificationStyle.minimal,
          // );
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return SocialLastRegis(
          //     displayName: displayname!,
          //     email: email,
          //     imgUrl: downloadedImagePath,
          //     userId: userId!,
          //   );
          // }));
        } else {
          showToastification(
            context: context,
            message: 'เกิดข้อผิดพลาดในการลงทะเบียน',
            type: ToastificationType.error,
            style: ToastificationStyle.minimal,
          );
        }
        // String check = await userRepository.loginCheckSocial(
        //   email: email,
        //   password: '',
        //   identifier: await getDevice(),
        // );
        // print('check: $check');
        // if (check == 'ไม่พบผู้ใช้หรืออีเมลนี้ในระบบ') {
        //   String downloadedImagePath = '';
        //   if (imgUrl != null) {
        //     downloadedImagePath = await downloadImage(imgUrl);
        //   }
        //   Navigator.push(context, MaterialPageRoute(builder: (context) {
        //     return SocialLastRegis(
        //       displayName: displayname!,
        //       email: email,
        //       imgUrl: downloadedImagePath,
        //       userId: userId!,
        //     );
        //   }));
        // } else if (check == 'เข้าสู่ระบบสำเร็จ') {
        //   showToastification(
        //     context: context,
        //     message: 'กำลังเข้าสู่ระบบ โปรดรอสักครู่',
        //     type: ToastificationType.info,
        //     style: ToastificationStyle.minimal,
        //   );
        //   await novelBox.put('loginsocial', true);
        //   await novelBox.put('socialType', 'line');
        //   BlocProvider.of<NovelBloc>(context).add(FetchNovels());
        //   await Future.delayed(const Duration(seconds: 2));
        //   await Future.delayed(const Duration(milliseconds: 500));
        //   Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        // }
      } else {
        showToastification(
          context: context,
          message: 'โปรดยืนยันอีเมลกับline ก่อน',
          type: ToastificationType.error,
          style: ToastificationStyle.minimal,
        );
      }
    } catch (e) {
      showToastification(
        context: context,
        message: 'เกิดข้อผิดพลาดในการลงทะเบียน',
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
      );
    }
    // return downloadImage(imgUrl);
  } on PlatformException catch (e) {
    print(e);
    switch (e.code.toString()) {
      case "CANCEL":
        print("User Cancel the login");
        break;
      case "AUTHENTICATION_AGENT_ERROR":
        print("User decline the login");
        break;
      default:
        print("Unknown but failed to login");
        break;
    }
  }
}

Future<void> logoutLine() async {
  try {
    await LineSDK.instance.logout();
    print("Logout Success");
  } on PlatformException catch (e) {
    print(e.message);
  }
}

Future<String> downloadImage(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'];
      String fileExtension = '.jpg'; // Default extension

      if (contentType != null) {
        switch (contentType.toLowerCase()) {
          case 'image/jpeg':
            fileExtension = '.jpg';
            break;
          case 'image/png':
            fileExtension = '.png';
            break;
          case 'image/gif':
            fileExtension = '.gif';
            break;
          case 'image/webp':
            fileExtension = '.webp';
            break;
          // Add more cases as needed
        }
      }

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'downloaded_image$fileExtension';
      final filePath = path.join(directory.path, fileName);

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
      // print('Image saved at $filePath');
    } else {
      print('Failed to load image: ${response.statusCode}');
      return '';
    }
  } catch (e) {
    print('Error downloading image: $e');
    return '';
  }
}
