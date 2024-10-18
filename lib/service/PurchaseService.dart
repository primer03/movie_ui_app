// import 'package:flutter/services.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'dart:io' show Platform;

class Purchaseservice {
  // static const _apiKey = '';

  // static Future init() async {
  //   await Purchases.setLogLevel(LogLevel.debug);
  //   late PurchasesConfiguration configuration;

  //   if (Platform.isAndroid) {
  //     configuration = PurchasesConfiguration(_apiKey);
  //   } else if (Platform.isIOS) {
  //     configuration = PurchasesConfiguration('');
  //   } else {
  //     throw UnsupportedError('Unsupported platform');
  //   }
  //   await Purchases.configure(configuration);
  // }

  // static Future<List<Offering>> getOfferings() async {
  //   try {
  //     final offerings = await Purchases.getOfferings();
  //     final current = offerings.current;

  //     return current == null ? [] : [current];
  //   } on PlatformException catch (e) {
  //     return [];
  //   }
  // }
}
