import 'package:bloctest/bloc/page/page_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/function/google_auth.dart';
import 'package:bloctest/function/line_auth.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/service/SocketService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
              onTap: () {},
            ),
            const SizedBox(height: 10),
            Listmeneuser(
              icon: SvgPicture.asset('assets/svg/Message.svg', width: 30),
              title: 'เปลี่ยนอีเมล',
              onTap: () {},
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
                // ลบข้อมูลจาก Hive
                // String token = novelBox.get('usertoken');
                disconnectSocket();
                final socialtype = await novelBox.get('socialType');
                if (socialtype != null) {
                  print('socialtype: $socialtype');
                  if (socialtype == 'line') {
                    await logoutLine();
                  } else if (socialtype == 'google') {
                    await signOut();
                  }
                }
                await deletePassword();
                // print(token);
                await novelBox.clear();

                // นำทางไปที่หน้าแรก
                // ignore: use_build_context_synchronously
                BlocProvider.of<PageBloc>(context)
                    .add(const PageChanged(tabIndex: 0));
                // BlocProvider.of<NovelBloc>(context).add(ResetNovels());
                // ignore: use_build_context_synchronously
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
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
