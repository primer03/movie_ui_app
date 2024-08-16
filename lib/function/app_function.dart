import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:toastification/toastification.dart';

String abbreviateNumber(num number) {
  if (number.abs() < 1000) return number.toInt().toString();

  final units = ['', 'k', 'M', 'B', 'T'];
  int unitIndex = 0;
  double abbreviatedNumber = number.toDouble();

  while (abbreviatedNumber.abs() >= 1000 && unitIndex < units.length - 1) {
    abbreviatedNumber /= 1000;
    unitIndex++;
  }

  return '${abbreviatedNumber.toStringAsFixed(1)} ${units[unitIndex]}';
}

Future<String> getDevice() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  return androidInfo.model;
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
}) {
  toastification.show(
    context: context,
    title: Text(
      message,
      style: GoogleFonts.athiti(
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    ),
    autoCloseDuration: autoCloseDuration,
    alignment: alignment,
    type: type,
    style: style,
    showProgressBar: showProgressBar,
    icon: icon,
  );
}

void showLoadingDialog(BuildContext context) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black.withOpacity(0.5),
    statusBarIconBrightness: Brightness.light,
  ));

  showDialog(
    context: context,
    barrierDismissible: false, // ป้องกันการปิด dialog โดยการคลิกข้างนอก
    builder: (context) {
      return PopScope(
        canPop: false,
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
    // Reset status bar style when dialog is closed
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Reset status bar to default color
      statusBarIconBrightness: Brightness.dark, // Reset status bar icon color
    ));
  });
}
