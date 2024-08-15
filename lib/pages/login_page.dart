import 'package:bloctest/widgets/InputForm.dart';
import 'package:bloctest/widgets/InputThem.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];
  final List<Color> _labelColors = [Colors.grey, Colors.grey];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _focusNodes.forEach((element) {
      element.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNodes.forEach((element) {
      element.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // สีของ status bar
      statusBarIconBrightness: Brightness.dark, // สี icon ของ status bar
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/logo_bookfet.jpg',
                  width: 170,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              InputThem(
                                child: InputForm(
                                  controller: _emailController,
                                  focusNode: _focusNodes[0],
                                  hintText: 'อีเมลที่สมัคร',
                                  labelText: 'อีเมล',
                                  prefixIcon: const Icon(Icons.email),
                                ),
                              ),
                              const SizedBox(height: 30),
                              InputThem(
                                child: InputForm(
                                  controller: _passwordController,
                                  focusNode: _focusNodes[1],
                                  prefixIcon: const Icon(Icons.lock),
                                  hintText: 'รหัสผ่าน',
                                  labelText: 'รหัสผ่าน',
                                  isPassword: true,
                                  showPassword: false,
                                ),
                              ),
                            ],
                          )),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            overlayColor: Colors.grey.withOpacity(0.1),
                          ),
                          child: Text(
                            'ลืมรหัสผ่าน?',
                            style: GoogleFonts.athiti(
                              color: Colors.grey,
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print('เข้าสู่ระบบ');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'เข้าสู่ระบบ',
                          style: GoogleFonts.athiti(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ยังไม่มีบัญชี?',
                            style: GoogleFonts.athiti(
                              color: Colors.grey,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () async {
                              // Navigator.pushNamed(context, '/register');
                              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                              AndroidDeviceInfo androidInfo =
                                  await deviceInfo.androidInfo;
                              // print('Running on ${androidInfo.product}');
                              Logger().i(androidInfo.model);
                            },
                            child: Text(
                              'สมัครสมาชิก',
                              style: GoogleFonts.athiti(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'หรือ',
                            style: GoogleFonts.athiti(
                              color: Colors.grey,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Divider(
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      BtnSocial(
                        color: Colors.red.withOpacity(0.1),
                        text: 'เข้าสู่ระบบด้วย Google   ',
                        icon: 'assets/svg/Google.svg',
                      ),
                      const SizedBox(height: 10),
                      BtnSocial(
                        color: const Color(0xFF06C755).withOpacity(0.1),
                        text: 'เข้าสู่ระบบด้วย Line       ',
                        icon: 'assets/svg/Line.svg',
                      ),
                      const SizedBox(height: 10),
                      BtnSocial(
                        color: const Color(0xFF0866FF).withOpacity(0.1),
                        text: 'เข้าสู่ระบบด้วย Facebook',
                        icon: 'assets/svg/Facebook.svg',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BtnSocial extends StatelessWidget {
  const BtnSocial({
    super.key,
    required this.color,
    required this.text,
    required this.icon,
  });
  final Color color;
  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 50),
        overlayColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        side: const BorderSide(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 25,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.athiti(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
