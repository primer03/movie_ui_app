import 'package:flutter/services.dart';

class SecurityManager {
  static const platform = MethodChannel('com.example.bloctest/screen_security');

  static Future<void> enableSecurity() async {
    try {
      await platform.invokeMethod('enableSecurity');
    } on PlatformException catch (e) {
      print("Failed to enable security: '${e.message}'.");
    }
  }

  static Future<void> disableSecurity() async {
    try {
      await platform.invokeMethod('disableSecurity');
    } on PlatformException catch (e) {
      print("Failed to disable security: '${e.message}'.");
    }
  }
}
