import 'package:flutter/material.dart';
import 'package:phone_book/domain/entities/user.dart';

class PhonebookProvider extends ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  void insertUser(List<User> users) {
    _users = users;
    notifyListeners();
  }

  void createUser(User newUser) {
    _users = [..._users, newUser];
    notifyListeners();
  }

  void updateUsers(int index, User newUser) {
    _users[index] = newUser;
    notifyListeners();
  }

  void deleteUser(User deleteUser) {
    _users = _users.where((User user) => user != deleteUser).toList();
    notifyListeners();
  }
}
