import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:toastification/toastification.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io' show Platform;

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
  // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  // return androidInfo.model;
  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.model;
  } else if (Platform.isIOS) {
    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.utsname.machine;
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
          child: LoadingAnimationWidget.discreteCircle(
            color: Colors.white,
            secondRingColor: Colors.black,
            thirdRingColor: Colors.red[900]!,
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
