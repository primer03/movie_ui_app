import 'dart:convert';
import 'package:bloctest/bloc/novel/novel_bloc.dart';
import 'package:bloctest/bloc/user/user_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/widgets/InputForm.dart';
import 'package:bloctest/widgets/InputThem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<FocusNode> _focusNodes = List.generate(2, (_) => FocusNode());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    for (var node in _focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildUserBlocListener(),
                const SizedBox(height: 40),
                Image.asset('assets/images/logo_bookfet.jpg', width: 170),
                const SizedBox(height: 30),
                _buildLoginForm(),
                _buildForgotPasswordButton(),
                _buildLoginButton(),
                _buildRegisterPrompt(),
                _buildSocialLoginButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserBlocListener() {
    return BlocListener<UserBloc, UserState>(
      listener: (ctx, state) async {
        if (state is UserLoading) {
          showLoadingDialog(ctx);
        } else if (state is UserLoginSuccess) {
          _handleLoginSuccess(ctx, state);
        } else if (state is UserLoginFailed) {
          _handleLoginFailed(ctx, state);
        } else if (state is RegisterLoading) {
          showLoadingDialog(context);
        } else if (state is RegisterUserSuccess) {
          Navigator.pop(context);
          showToastification(
            context: ctx,
            message: 'สมัครสมาชิกสำเร็จ',
            type: ToastificationType.success,
          );
          Navigator.pop(context);
        } else if (state is RegisterUserFailed) {
          Navigator.pop(context);
          showToastification(
            context: ctx,
            message: state.message.split(' ')[2],
            type: ToastificationType.error,
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  Future<void> _handleLoginSuccess(
      BuildContext ctx, UserLoginSuccess state) async {
    showToastification(
      context: ctx,
      message: 'เข้าสู่ระบบสำเร็จ',
      type: ToastificationType.success,
    );
    novelBox.put('user', json.encode(state.user.toJson()));
    // add login type
    novelBox.put('loginType', 'normal');
    BlocProvider.of<NovelBloc>(context).add(FetchNovels());
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(ctx);
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
  }

  void _handleLoginFailed(BuildContext ctx, UserLoginFailed state) {
    Navigator.pop(context);
    showToastification(
      context: ctx,
      message: 'เข้าสู่ระบบล้มเหลว',
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      icon: Icon(Icons.error, color: Colors.red[800]),
    );
  }

  Widget _buildLoginForm() {
    return Form(
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
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
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
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(
        'เข้าสู่ระบบ',
        style: GoogleFonts.athiti(fontSize: 18, fontWeight: FontWeight.w800),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _focusNodes.forEach((node) => node.unfocus());
      BlocProvider.of<UserBloc>(context).add(
        LoginUser(
          email: _emailController.text,
          password: _passwordController.text,
          identifier: await getDevice(),
        ),
      );
    }
  }

  Widget _buildRegisterPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('ยังไม่มีบัญชี?',
            style: GoogleFonts.athiti(
                color: Colors.grey, fontWeight: FontWeight.w800)),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/register'),
          child: Text('สมัครสมาชิก',
              style: GoogleFonts.athiti(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildDivider(),
        const SizedBox(height: 20),
        BtnSocial(
            color: Colors.red.withOpacity(0.1),
            text: 'เข้าสู่ระบบด้วย Google   ',
            icon: 'assets/svg/Google.svg'),
        const SizedBox(height: 10),
        BtnSocial(
            color: const Color(0xFF06C755).withOpacity(0.1),
            text: 'เข้าสู่ระบบด้วย Line       ',
            icon: 'assets/svg/Line.svg'),
        const SizedBox(height: 10),
        BtnSocial(
            color: const Color(0xFF0866FF).withOpacity(0.1),
            text: 'เข้าสู่ระบบด้วย Facebook',
            icon: 'assets/svg/Facebook.svg'),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.grey, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('หรือ',
              style: GoogleFonts.athiti(
                  color: Colors.grey, fontWeight: FontWeight.w800)),
        ),
        const Expanded(child: Divider(color: Colors.grey, height: 1)),
      ],
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
