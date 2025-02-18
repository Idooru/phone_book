import 'package:flutter/material.dart';
import 'package:phone_book/core/utils/get_it_initializor.dart';
import 'package:phone_book/domain/repository/user_repository.dart';
import 'package:phone_book/domain/service/phonebook_service.dart';
import 'package:phone_book/presentation/state/phonebook_provider.dart';
import 'package:provider/provider.dart';

class PhonebookServiceImpl implements PhonebookService {
  final UserRepository userRepository = locator<UserRepository>();

  late PhonebookProvider phonebookProvider;

  @override
  Future<void> insertAlltUser(BuildContext context) async {
    phonebookProvider = Provider.of<PhonebookProvider>(context, listen: false);
    ListUserJson userJson = await userRepository.fetchJson();

    userRepository.inserAlltUser(userJson, phonebookProvider);
  }
}
