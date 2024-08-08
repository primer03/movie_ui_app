import 'package:bloctest/models/user_model.dart';

class UserRepository {
  final List<User> _users = [
    User(id: '1', name: 'John Doe', email: 'example@gmail.com'),
    User(id: '2', name: 'Jane Doe', email: 'example2@gmail.com'),
  ];

  Future<void> createUser({required String name, required String email}) async {
    _users.add(User(id: DateTime.now().toString(), name: name, email: email));
  }

  Future<void> updateUser(User user) async {
    final index = _users.indexWhere((element) => element.id == user.id);
    _users[index] = user;
  }

  Future<void> deleteUser(User user) async {
    _users.removeWhere((element) => element.id == user.id);
  }

  Future<List<User>> getUsers() async {
    await Future.delayed(const Duration(seconds: 2));
    return _users;
  }

  Future<List<User>> searchUsers(String query) async {
    await Future.delayed(const Duration(seconds: 2));
    final result = _users
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()) ||
            element.email.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return result;
  }
}
