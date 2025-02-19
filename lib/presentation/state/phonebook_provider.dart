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
    _searchedUsers = [..._searchedUsers, newUser];
    notifyListeners();
  }

  void updateUsers(int index, User newUser) {
    _users[index] = newUser;
    _searchedUsers[index] = newUser;
    notifyListeners();
  }

  void deleteUser(User deleteUser) {
    _users = _users.where((User user) => user != deleteUser).toList();
    _searchedUsers = _searchedUsers.where((User user) => user != deleteUser).toList();
    notifyListeners();
  }

  bool _isSearched = false;

  bool get isSearched => _isSearched;

  List<User> _searchedUsers = [];

  List<User> get searchedUsers => _searchedUsers;

  void loadSearchedUser(List<User> users) {
    _searchedUsers = users;
    _isSearched = true;
    notifyListeners();
  }

  void clearAll() {
    _users.clear();
    _isSearched = false;
    _searchedUsers.clear();
  }
}
