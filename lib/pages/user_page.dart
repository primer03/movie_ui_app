import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/service/BookmarkManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
              onTap: () {
                Navigator.pushNamed(context, '/profile');
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
              onTap: () {},
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
              onTap: () {},
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
                await logoutAll(context);
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
