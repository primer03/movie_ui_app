import 'package:bloctest/models/novel_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NovelRepository {
  Future<Welcome> getNovels() async {
    final url =
        Uri.parse('https://pzfbh88v-3002.asse.devtunnels.ms/api/Allnovel');
    const apiKey = 'NGYyMDNlYmMtYjYyZi00OWMzLTg0NmItYThiZmI4NjhhYzUx';
    const clientDomain = 'https://bookfet.com';

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'x-client-domain': clientDomain,
      },
    );
    List<Promote> promote = json
        .decode(json.decode(response.body)['data'])['promote']
        .map<Promote>((item) => Promote.fromJson(item))
        .toList();
    List<Recomnovel> recomnovel = json
        .decode(json.decode(response.body)['data'])['recomnovel']
        .map<Recomnovel>((item) => Recomnovel.fromJson(item))
        .toList();
    List<Cate> cate = [];
    cate.add(Cate(id: 0, name: 'ทั้งหมด', img: 'img', des: ''));
    cate.addAll(json
        .decode(json.decode(response.body)['data'])['cate']
        .map<Cate>((item) => Cate.fromJson(item))
        .toList());
    List<HitNovel> top10 = json
        .decode(json.decode(response.body)['data'])['top10']
        .map<HitNovel>((item) => HitNovel.fromJson(item))
        .toList();
    List<HitNovel> hitnovel = json
        .decode(json.decode(response.body)['data'])['hitNovel']
        .map<HitNovel>((item) => HitNovel.fromJson(item))
        .toList();
    List<List<Columnnovel>> columnnovel =
        (json.decode(json.decode(response.body)['data'])['columnnovel'] as List)
            .map<List<Columnnovel>>((outerItem) => (outerItem as List)
                .map<Columnnovel>((innerItem) =>
                    Columnnovel.fromJson(innerItem as Map<String, dynamic>))
                .toList())
            .toList();
    Newnovelupdate newnovelupdate = Newnovelupdate.fromJson(
        json.decode(json.decode(response.body)['data'])['newnovelupdate']);
    Welcome welcome = Welcome(
        promote: promote,
        recomnovel: recomnovel,
        cate: cate,
        top10: top10,
        hitNovel: hitnovel,
        columnnovel: columnnovel,
        newnovelupdate: newnovelupdate);
    return welcome;
  }

  // final List<User> _users = [
  //   User(id: '1', name: 'John Doe', email: 'example@gmail.com'),
  //   User(id: '2', name: 'Jane Doe', email: 'example2@gmail.com'),
  // ];

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
