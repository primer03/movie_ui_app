import 'dart:async';

import 'package:bloctest/main.dart';
import 'package:bloctest/widgets/MembershipCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  List<ProductDetails> _products = [];
  static const _variant = {'vip_30_day'};
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  @override
  void initState() {
    super.initState();
    initStore();
  }

  initStore() async {
    print('isAvailable ${await _inAppPurchase.isAvailable()}');
    ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_variant);

    if (productDetailResponse.notFoundIDs.isEmpty) {
      setState(() {
        _products = productDetailResponse.productDetails;
      });
    } else {
      globalScaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text('Products not found')),
      );
    }
  }

  buy() async {
    await InAppPurchase.instance.restorePurchases();
    if (_products.isNotEmpty) {
      // Logger().i('Buy ${_products[1].id}');
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: _products[0]);
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      print('No product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/logo_bookfet_white.png',
                width: 100,
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.78,
            minChildSize: 0.78,
            maxChildSize: 0.78,
            snap: true,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(25),
                  children: [
                    Text(
                      'อ่านนิยายสุดพิเศษ ที่มีเฉพาะสำหรับสมาชิก VIP เท่านั้น! เปิดโลกแห่งการอ่านที่เต็มไปด้วยความสนุกสนาน พร้อมกับการเข้าถึงตอนใหม่และเนื้อหาพิเศษมากมายก่อนใคร!',
                      style: GoogleFonts.athiti(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                      height: 30,
                    ),
                    MenuDetailMemberShip(
                      header: 'เดือน',
                      subHeader: MonthHelper.getThaiMonth(DateTime.now().month),
                    ),
                    const SizedBox(height: 45),
                    MenuDetailMemberShip(
                      header: 'ราคา',
                      subHeader: '429 บาท',
                    ),
                    const SizedBox(height: 45),
                    MenuDetailMemberShip(
                      header: 'วันที่เริ่มต้น',
                      subHeader:
                          '${DateTime.now().day} ${MonthHelper.getThaiMonth(DateTime.now().month)} ${DateTime.now().year}',
                    ),
                    const SizedBox(height: 45),
                    MenuDetailMemberShip(
                      header: 'วันสิ้นสุด',
                      subHeader: getDateAfter30Days(),
                    ),
                    const SizedBox(height: 45),
                    ElevatedButton(
                      onPressed: () {
                        // buy();
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(10),
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white),
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 50, 20, 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        'ชำระเงินเรียบร้อย',
                                        style: GoogleFonts.athiti(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          overlayColor: Colors.white,
                                          splashFactory:
                                              InkRipple.splashFactory,
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Text(
                                            'ปิด',
                                            style: GoogleFonts.athiti(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: 180,
                                    child: Stack(
                                      children: [
                                        Opacity(
                                          opacity: 1,
                                          child: Image.network(
                                            "https://serverimges.bookfet.com/mascot/1.png",
                                            width: 200,
                                            height: 200,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Positioned(
                                          top: 6,
                                          left: 10,
                                          child: Image.network(
                                            "https://serverimges.bookfet.com/mascot/1.png",
                                            width: 180,
                                            height: 180,
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        overlayColor: Colors.white,
                        splashFactory: InkRipple.splashFactory,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'ชำระเงิน',
                          style: GoogleFonts.athiti(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String getDateAfter30Days() {
    DateTime currentDate = DateTime.now(); // วันที่ปัจจุบัน
    DateTime futureDate =
        currentDate.add(const Duration(days: 30)); // วันที่อีก 30 วัน

    // ใช้ DateFormat เพื่อจัดรูปแบบวันที่
    DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'th');
    String formattedDate = dateFormat.format(futureDate);

    return formattedDate; // คืนค่าผลลัพธ์
  }

  Row MenuDetailMemberShip(
      {required String header, required String subHeader}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          header,
          style: GoogleFonts.athiti(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subHeader,
          style: GoogleFonts.athiti(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class MonthHelper {
  static const List<String> _thaiMonths = [
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
    'ธันวาคม',
  ];

  static String getThaiMonth(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }
    return _thaiMonths[month - 1];
  }
}
