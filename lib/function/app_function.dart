import 'dart:convert';
import 'dart:ffi';

import 'package:bloctest/bloc/page/page_bloc.dart';
import 'package:bloctest/function/facebook_auth.dart';
import 'package:bloctest/function/google_auth.dart';
import 'package:bloctest/function/line_auth.dart';
import 'package:bloctest/main.dart';

import 'package:bloctest/repositories/user_repository.dart';
import 'package:bloctest/service/SocketService.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:io' show File, Platform;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:bloctest/models/user_model.dart' as userModel;

const storage = FlutterSecureStorage();

Future<void> savePassword(String password) async {
  await storage.write(key: 'password', value: password);
}

Future<String?> getPassword() async {
  return await storage.read(key: 'password');
}

Future<void> deletePassword() async {
  await storage.delete(key: 'password');
}

String formatThaiDate(DateTime dateTime) {
  // List of Thai months
  const List<String> thaiMonths = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม'
  ];

  // Convert to Buddhist Era (BE)
  int buddhistYear = dateTime.year + 543;

  // Format time (17:32)
  String formattedTime = DateFormat('HH:mm').format(dateTime);

  // Build the full date string
  String formattedDate =
      '${dateTime.day} ${thaiMonths[dateTime.month - 1]} $buddhistYear $formattedTime';

  return formattedDate;
}

String abbreviateNumber(num number) {
  if (number.abs() < 1000) return number.toInt().toString();

  final units = ['', 'k', 'M', 'B', 'T'];
  int unitIndex = 0;
  double abbreviatedNumber = number.toDouble();

  while (abbreviatedNumber.abs() >= 1000 && unitIndex < units.length - 1) {
    abbreviatedNumber /= 1000;
    unitIndex++;
  }

  return '${abbreviatedNumber.toStringAsFixed(2)}${units[unitIndex]}';
}

Future<String> getDevice() async {
  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}');
    return androidInfo.model;
  } else if (Platform.isIOS) {
    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;
    print('Running on ${iosInfo.utsname.machine}');
    return iosInfo.utsname.machine; //
  } else {
    return 'Unknown';
  }
}

void showToastification({
  required BuildContext context,
  required String message,
  ToastificationType type = ToastificationType.success,
  ToastificationStyle style = ToastificationStyle.fillColored,
  Duration autoCloseDuration = const Duration(seconds: 5),
  Alignment alignment = Alignment.topCenter,
  bool showProgressBar = false,
  Widget? icon,
  Color? backgroundColor,
  Color? textColor,
  double? borderRadius,
}) {
  toastification.show(
    context: context,
    title: Text(
      message,
      style: GoogleFonts.athiti(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        // color: textColor ?? Colors.white,
      ),
    ),
    autoCloseDuration: autoCloseDuration,
    alignment: alignment,
    type: type,
    style: style,
    showProgressBar: showProgressBar,
    icon: icon,
    backgroundColor: backgroundColor,
    // borderRadius: BorderRadius.circular(borderRadius ?? 10),
  );
}

void showLoadingDialog(BuildContext context, {bool canPop = false}) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black.withOpacity(0.5),
    statusBarIconBrightness: Brightness.light,
  ));

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return PopScope(
        canPop: canPop,
        child: Center(
          child: LoadingAnimationWidget.hexagonDots(
            color: Colors.white,
            size: 50,
          ),
        ),
      );
    },
  ).then((_) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
  });
}

String convertThaiDateToISO(String thaiDate) {
  final monthMap = {
    'มกราคม': 1,
    'กุมภาพันธ์': 2,
    'มีนาคม': 3,
    'เมษายน': 4,
    'พฤษภาคม': 5,
    'มิถุนายน': 6,
    'กรกฎาคม': 7,
    'สิงหาคม': 8,
    'กันยายน': 9,
    'ตุลาคม': 10,
    'พฤศจิกายน': 11,
    'ธันวาคม': 12,
  };

  final parts = thaiDate.split(' ');
  if (parts.length != 3) {
    throw const FormatException('Invalid date format');
  }

  final day = int.parse(parts[0]);
  final monthName = parts[1];
  final buddhistYear = int.parse(parts[2]);

  final month = monthMap[monthName];
  if (month == null) {
    throw const FormatException('Invalid month name');
  }

  final gregorianYear = buddhistYear - 543;

  final date = DateTime(gregorianYear, month, day);

  final dateFormatter = DateFormat('yyyy-MM-dd');
  return dateFormatter.format(date);
}

String convertISOToThaiDate(String isoDate) {
  final monthMap = {
    1: 'มกราคม',
    2: 'กุมภาพันธ์',
    3: 'มีนาคม',
    4: 'เมษายน',
    5: 'พฤษภาคม',
    6: 'มิถุนายน',
    7: 'กรกฎาคม',
    8: 'สิงหาคม',
    9: 'กันยายน',
    10: 'ตุลาคม',
    11: 'พฤศจิกายน',
    12: 'ธันวาคม',
  };

  final date = DateTime.parse(isoDate);
  final day = date.day;
  final month = date.month;
  final gregorianYear = date.year;

  final buddhistYear = gregorianYear + 543;

  final monthName = monthMap[month];
  if (monthName == null) {
    throw const FormatException('Invalid month number');
  }
  return '$day $monthName $buddhistYear';
}

List<T> parseList<T>(
    List<dynamic> list, T Function(Map<String, dynamic>) fromJson) {
  return list.map<T>((item) => fromJson(item)).toList();
}

Future<void> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String version = packageInfo.version; // เวอร์ชันแอป
  String buildNumber = packageInfo.buildNumber; // หมายเลขบิลด์

  print('App Version: $version');
  print('Build Number: $buildNumber');
}

Future<void> logoutAll(BuildContext context, {bool uniqlog = false}) async {
  disconnectSocket();
  final socialtype = await novelBox.get('socialType');
  if (socialtype != null) {
    print('socialtype: $socialtype');
    if (socialtype == 'line') {
      await logoutLine();
    } else if (socialtype == 'google') {
      final googleAuth = GoogleAuthService();
      await googleAuth.signOut();
    } else if (socialtype == 'facebook') {
      await signOutFacebook();
    }
  }
  await deletePassword();
  if (uniqlog) {
    String? userlog = await novelBox.get('user');
    if (userlog != null) {
      final userModel.User user = userModel.User.fromJson(json.decode(userlog));
      // Logger().i('User ID: ${user.userid}');
      await UserRepository().logoutUser(user.userid);
    }
  }

  await novelBox.clear();
  BlocProvider.of<PageBloc>(context).add(const PageChanged(tabIndex: 0));
  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}

// IO.Socket? socket;

// void setupSocket() async {
//   if (socket != null && socket!.connected) {
//     return;
//   }

//   socket = IO.io(
//     'https://pzfbh88v-3002.asse.devtunnels.ms',
//     IO.OptionBuilder()
//         .setTransports(['websocket'])
//         .disableAutoConnect()
//         .build(),
//   );

//   // Listen to connection events
//   socket!.onConnect((_) async {
//     print('Connected');
//     print('User token: ${await novelBox.get('usertoken')}');
//     userModel.User user =
//         userModel.User.fromJson(json.decode(await novelBox.get('user')));
//     print('User ID: ${user.userid}');
//     socket!.emit('usermobile_online', user.userid);
//     novelBox.put('isSocketConnected', true);
//   });

//   socket!.on('message', (data) {
//     print('Message from server: $data');
//   });

//   socket!.onDisconnect((_) {
//     novelBox.put('isSocketConnected', false);
//     print('Disconnected');
//   });

//   socket!.connect();
// }

// void disconnectSocket() {
//   if (socket != null) {
//     socket!.disconnect();
//     print('Socket disconnected');
//   }
// }

// // ฟังก์ชันสำหรับการเชื่อมต่อ socket ใหม่
// void reconnectSocket() {
//   if (socket != null && !socket!.connected) {
//     socket!.connect();
//     print('Socket connected');
//   }
// }

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
