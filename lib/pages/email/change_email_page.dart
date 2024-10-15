import 'dart:convert';

import 'package:bloctest/bloc/changeemail/changeemail_bloc.dart';
import 'package:bloctest/bloc/user/user_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:bloctest/repositories/user_repository.dart';
import 'package:bloctest/widgets/InputForm.dart';
import 'package:bloctest/widgets/InputThem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

// ส่วนที่เหลือเหมือนเดิม

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode newEmailFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getOldEmail();
  }

  Future<void> getOldEmail() async {
    try {
      User user = User.fromJson(json.decode(await novelBox.get('user')));
      emailController.text = user.detail.email;
    } catch (e) {
      showToastification(
        context: context,
        message: 'ไม่สามารถดึงข้อมูลได้',
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
      );
      Navigator.pop(context);
    }
  }

  Widget _buildEmailInput({
    required String hintText,
    required String labelText,
    required TextEditingController controller,
    required FocusNode focusNode,
    bool readOnly = false,
  }) {
    return InputThem(
      child: InputForm(
        controller: controller,
        focusNode: focusNode,
        hintText: hintText,
        labelText: labelText,
        readOnly: readOnly,
        prefixIcon: const Icon(Icons.email),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    newEmailController.dispose();
    emailFocusNode.dispose();
    newEmailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เปลี่ยนอีเมล',
          style: GoogleFonts.athiti(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<ChangeemailBloc, ChangeemailState>(
        listener: (context, state) async {
          if (state is ChangeemailSuccess) {
            Navigator.pop(context);
            showToastification(
              context: context,
              message: 'เปลี่ยนอีเมลสำเร็จ',
              type: ToastificationType.success,
              style: ToastificationStyle.minimal,
            );
            logoutAll(context);
          } else if (state is ChangeemailFailure) {
            Navigator.pop(context);
            showToastification(
              context: context,
              message: state.error.split('Exception: ').last,
              type: ToastificationType.error,
              style: ToastificationStyle.minimal,
            );
          } else if (state is ChangeemailLoading) {
            showLoadingDialog(context);
          } else if (state is ChangeemailInitial) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildEmailInput(
                      hintText: 'อีเมล',
                      labelText: 'อีเมล',
                      controller: emailController,
                      focusNode: emailFocusNode,
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    _buildEmailInput(
                      hintText: 'อีเมลใหม่',
                      labelText: 'อีเมลใหม่',
                      controller: newEmailController,
                      focusNode: newEmailFocusNode,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ChangeemailBloc>().add(
                                ChangeEmail(
                                  oldEmail: emailController.text,
                                  newEmail: newEmailController.text,
                                ),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'ยืนยัน',
                        style: GoogleFonts.athiti(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
