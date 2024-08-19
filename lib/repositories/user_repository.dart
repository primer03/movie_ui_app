import 'dart:convert';
import 'dart:ffi';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/web.dart';

class UserRepository {
  final String url = 'https://pzfbh88v-3002.asse.devtunnels.ms/api/';
  final String apiKey = 'NGYyMDNlYmMtYjYyZi00OWMzLTg0NmItYThiZmI4NjhhYzUx';
  final String clientDomain = 'https://bookfet.com';
  Future<User> loginUser({
    required String email,
    required String password,
    required String identifier,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${url}login/member'),
        body: {'email': email, 'password': password, 'identifier': identifier},
        headers: {'x-api-key': apiKey, 'x-client-domain': clientDomain},
      );

      final res = json.decode(response.body);
      Logger().i(res);

      if (res['status'] == 'error') throw Exception(res['message']);

      final tokenData = res['message'] == 'กำลังเข้าสู่ระบบ โปรดรอสักครู่'
          ? json.decode(res['data'])['token']
          : json.decode(res['data'])['token'];

      final decodedToken = JwtDecoder.decode(tokenData);
      Logger().i(decodedToken);

      novelBox.put('usertoken', tokenData);
      savePassword(password);
      return User.fromJson(decodedToken);
    } catch (e) {
      print('error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<bool> registerUser({
    required String username,
    required String email,
    required String password,
    required String date,
    required String gender,
  }) async {
    final urlx = Uri.parse('${url}create/member');
    final genderCode = gender == 'ชาย' ? 'm' : 'f';

    try {
      print('username: $username');
      print('email: $email');
      print('password: $password');
      print('date: $date');
      print('gender: $gender');
      final response = await http.post(
        urlx,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          "username": username,
          "email": email,
          "password": password,
          "birthday": date,
          "gender": genderCode,
        },
      );

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        Logger().i(res);

        if (res['status'] == 'error') {
          throw Exception(res['message']);
        }
        return true;
      } else {
        final res = json.decode(response.body);
        throw Exception(res['message'] ?? 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      Logger().e('Error during user registration', error: e);
      throw Exception(e.toString());
    }
  }

  // Future<void> createUser({required String name, required String email}) async {
  //   _users.add(User(id: DateTime.now().toString(), name: name, email: email));
  // }

  // Future<void> updateUser(User user) async {
  //   final index = _users.indexWhere((element) => element.id == user.id);
  //   _users[index] = user;
  // }

  // Future<void> deleteUser(User user) async {
  //   _users.removeWhere((element) => element.id == user.id);
  // }

  // Future<List<User>> getUsers() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   return _users;
  // }

  // Future<List<User>> searchUsers(String query) async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   final result = _users
  //       .where((element) =>
  //           element.name.toLowerCase().contains(query.toLowerCase()) ||
  //           element.email.toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  //   return result;
  // }
}
