import 'package:bloctest/widgets/InputForm.dart';
import 'package:bloctest/widgets/InputThem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      onPressed: () {},
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Last Registration'),
      ),
      body: Center(
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
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
                child: _buildInputField(
                    _dateController, 'วันเดือนปีเกิด', Icons.calendar_today, 0),
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
  }
}
