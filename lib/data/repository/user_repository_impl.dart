import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:phone_book/domain/entities/user.dart';
import 'package:phone_book/domain/repository/user_repository.dart';
import 'package:phone_book/presentation/state/phonebook_provider.dart';

class UserRepositoryImpl implements UserRepository {
  late final PhonebookProvider phonebookProvider;

  @override
  Future<ListUserJson> fetchJson() async {
    String jsonString = await rootBundle.loadString('json/user.json');
    List<Map<String, dynamic>> jsonData = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
    return jsonData;
  }

  @override
  void inserAlltUser(ListUserJson jsonData, PhonebookProvider phonebookProvider) {
    List<User> users = jsonData.map((Map<String, dynamic> json) => User.fromJson(json)).toList();
    phonebookProvider.insertUser(users);
  }
}
