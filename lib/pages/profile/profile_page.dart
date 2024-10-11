import 'dart:convert';
import 'dart:io';

import 'package:bloctest/bloc/user/user_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:bloctest/repositories/user_repository.dart';
import 'package:bloctest/widgets/InputForm.dart';
import 'package:bloctest/widgets/InputThem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<FocusNode> _focusNodes = List.generate(7, (_) => FocusNode());
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  String _selectedGender = '';
  final _formKey = GlobalKey<FormState>();
  final List<String> gender = ['ชาย', 'หญิง'];
  final picker = ImagePicker();
  String userImage = '';
  File? _image;
  var now = DateTime.now();

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // ทำการครอบภาพ
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        compressFormat: ImageCompressFormat.png,
        uiSettings: [
          AndroidUiSettings(
            // cropStyle: CropStyle.circle,
            toolbarTitle: 'ปรับขนาดภาพ',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.white,

            // hideBottomControls: true,
            // backgroundColor: Colors.red,
            // lockAspectRatio: false,
            initAspectRatio: CropAspectRatioPreset.values[1],
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio16x9,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.values[1],
            ],
          ),
          IOSUiSettings(
            // resetAspectRatioEnabled: true, //
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );
      try {
        showLoadingDialog(context);
        UserRepository repository = UserRepository();
        await repository.updateImageUser(
            image: File(croppedFile!.path), type: 'profile');
        final loginsocial = await novelBox.get('loginsocial');
        context.read<UserBloc>().add(LoadProfile(
              user: User.fromJson(jsonDecode(novelBox.get('user'))),
              password: await getPassword(),
              type: loginsocial != null ? 'social' : 'normal',
            ));
        setState(() {
          if (croppedFile != null) {
            _image = File(croppedFile.path);
            print('Cropped image path: ${_image!.path}');
          } else {
            print('No image selected.');
          }
        });
      } catch (e) {
        showToastification(
          context: context,
          message: 'เกิดข้อผิดพลาด',
          type: ToastificationType.error,
          style: ToastificationStyle.minimal,
        );
      }
    } else {
      print('No image selected.');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUser();
    });
  }

  void getUser() async {
    showLoadingDialog(context);
    final userstr = novelBox.get('user');
    print(userstr);
    final user = User.fromJson(jsonDecode(userstr));
    final password = await getPassword();
    final loginsocial = await novelBox.get('loginsocial');
    print('loginsocial: $loginsocial');
    BlocProvider.of<UserBloc>(context).add(
      LoadProfile(
          user: user,
          password: password,
          type: loginsocial != null ? 'social' : 'normal'),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          'แก้ไขข้อมูลผู้ใช้',
          style: GoogleFonts.athiti(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoadedProfile) {
            Navigator.pop(context);
            setState(() {
              _selectedGender = state.user.detail.gender.toLowerCase() == 'm'
                  ? 'ชาย'
                  : 'หญิง';
              _usernameController.text = state.user.username;
              _dateController.text = convertISOToThaiDate(
                state.user.detail.birthdayDate.toString().substring(0, 10),
              );
              _phoneController.text = state.user.detail.phone ?? '';
              _addressController.text = state.user.detail.address ?? '';
              _facebookController.text = state.user.detail.fbLink ?? '';
              _twitterController.text = state.user.detail.twitterLink ?? '';
              userImage = state.user.img;
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildUserImageSection(),
                const SizedBox(height: 20),
                _buildInputField(
                  _usernameController,
                  'ชื่อผู้ใช้',
                  const Icon(Icons.person),
                  0,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  _dateController,
                  'วันเดือนปีเกิด',
                  const Icon(Icons.calendar_today),
                  1,
                ),
                const SizedBox(height: 20),
                _buildGenderDropdown(),
                const SizedBox(height: 20),
                _buildInputField(
                  _phoneController,
                  'เบอร์โทรศัพท์',
                  const Icon(Icons.phone),
                  2,
                  isEmptyValue: true,
                ),
                const SizedBox(height: 20),
                _buildAddressField(3),
                const SizedBox(height: 20),
                _buildInputField(
                  _facebookController,
                  'ลิงก์ Facebook',
                  SvgPicture.asset(
                    'assets/svg/icons8-facebook.svg',
                    width: 30,
                  ),
                  5,
                  isEmptyValue: true,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  _twitterController,
                  'ลิงก์ Twitter X',
                  SvgPicture.asset(
                    'assets/svg/icons8-twitterx.svg',
                    width: 25,
                  ),
                  6,
                  isEmptyValue: true,
                ),
                const SizedBox(height: 20),
                _buildSaveButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserImageSection() {
    return Stack(
      children: [
        Container(
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 1,
                offset: const Offset(2, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.white,
            elevation: 2,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              splashColor: Colors.black.withOpacity(0.5),
              splashFactory: InkRipple.splashFactory,
              onTap: () {
                _getImage();
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  // ใช้ ClipOval เพื่อทำให้รูปภาพเป็นวงกลม
                  child: _image != null
                      ? Image.file(
                          _image!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        )
                      : userImage.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: userImage +
                                  '?time=${now.millisecondsSinceEpoch}',
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              'https://www.pngkey.com/png/full/114-1149878_setting-user-avatar-in-specific-size-without-breaking.png',
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 2,
          right: 3,
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              splashColor: Colors.red.withOpacity(0.5),
              splashFactory: InkRipple.splashFactory,
              onTap: () {
                print('Change profile picture');
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField2<String>(
      value: _selectedGender == '' ? null : _selectedGender,
      decoration: InputDecoration(
        prefixIconConstraints: const BoxConstraints(minWidth: 30),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 15),
            SvgPicture.asset(
              'assets/svg/gender.svg',
              width: 25,
            ),
          ],
        ),
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
      onChanged: (value) => {
        setState(() {
          print(value);
          _selectedGender = value!;
        })
      },
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

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          print('Submit');
          for (var i = 0; i < _focusNodes.length; i++) {
            _focusNodes[i].unfocus();
          }
          showLoadingDialog(context);
          try {
            print('${_selectedGender}');
            UserRepository repository = UserRepository();
            bool check = await repository.updateProfileUser(
              username: _usernameController.text,
              date: _dateController.text,
              gender: _selectedGender,
              phone: _phoneController.text,
              address: _addressController.text,
              FB: _facebookController.text,
              twitter: _twitterController.text,
            );
            if (check) {
              final userstr = novelBox.get('user');
              print(userstr);
              final user = User.fromJson(jsonDecode(userstr));
              final password = await getPassword();
              final loginsocial = await novelBox.get('loginsocial');

              BlocProvider.of<UserBloc>(context).add(
                LoadProfile(
                  user: user,
                  password: password,
                  type: loginsocial != null ? 'social' : 'normal',
                ),
              );
              print('Update profile success');
              showToastification(
                context: context,
                message: 'อัพเดทข้อมูลสำเร็จ',
                type: ToastificationType.success,
                style: ToastificationStyle.minimal,
              );
            } else {
              print('Update profile fail');
              showToastification(
                context: context,
                message: 'อัพเดทข้อมูลไม่สำเร็จ',
                type: ToastificationType.error,
                style: ToastificationStyle.minimal,
              );
            }
          } catch (e) {
            showToastification(
              context: context,
              message: 'เกิดข้อผิดพลาด',
              type: ToastificationType.error,
              style: ToastificationStyle.minimal,
            );
            print('Error: $e');
          }
        }
      },
      child: Text(
        'บันทึก',
        style: GoogleFonts.athiti(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        minimumSize: const Size(double.infinity, 50),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
    );
  }

  Widget _buildAddressField(int focusIndex) {
    return InputThem(
      child: TextFormField(
        focusNode: _focusNodes[focusIndex],
        controller: _addressController,
        minLines: 4,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        cursorColor: Colors.black,
        style: GoogleFonts.athiti(
          color: Colors.black,
          fontWeight: FontWeight.w800,
        ),
        decoration: InputDecoration(
          hintText: 'ที่อยู่ในการรับของขวัญ',
          hintStyle: GoogleFonts.athiti(
            color: Colors.grey,
            fontWeight: FontWeight.w800,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          errorStyle: GoogleFonts.athiti(
            color: Colors.red,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label,
      Widget icon, int focusIndex,
      {bool isPassword = false, int maxLines = 1, bool isEmptyValue = false}) {
    return InputThem(
      child: InputForm(
        controller: controller,
        focusNode: _focusNodes[focusIndex],
        hintText: label,
        labelText: label,
        prefixIcon: icon,
        isPassword: isPassword,
        maxLines: maxLines,
        isEmptyValue: isEmptyValue,
      ),
    );
  }
}
