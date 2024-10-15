import 'package:bloctest/bloc/changepassword/changepassword_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/widgets/InputForm.dart';
import 'package:bloctest/widgets/InputThem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode oldPasswordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  Widget _buildPasswordInput({
    required String hintText,
    required String labelText,
    required TextEditingController controller,
    required FocusNode focusNode,
    bool isCheckPassword = true,
  }) {
    return InputThem(
      child: InputForm(
        controller: controller,
        focusNode: focusNode,
        hintText: hintText,
        labelText: labelText,
        prefixIcon: const Icon(Icons.lock),
        isPassword: true,
        isCheckPassword: isCheckPassword,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เปลี่ยนรหัสผ่าน',
          style: GoogleFonts.athiti(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPasswordInput(
                  hintText: 'รหัสผ่านเดิม',
                  labelText: 'รหัสผ่านเดิม',
                  controller: oldPasswordController,
                  focusNode: oldPasswordFocusNode,
                  isCheckPassword: false,
                ),
                const SizedBox(height: 20),
                _buildPasswordInput(
                  hintText: 'รหัสผ่านใหม่',
                  labelText: 'รหัสผ่านใหม่',
                  controller: newPasswordController,
                  focusNode: newPasswordFocusNode,
                ),
                const SizedBox(height: 20),
                _buildPasswordInput(
                  hintText: 'ยืนยันรหัสผ่านใหม่',
                  labelText: 'ยืนยันรหัสผ่านใหม่',
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFocusNode,
                ),
                const SizedBox(height: 20),
                BlocConsumer<ChangepasswordBloc, ChangepasswordState>(
                  listener: (context, state) {
                    if (state is ChangepasswordSuccess) {
                      Navigator.pop(context);
                      savePassword(newPasswordController.text);
                      showToastification(
                        context: context,
                        message: 'เปลี่ยนรหัสผ่านสำเร็จ',
                        type: ToastificationType.success,
                        style: ToastificationStyle.minimal,
                      );
                      Navigator.pop(context);
                    } else if (state is ChangepasswordFailure) {
                      Navigator.pop(context);
                      showToastification(
                        context: context,
                        message: state.error.split('Exception: ').last,
                        type: ToastificationType.error,
                        style: ToastificationStyle.minimal,
                      );
                    } else if (state is ChangepasswordLoading) {
                      showLoadingDialog(context);
                    } else if (state is ChangepasswordInitial) {
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (newPasswordController.text !=
                              confirmPasswordController.text) {
                            showToastification(
                              context: context,
                              message: 'รหัสผ่านไม่ตรงกัน',
                              type: ToastificationType.error,
                              style: ToastificationStyle.minimal,
                            );
                          } else {
                            context.read<ChangepasswordBloc>().add(
                                  ChangePassword(
                                    oldPassword: oldPasswordController.text,
                                    newPassword: newPasswordController.text,
                                  ),
                                );
                          }
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
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
