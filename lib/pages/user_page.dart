import 'dart:async';
import 'dart:convert';

import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:bloctest/pages/test_comment.dart';
import 'package:bloctest/repositories/user_repository.dart';
import 'package:bloctest/service/BookmarkManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:logger/web.dart';
import 'package:onepref/onepref.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final Uri _url = Uri.parse('https://bookfet.com/');

  Future<void> _launchUrl() async {
    if (await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      novelBox.put('openWebview', true);
      Logger().i('Launched $_url');
    } else {
      throw 'Could not launch $_url';
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
      return {'message': 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง'};
    }
  }

  void showNotiLauhUrl() async {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              // height: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              padding: const EdgeInsets.fromLTRB(20, 55, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'สมัครสมาชิก VIP ผ่านเว็บไซต์เท่านั้น เสร็จแล้วออกจากระบบและเข้าสู่ระบบใหม่เพื่อเริ่มใช้งาน VIP!',
                      style: GoogleFonts.athiti(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await _launchUrl();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // สีปุ่ม
                          overlayColor: Colors.white,
                          splashFactory: InkRipple.splashFactory,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'เข้าสู่เว็บไซต์',
                            style: GoogleFonts.athiti(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // สีตัวอักษร
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          overlayColor: Colors.white,
                          splashFactory: InkRipple.splashFactory,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'ปิด',
                            style: GoogleFonts.athiti(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // สีตัวอักษร
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
                top: 170,
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
                ))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'บัญชีของฉัน',
              style: GoogleFonts.athiti(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Listmeneuser(
              icon: SvgPicture.asset('assets/svg/User.svg', width: 30),
              title: 'ข้อมูลผู้ใช้',
              onTap: () async {
                showLoadingDialog(context);
                UserRepository userRepository = UserRepository();
                final isLoginSocial = await novelBox.get('loginsocial');
                if (isLoginSocial != null) {
                  print(isLoginSocial);
                  final userstr = novelBox.get('user');
                  print(userstr);
                  final user = User.fromJson(jsonDecode(userstr));
                  Navigator.of(context).pop();
                  if (isLoginSocial) {
                    try {
                      bool? checkSocial = await userRepository.registersocial(
                          username: user.username,
                          email: user.detail.email,
                          identifier: await getDevice(),
                          firstRegis: false);
                      if (checkSocial) {
                        Navigator.pushNamed(context, '/profile');
                      }
                    } catch (e) {
                      final errorMessage = _parseErrorMessage(e);
                      if (errorMessage['message'] ==
                          'มีการล็อคอินซ้อนอยู่ในเบาว์เซอร์อื่น') {
                        showToastification(
                          context: context,
                          message: 'มีการล็อคอินซ้อนอยู่ในเบาว์เซอร์อื่น',
                          type: ToastificationType.error,
                          style: ToastificationStyle.minimal,
                        );
                        await logoutAll(context);
                      }
                    }
                  }
                } else {
                  try {
                    final userstr = novelBox.get('user');
                    print(userstr);
                    final user = User.fromJson(jsonDecode(userstr));
                    final password = await getPassword();
                    final check = await userRepository.loginUserCheck(
                      email: user.detail.email,
                      identifier: await getDevice(),
                      password: password ?? '',
                    );
                    if (check) {
                      Navigator.of(context).pop();
                      await Future.delayed(const Duration(milliseconds: 500));
                      Navigator.pushNamed(context, '/profile');
                    } else {
                      Navigator.of(context).pop();
                      await logoutAll(context);
                    }
                  } catch (e) {
                    Navigator.of(context).pop();
                    final errorMessage = _parseErrorMessage(e);
                    if (errorMessage['message'] ==
                        'มีการล็อคอินซ้อนอยู่ในเบาว์เซอร์อื่น') {
                      showToastification(
                        context: context,
                        message: 'มีการล็อคอินซ้อนอยู่ในเบาว์เซอร์อื่น',
                        type: ToastificationType.error,
                        style: ToastificationStyle.minimal,
                      );
                      await logoutAll(context);
                    }
                  }
                }
              },
            ),
            const SizedBox(height: 10),
            Listmeneuser(
              icon: SvgPicture.asset('assets/svg/Lock.svg', width: 30),
              title: 'เปลี่ยนรหัสผ่าน',
              onTap: () async {
                bool? isLoginSocial = await novelBox.get('loginsocial');
                if (isLoginSocial != null) {
                  if (isLoginSocial) {
                    BookmarkManager(context, (bool checkAdd) {}).showToast(
                        'ไม่สามารถเปลี่ยนรหัสผ่านได้',
                        gravity: ToastGravity.CENTER);
                  } else {
                    Navigator.pushNamed(context, '/changePassword');
                  }
                } else {
                  Navigator.pushNamed(context, '/changePassword');
                }
              },
            ),
            const SizedBox(height: 10),
            Listmeneuser(
              icon: SvgPicture.asset('assets/svg/Message.svg', width: 30),
              title: 'เปลี่ยนอีเมล',
              onTap: () async {
                // print(await novelBox.get('loginsocial'));
                // if (await novelBox.get('loginsocial')) {
                //   BookmarkManager(context, (bool checkAdd) {}).showToast(
                //       'ไม่สามารถเปลี่ยนอีเมลได้',
                //       gravity: ToastGravity.CENTER);
                // } else {
                //   Navigator.pushNamed(context, '/changeemail');
                // }
                bool? isLoginSocial = await novelBox.get('loginsocial');
                if (isLoginSocial != null) {
                  if (isLoginSocial) {
                    BookmarkManager(context, (bool checkAdd) {}).showToast(
                        'ไม่สามารถเปลี่ยนอีเมลได้',
                        gravity: ToastGravity.CENTER);
                  } else {
                    Navigator.pushNamed(context, '/changeEmail');
                  }
                } else {
                  Navigator.pushNamed(context, '/changeEmail');
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              'สมาชิก VIP',
              style: GoogleFonts.athiti(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Listmeneuser(
              icon: SvgPicture.asset('assets/svg/vip-87.svg', width: 30),
              title: 'แก้ไขข้อมูลสมาชิก VIP',
              onTap: () {},
            ),
            const SizedBox(height: 10),
            Listmeneuser(
              icon: SvgPicture.asset(
                'assets/svg/vip-70.svg',
                width: 30,
                color: Colors.grey[800],
              ),
              title: 'สมัครสมาชิก VIP',
              onTap: () async {
                // buy();
                // Navigator.pushNamed(context, '/membership');
                // await _launchUrl();
                showNotiLauhUrl();
              },
            ),
            const SizedBox(height: 20),
            Text(
              'การแชร์',
              style: GoogleFonts.athiti(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Listmeneuser(
              icon: SvgPicture.asset('assets/svg/Group_duotone.svg', width: 30),
              title: 'เชิญเพื่อน',
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: TestComment()));
              },
            ),
            const SizedBox(height: 20),
            Text(
              'ตั้งค่า',
              style: GoogleFonts.athiti(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Listmeneuser(
              icon: SvgPicture.asset('assets/svg/Sign_out_squre_duotone@3x.svg',
                  width: 30),
              title: 'ออกจากระบบ',
              onTap: () async {
                await logoutAll(context, uniqlog: true);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Listmeneuser extends StatelessWidget {
  final SvgPicture icon;
  final String title;
  final Function()? onTap;
  const Listmeneuser({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        splashColor: Colors.black.withOpacity(0.1),
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        title: Text(
          title,
          style: GoogleFonts.athiti(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: icon,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
