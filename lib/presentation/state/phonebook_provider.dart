import 'package:flutter/material.dart';
import 'package:phone_book/domain/entities/user.dart';

class PhonebookProvider extends ChangeNotifier {
  List<User> _users = [
    User("홍길동", '0100001', 'a@a.com'),
    User("김길동", '0100002', 'b@a.com'),
    User("이길동", '0100003', 'c@a.com'),
  ];

  List<User> get users => _users;

  void updateUsers(int index, User newUser) {
    _users[index] = newUser;
    notifyListeners();
  }

  void deleteUser(User deleteUser) {
    _users = _users.where((User user) => user != deleteUser).toList();
    notifyListeners();
  }
}
