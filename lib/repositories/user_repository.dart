import 'dart:convert';
import 'dart:io';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/web.dart';
import 'package:path/path.dart' as path;

class UserRepository {
  final String url = 'https://pzfbh88v-3004.asse.devtunnels.ms/api/';
  final String apiKey = 'NGYyMDNlYmMtYjYyZi00OWMzLTg0NmItYThiZmI4NjhhYzUx';
  final String clientDomain = 'https://bookfet.com';

  Future<User> loginUser({
    required String email,
    required String password,
    required String identifier,
  }) async {
    try {
      print('email: $email');
      print('password: $password');
      print('identifier: $identifier');
      final response = await http.post(
        Uri.parse('${url}login/member'),
        body: {'email': email, 'password': password, 'identifier': identifier},
        headers: {'x-api-key': apiKey, 'x-client-domain': clientDomain},
      );

      if (response.statusCode != 200) {
        print('error: ${response.statusCode}');
      }

      final res = json.decode(response.body);
      Logger().i(res);

      if (res['status'] == 'error') {
        throw Exception({'message': res['message'], 'olddevice': null});
      }

      print('datatype: ${res['data'].runtimeType}');
      final tokenData;
      if (res['message'] == 'กำลังเข้าสู่ระบบ โปรดรอสักครู่') {
        if (res['data'].runtimeType == String) {
          tokenData = json.decode(res['data'])['token'];
        } else {
          tokenData = res['data']['token'];
        }
      } else {
        if (res['data'].runtimeType == String) {
          tokenData = json.decode(res['data'])['token'];
        } else {
          tokenData = res['data']['token'];
        }
      }

      final decodedToken = JwtDecoder.decode(tokenData);
      Logger().i(tokenData);
      Logger().i(decodedToken);
      if (res['message'] == 'มีการล็อคอินซ้อนอยู่ในเบาว์เซอร์อื่น') {
        String olddevice = '';
        await novelBox.put(
            'useroverlap', json.encode(User.fromJson(decodedToken).toJson()));
        await novelBox.put('usertoken', tokenData);
        if (res['data'].runtimeType == String) {
          olddevice = json.decode(res['data'])['olddevice'];
        } else {
          olddevice = res['data']['olddevice'];
        }
        throw Exception({'message': res['message'], 'olddevice': olddevice});
      }
      novelBox.put('usertoken', tokenData);
      savePassword(password);
      return User.fromJson(decodedToken);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> loginUserCheck({
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

      if (response.statusCode != 200) {
        print('error: ${response.statusCode}');
      }

      final res = json.decode(response.body);
      Logger().i(res);

      if (res['status'] == 'error') {
        throw Exception({'message': res['message'], 'olddevice': null});
      }

      print('datatype: ${res['data'].runtimeType}');
      final tokenData;
      if (res['message'] == 'กำลังเข้าสู่ระบบ โปรดรอสักครู่') {
        if (res['data'].runtimeType == String) {
          tokenData = json.decode(res['data'])['token'];
        } else {
          tokenData = res['data']['token'];
        }
      } else {
        if (res['data'].runtimeType == String) {
          tokenData = json.decode(res['data'])['token'];
        } else {
          tokenData = res['data']['token'];
        }
      }
      final decodedToken = JwtDecoder.decode(tokenData);
      Logger().i(tokenData);
      Logger().i(decodedToken);
      if (res['message'] == 'มีการล็อคอินซ้อนอยู่ในเบาว์เซอร์อื่น') {
        String olddevice = '';

        if (res['data'].runtimeType == String) {
          olddevice = json.decode(res['data'])['olddevice'];
        } else {
          olddevice = res['data']['olddevice'];
        }
        throw Exception({'message': res['message'], 'olddevice': olddevice});
      }
      novelBox.put('usertoken', tokenData);
      savePassword(password);
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> loginCheckSocial({
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
      Logger().i('res: $res');

      // if (res['status'] == 'error') throw Exception(res['message']);
      if (res['status'] == 'error') {
        throw Exception({'message': res['message'], 'olddevice': null});
      } else {
        final tokenData;
        if (res['message'] == 'กำลังเข้าสู่ระบบ โปรดรอสักครู่') {
          if (res['data'].runtimeType == String) {
            tokenData = json.decode(res['data'])['token'];
          } else {
            tokenData = res['data']['token'];
          }
        } else if (res['message'] == 'มีการล็อคอินซ้อนอยู่ในเบาว์เซอร์อื่น') {
          throw Exception({'message': res['message'], 'olddevice': null});
        } else {
          if (res['data'].runtimeType == String) {
            tokenData = json.decode(res['data'])['token'];
          } else {
            tokenData = res['data']['token'];
          }
        }

        final decodedToken = JwtDecoder.decode(tokenData);
        Logger().i(decodedToken);

        await novelBox.put('usertoken', tokenData);
        await novelBox.put('loginType', 'normal');
        await novelBox.put(
            'user', json.encode(User.fromJson(decodedToken).toJson()));
        savePassword(password);
        return 'เข้าสู่ระบบสำเร็จ';
      }
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

  Future<bool> registersocial({
    required String username,
    required String email,
    required String identifier,
    required bool firstRegis,
  }) async {
    final urlx = Uri.parse('${url}login/social');
    try {
      print('username: $username');
      print('email: $email');
      print('identifier: $identifier');
      final response = await http.post(
        urlx,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          "username": username,
          "email": email,
          "identifier": identifier,
        },
      );

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        Logger().i('res: $res');

        if (res['status'] == 'error') {
          throw Exception(res['message']);
        }

        final tokenData;
        if (res['message'] == 'กำลังเข้าสู่ระบบ โปรดรอสักครู่') {
          if (res['data'].runtimeType == String) {
            tokenData = json.decode(res['data'])['token'];
          } else {
            tokenData = res['data']['token'];
          }
        } else {
          if (res['data'].runtimeType == String) {
            tokenData = json.decode(res['data'])['token'];
          } else {
            tokenData = res['data']['token'];
          }
        }
        final decodedToken = JwtDecoder.decode(tokenData);
        if (res['message'] == 'มีการล็อคอินซ้อนอยู่ในเบาว์เซอร์อื่น') {
          Logger().i('useroverlap: ${User.fromJson(decodedToken).toJson()}');
          await novelBox.put(
              'useroverlap', json.encode(User.fromJson(decodedToken).toJson()));
          await novelBox.put('usertoken', tokenData);
          String olddevice = '';
          if (res['data'].runtimeType == String) {
            olddevice = json.decode(res['data'])['olddevice'];
          } else {
            olddevice = res['data']['olddevice'];
          }
          throw Exception({'message': res['message'], 'olddevice': olddevice});
        }
        Logger().i(decodedToken);
        await novelBox.put('usertoken', tokenData);
        // await novelBox.put('loginType', 'social');
        Logger().i('user: ${tokenData}');
        if (!firstRegis) {
          print('firstRegis: $firstRegis');
          await novelBox.put(
              'user', json.encode(User.fromJson(decodedToken).toJson()));
        }
        // await novelBox.put(
        //     'user', json.encode(User.fromJson(decodedToken).toJson()));
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

  Future<User> loadprofilesocial({
    required String username,
    required String email,
    required String identifier,
    required bool firstRegis,
  }) async {
    final urlx = Uri.parse('${url}login/social');
    try {
      print('username: $username');
      print('email: $email');
      print('identifier: $identifier');
      final response = await http.post(
        urlx,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          "username": username,
          "email": email,
          "identifier": identifier,
        },
      );

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        Logger().i(res);

        if (res['status'] == 'error') {
          throw Exception(res['message']);
        }

        final tokenData;
        if (res['message'] == 'กำลังเข้าสู่ระบบ โปรดรอสักครู่') {
          if (res['data'].runtimeType == String) {
            tokenData = json.decode(res['data'])['token'];
          } else {
            tokenData = res['data']['token'];
          }
        } else {
          if (res['data'].runtimeType == String) {
            tokenData = json.decode(res['data'])['token'];
          } else {
            tokenData = res['data']['token'];
          }
        }

        final decodedToken = JwtDecoder.decode(tokenData);
        if (res['message'] == 'มีการล็อคอินซ้อนอยู่ในเบาว์เซอร์อื่น') {
          String olddevice = '';
          await novelBox.put(
              'useroverlap', json.encode(User.fromJson(decodedToken).toJson()));
          await novelBox.put('usertoken', tokenData);
          if (res['data'].runtimeType == String) {
            olddevice = json.decode(res['data'])['olddevice'];
          } else {
            olddevice = res['data']['olddevice'];
          }
          throw Exception({'message': res['message'], 'olddevice': olddevice});
        }
        Logger().i(decodedToken);
        await novelBox.put('usertoken', tokenData);
        // await novelBox.put('loginType', 'social');
        Logger().i('user: ${tokenData}');
        if (!firstRegis) {
          print('firstRegis: $firstRegis');
          await novelBox.put(
              'user', json.encode(User.fromJson(decodedToken).toJson()));
        }
        // await novelBox.put(
        //     'user', json.encode(User.fromJson(decodedToken).toJson()));
        return User.fromJson(decodedToken);
      } else {
        final res = json.decode(response.body);
        throw Exception(res['message'] ?? 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      Logger().e('Error during user registration', error: e);
      throw Exception(e.toString());
    }
  }

  Future<void> deleteFile(String filePath) async {
    try {
      File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        print('File deleted successfully');
      } else {
        print('File does not exist');
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  Future<void> updateImageUser(
      {required File image, required String type}) async {
    final urlx = Uri.parse('${url}update/member/img');
    final token = await novelBox.get('usertoken');

    try {
      var request = http.MultipartRequest('POST', urlx);
      // Headers
      request.headers['x-api-key'] = apiKey;
      request.headers['x-client-domain'] = clientDomain;
      request.headers['Authorization'] = '$token';

      // File information
      String fileName = path.basename(image.path);

      // Adding file to request
      var fileStream = await http.MultipartFile.fromPath(
        'image',
        image.path,
      );
      request.files.add(fileStream);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print('Uploaded!');
        if (type == 'social') {
          deleteFile(image.path);
        }
      } else {
        var responseData = await response.stream.bytesToString();
        var decodedResponse = json.decode(responseData);
        print(decodedResponse);
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<bool> updateProfileUser({
    required String username,
    required String date,
    required String gender,
    required String phone,
    required String address,
    required String FB,
    required String twitter,
  }) async {
    final urlx = Uri.parse('${url}update/member');
    final token = novelBox.get('usertoken');
    final genderCode = gender == 'ชาย' ? 'm' : 'f';
    print('username: $username');
    print('gender: $genderCode');
    print('phone: $phone');
    print('address: $address');
    print('FB: $FB');
    print('date: ${convertThaiDateToISO(date)}');
    try {
      final response = await http.post(urlx, headers: {
        'x-api-key': apiKey,
        'x-client-domain': clientDomain,
        'Authorization': token
      }, body: {
        "username": username,
        "birthday_date": convertThaiDateToISO(date),
        "gender": genderCode,
        "about_me": '',
        "phone": phone,
        "address": address,
        "FB": FB,
        "twitter": twitter
      });

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        Logger().i(res);
        if (res['status'] == 'error') {
          throw Exception(res['message']);
        }
        return true;
      } else {
        print('Error: ${response.statusCode}');
        final res = json.decode(response.body);
        throw Exception(res['message'] ?? 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final urlx = Uri.parse('${url}update/member/password');
    print('url: $urlx');
    print('oldPassword: $oldPassword');
    print('newPassword: $newPassword');
    final token = novelBox.get('usertoken');
    try {
      final response = await http.put(urlx, headers: {
        'x-api-key': apiKey,
        'x-client-domain': clientDomain,
        'Authorization': token
      }, body: {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      });

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        Logger().i(res);
        if (res['status'] == 'error') {
          throw Exception(res['message']);
        }
        return {'status': 'success', 'message': res['message']};
      } else {
        final res = json.decode(response.body);
        throw Exception(res['message'] ?? 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  Future<Map<String, dynamic>> changeEmail({
    required String newEmail,
    required String oldEmail,
  }) async {
    final Uri urlx = Uri.parse('${url}update/member/email');
    final String? token = novelBox.get('usertoken');

    if (token == null || token.isEmpty) {
      throw Exception('User token is missing. Please login again.');
    }

    try {
      final response = await http.put(
        urlx,
        headers: {
          'x-api-key': apiKey,
          'x-client-domain': clientDomain,
          'Authorization': token,
        },
        body: {
          'oldEmail': oldEmail,
          'newEmail': newEmail,
        },
      );

      final responseBody = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {'message': 'No response body'};

      if (response.statusCode == 200) {
        Logger().i(responseBody);

        if (responseBody['status'] == 'error') {
          throw Exception(responseBody['message']);
        }

        return {
          'status': 'success',
          'message': responseBody['message'] ?? 'Email updated successfully',
        };
      } else {
        throw Exception(responseBody['message'] ?? 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      Logger().e('Failed to change email: $e');
      throw Exception('Failed to change email: $e');
    }
  }

  Future<bool> logoutUser(String userID) async {
    final urlx = Uri.parse('${url}logout');
    final token = novelBox.get('usertoken');
    Logger().i('token: $token');
    try {
      final response = await http.put(
        urlx,
        headers: {
          'x-api-key': apiKey,
          'x-client-domain': clientDomain,
          'Authorization': token
        },
        body: {'userid': userID},
      );
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        Logger().i(res);
        // if (res['status'] == 'error') {
        //   throw Exception(res['message']);
        // }
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Failed to logout: $e');
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
