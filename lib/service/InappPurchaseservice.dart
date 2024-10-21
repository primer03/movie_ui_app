import 'dart:async';
import 'package:bloctest/main.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:logger/logger.dart';

class InAppPurchaseService {
  static final InAppPurchaseService _instance =
      InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;

  late StreamSubscription<dynamic> _subscription;

  InAppPurchaseService._internal() {
    _init();
  }

  void _init() {
    Logger().i('Init InAppPurchaseService');
    final InAppPurchase _inAppPurchase = InAppPurchase.instance;
    Stream purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onError: (error) {
      globalScaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    });
  }

  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        globalScaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(content: Text('Pending')),
        );
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        Logger().e('Error ${purchaseDetails.error}');
        globalScaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(content: Text('Error: ${purchaseDetails.error}')),
        );
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Handle successful purchase verification
        // Add your verification logic here
        if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            if (purchaseDetails.productID == 'vip_30_day') {
              Logger().i(
                  'Purchase ${purchaseDetails.verificationData.localVerificationData}');
              Logger().i(
                  'Purchase ${purchaseDetails.verificationData.serverVerificationData}');
              Logger().i('Purchase ${purchaseDetails.verificationData.source}');
              InAppPurchaseAndroidPlatformAddition androidAddition =
                  InAppPurchase.instance.getPlatformAddition<
                      InAppPurchaseAndroidPlatformAddition>();
              await androidAddition.consumePurchase(purchaseDetails);
            }
          } else {
            globalScaffoldMessengerKey.currentState!.showSnackBar(
              SnackBar(content: Text('Purchase verification failed')),
            );
          }
        }
        globalScaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(content: Text('Purchase verification success')),
        );
      }

      if (purchaseDetails.pendingCompletePurchase) {
        globalScaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(content: Text('Pending complete purchase')),
        );
        Logger().i('Pending complete purchase');
        InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == 'vip_30_day') {
      return true; // หากการตรวจสอบสำเร็จ
    } else {
      return false; // หากการตรวจสอบล้มเหลว
    }
  }

  void dispose() {
    Logger().i('Dispose InAppPurchaseService');
    _subscription.cancel();
  }
}
