import 'package:flutter/services.dart';

class BrightnessService {
  static const MethodChannel _channel =
      MethodChannel('samples.flutter.dev/brightness');

  static Future<void> setBrightness(double brightness) async {
    try {
      await _channel.invokeMethod('setBrightness', {'brightness': brightness});
    } on PlatformException catch (e) {
      print("Failed to set brightness: '${e.message}'.");
    }
  }

  static Future<void> resetBrightness() async {
    try {
      await _channel.invokeMethod('resetBrightness');
    } on PlatformException catch (e) {
      print("Failed to reset brightness: '${e.message}'.");
    }
  }

  static Future<void> disableBrightnessAdjustment() async {
    try {
      await _channel.invokeMethod('disableBrightnessAdjustment');
    } on PlatformException catch (e) {
      print("Failed to disable brightness adjustment: '${e.message}'.");
    }
  }

  static Future<double?> getBrightness() async {
    try {
      final double? brightness = await _channel.invokeMethod('getBrightness');
      return brightness;
    } on PlatformException catch (e) {
      print("Failed to get brightness: '${e.message}'.");
      return null;
    }
  }
}
