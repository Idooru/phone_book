import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:phone_book/domain/entities/user.dart';
import 'package:phone_book/domain/repository/user_repository.dart';
import 'package:phone_book/presentation/state/phonebook_provider.dart';

class UserRepositoryImpl implements UserRepository {
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

  @override
  List<User> filterUserWithSearch(String search, PhonebookProvider phonebookProvider) {
    RegExp matcher = _createFuzzyMatcher(search);
    return phonebookProvider.users.where((User user) => matcher.hasMatch(user.name)).toList();
  }

  @override
  void updateUserList(List<User> searchedUsers, PhonebookProvider phonebookProvider) {
    if (searchedUsers.isNotEmpty) {
      phonebookProvider.loadSearchedUser(searchedUsers);
    } else {
      phonebookProvider.loadSearchedUser([]);
    }
  }

  // 출처: https://taegon.kim/archives/9919
  String _ch2pattern(String ch) {
    const int offset = 44032; // '가'의 유니코드 값

    // 한국어 음절(완성형 한글)인지 확인
    if (RegExp(r'[가-힣]').hasMatch(ch)) {
      int chCode = ch.codeUnitAt(0) - offset;
      // 종성이 있으면 문자 그대로 반환
      if (chCode % 28 > 0) {
        return RegExp.escape(ch);
      }
      int begin = (chCode ~/ 28) * 28 + offset;
      int end = begin + 27;
      return '[\\u${begin.toRadixString(16)}-\\u${end.toRadixString(16)}]';
    }

    // 한글 자음 처리
    if (RegExp(r'[ㄱ-ㅎ]').hasMatch(ch)) {
      Map<String, int> con2syl = {
        'ㄱ': '가'.codeUnitAt(0),
        'ㄲ': '까'.codeUnitAt(0),
        'ㄴ': '나'.codeUnitAt(0),
        'ㄷ': '다'.codeUnitAt(0),
        'ㄸ': '따'.codeUnitAt(0),
        'ㄹ': '라'.codeUnitAt(0),
        'ㅁ': '마'.codeUnitAt(0),
        'ㅂ': '바'.codeUnitAt(0),
        'ㅃ': '빠'.codeUnitAt(0),
        'ㅅ': '사'.codeUnitAt(0),
      };

      int begin = con2syl[ch] ?? ((ch.codeUnitAt(0) - 12613) * 588 + con2syl['ㅅ']!);
      int end = begin + 587;
      return '[${RegExp.escape(ch)}\\u${begin.toRadixString(16)}-\\u${end.toRadixString(16)}]';
    }

    // 그 외 문자
    return RegExp.escape(ch);
  }

  // 출처: https://taegon.kim/archives/9919
  RegExp _createFuzzyMatcher(String input) {
    String pattern = input.split('').map(_ch2pattern).join('.*?');
    return RegExp(pattern);
  }
}
