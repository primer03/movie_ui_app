import 'dart:io';
import 'dart:math';

import 'package:bloctest/bloc/lineauth/lineauth_bloc.dart';
import 'package:bloctest/bloc/novel/novel_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/widgets/InputForm.dart';
import 'package:bloctest/widgets/InputThem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class SocialLastRegis extends StatefulWidget {
  String displayName;
  String email;
  String imgUrl;
  String userId;
  SocialLastRegis({
    super.key,
    required this.displayName,
    required this.email,
    required this.imgUrl,
    required this.userId,
  });

  @override
  State<SocialLastRegis> createState() => _SocialLastRegisState();
}

class _SocialLastRegisState extends State<SocialLastRegis> {
  final _formKey = GlobalKey<FormState>();
  final List<FocusNode> _focusNodes = List.generate(2, (_) => FocusNode());
  final TextEditingController _dateController = TextEditingController();
  String _selectedGender = '';
  final List<String> gender = ['ชาย', 'หญิง'];

  Widget _buildInputField(TextEditingController controller, String label,
      IconData icon, int focusIndex,
      {bool isPassword = false}) {
    return InputThem(
      child: InputForm(
        controller: controller,
        focusNode: _focusNodes[focusIndex],
        hintText: label,
        labelText: label,
        prefixIcon: Icon(icon),
        isPassword: isPassword,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField2<String>(
      decoration: InputDecoration(
        errorStyle:
            GoogleFonts.athiti(color: Colors.red, fontWeight: FontWeight.w800),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(15)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
      hint: Text('เพศ',
          style: GoogleFonts.athiti(
              color: Colors.grey, fontWeight: FontWeight.w800)),
      items: gender
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item,
                    style: GoogleFonts.athiti(
                        color: Colors.black, fontWeight: FontWeight.w800)),
              ))
          .toList(),
      validator: (value) => value == null ? '   กรุณาเลือกเพศ' : null,
      onChanged: (value) => setState(() => _selectedGender = value!),
      buttonStyleData:
          const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
      iconStyleData: const IconStyleData(
          icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
          iconSize: 24),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3))
          ],
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16)),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        // print('Date: ${convertThaiDateToISO(_dateController.text)}');
        // print('selectedGender: $_selectedGender');
        if (_formKey.currentState!.validate()) {
          final enteredDate = convertThaiDateToISO(_dateController.text);
          final currentDate = DateTime.now();
          if (DateTime.parse(enteredDate).isAfter(currentDate)) {
            showToastification(
              context: context,
              message: 'วันเกิดต้องไม่เกินวันปัจจุบัน',
              type: ToastificationType.error,
              style: ToastificationStyle.minimal,
            );
          } else {
            print('Date: $enteredDate');
            // Proceed with form submission
            BlocProvider.of<LineauthBloc>(context).add(LineauthLogin(
              username: widget.displayName,
              email: widget.email,
              password: '',
              brithday: _dateController.text,
              gender: _selectedGender,
              imgUrl: widget.imgUrl,
            ));
          }
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return SocialLastRegis(
          //     displayName: widget.displayName,
          //     email: widget.email,
          //     imgUrl: widget.imgUrl,
          //     userId: widget.userId,
          //   );
          // }));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text('ยืนยันข้อมูล',
          style: GoogleFonts.athiti(fontSize: 18, fontWeight: FontWeight.w800)),
    );
  }

  @override
  void initState() {
    print(widget.displayName);
    print(widget.email);
    print(widget.imgUrl);
    print(widget.userId);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<LineauthBloc, LineauthState>(
          listener: (context, state) async {
        // Handle state changes here, e.g., show snackbars, navigate, etc.
        if (state is LineauthFailure) {
          Navigator.pop(context);
          showToastification(
            context: context,
            message: state.message,
            type: ToastificationType.error,
            style: ToastificationStyle.minimal,
          );
        } else if (state is LineauthSuccess) {
          showToastification(
            context: context,
            message: state.message,
            type: ToastificationType.success,
            style: ToastificationStyle.minimal,
          );
          await novelBox.put('loginsocial', true);
          // BlocProvider.of<NovelBloc>(context).add(FetchNovels());
          // await Future.delayed(const Duration(seconds: 2));
          Navigator.pop(context);
          // await Future.delayed(const Duration(milliseconds: 500));
          // Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
          // showToastification(
          //   context: context,
          //   message: state.message,
          //   type: ToastificationType.success,
          //   style: ToastificationStyle.minimal,
          // );
          // Navigate to next screen or show success message
        } else if (state is LineauthLoading) {
          showLoadingDialog(context);
        }
      }, builder: (context, state) {
        return Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ขั้นตอนสุดท้าย เพื่อให้การสมัครสมบูรณ์แบบ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.athiti(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CachedNetworkImage(
                    imageUrl: 'https://serverimges.bookfet.com/mascot/1.png',
                    width: 300,
                    placeholder: (context, url) => const SizedBox(
                      width: 300,
                      height: 300,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  // Image.file(
                  //   File(widget.imgUrl),
                  //   width: 300,
                  //   height: 300,
                  // ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'วันเดือนปี เกิด',
                      style: GoogleFonts.athiti(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '(อายุต่ำกว่า 18 ปี ไม่สามารถอ่านนิยาย NC ได้)',
                      style: GoogleFonts.athiti(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildInputField(_dateController, 'วันเดือนปีเกิด',
                        Icons.calendar_today, 0),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'เพศ',
                      style: GoogleFonts.athiti(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildGenderDropdown(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildRegisterButton(),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
