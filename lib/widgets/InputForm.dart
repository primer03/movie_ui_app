import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class InputForm extends StatefulWidget {
  const InputForm({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    this.isPassword = false,
    this.showPassword = false,
    this.onShowPassword,
    this.maxLines = 1,
    this.isEmptyValue = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final String labelText;
  final Widget prefixIcon;
  final bool isPassword;
  final bool showPassword;
  final VoidCallback? onShowPassword;
  final int maxLines;
  final bool isEmptyValue;

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  late FocusNode _focusNode;
  late bool _showPassword;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode;
    _focusNode.addListener(_onFocusChange);
    _showPassword = widget.showPassword;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
      if (widget.onShowPassword != null) {
        widget.onShowPassword!();
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      cancelText: 'ยกเลิก',
      confirmText: 'ตกลง',
      helpText: 'เลือกวันเกิด',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                textStyle: GoogleFonts.athiti(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            textTheme: TextTheme(
              bodyMedium: GoogleFonts.athiti(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              bodyLarge: GoogleFonts.athiti(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              bodySmall: GoogleFonts.athiti(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              labelMedium: GoogleFonts.athiti(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              titleMedium: GoogleFonts.athiti(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        String thaiDate = _formatThaiDate(value);
        widget.controller.text = thaiDate;
        _focusNode.unfocus();
      }
    });
  }

  String _formatThaiDate(DateTime date) {
    List<String> thaiMonths = [
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
      'ธันวาคม'
    ];

    int thaiYear = date.year + 543; // Convert to Buddhist Era
    String thaiMonth = thaiMonths[date.month - 1];
    String thaiDay = date.day.toString();
    print(date.toString().substring(0, 10).split('-').reversed.join('/'));
    return '$thaiDay $thaiMonth $thaiYear';
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: _focusNode,
      cursorColor: Colors.black,
      obscureText: widget.isPassword && !_showPassword,
      keyboardType: widget.labelText == 'อีเมล'
          ? TextInputType.emailAddress
          : widget.labelText == 'เบอร์โทรศัพท์'
              ? TextInputType.phone
              : widget.labelText.contains('ลิงก์')
                  ? TextInputType.url
                  : TextInputType.text,
      validator: !widget.isEmptyValue
          ? (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกข้อมูล';
              }
              if (widget.labelText == 'อีเมล') {
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'รูปแบบอีเมลล์ไม่ถูกต้อง';
                }
              }
              if (widget.labelText == 'ชื่อผู้ใช้') {
                if (!RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(value)) {
                  return 'ชื่อผู้ใช้ต้องมีความยาว 3-20 ตัวอักษร';
                }
              }

              return null;
            }
          : (value) {
              if (widget.labelText.contains('ลิงก์')) {
                if (value!.isNotEmpty) {
                  if (!RegExp(r'^http[s]?://').hasMatch(value)) {
                    return 'ลิงก์ต้องขึ้นต้นด้วย http:// หรือ https://';
                  }
                }
              }
              return null;
            },
      style: GoogleFonts.athiti(
        color: Colors.black,
        fontWeight: FontWeight.w800,
      ),
      onTap: widget.labelText == 'วันเดือนปีเกิด'
          ? () => _selectDate(context)
          : null,
      readOnly: widget.labelText == 'วันเดือนปีเกิด',
      decoration: InputDecoration(
        prefixIconConstraints: const BoxConstraints(
          minWidth: 50,
        ),
        errorStyle: GoogleFonts.athiti(
          color: Colors.red,
          fontWeight: FontWeight.w800,
        ),
        hintText: widget.hintText,
        hintStyle: GoogleFonts.athiti(
          color: Colors.grey,
          fontWeight: FontWeight.w800,
        ),
        labelText: widget.labelText,
        labelStyle: GoogleFonts.athiti(
          color: _focusNode.hasFocus ? Colors.black : Colors.grey,
          fontWeight: FontWeight.w800,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: _togglePasswordVisibility,
                icon: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              )
            : null,
      ),
    );
  }
}
