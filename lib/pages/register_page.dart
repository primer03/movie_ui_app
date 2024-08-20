import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:bloctest/bloc/user/user_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/widgets/InputForm.dart';
import 'package:bloctest/widgets/InputThem.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  String _selectedGender = '';
  final List<String> gender = ['ชาย', 'หญิง'];

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildInputFields(),
                  const SizedBox(height: 40),
                  _buildRegisterButton(),
                  const SizedBox(height: 10),
                  _buildLoginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text('สมัครสมาชิก',
          style: GoogleFonts.athiti(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'กรอกข้อมูลเพื่อสมัครสมาชิก',
          style: GoogleFonts.athiti(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black54),
        ),
        const Divider(
            color: Colors.black, thickness: 2, indent: 10, endIndent: 10),
      ],
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        _buildInputField(_usernameController, 'ชื่อผู้ใช้', Icons.person, 0),
        const SizedBox(height: 20),
        _buildInputField(_emailController, 'อีเมล', Icons.email, 1),
        const SizedBox(height: 20),
        _buildInputField(_passwordController, 'รหัสผ่าน', Icons.lock, 2,
            isPassword: true),
        const SizedBox(height: 20),
        _buildInputField(
            _dateController, 'วันเดือนปีเกิด', Icons.calendar_today, 3),
        const SizedBox(height: 20),
        _buildGenderDropdown(),
      ],
    );
  }

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
      onPressed: _handleRegister,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text('สมัครสมาชิก',
          style: GoogleFonts.athiti(fontSize: 18, fontWeight: FontWeight.w800)),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('มีบัญชีอยู่แล้ว?',
            style: GoogleFonts.athiti(
                color: Colors.grey, fontWeight: FontWeight.w800)),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/login'),
          child: Text('เข้าสู่ระบบ',
              style: GoogleFonts.athiti(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<UserBloc>(context).add(
        RegisterUser(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          date: convertThaiDateToISO(_dateController.text),
          gender: _selectedGender,
        ),
      );
    }
  }
}
