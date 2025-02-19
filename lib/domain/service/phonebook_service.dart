import 'package:flutter/material.dart';
import 'package:phone_book/presentation/state/phonebook_provider.dart';

abstract interface class PhonebookService {
  Future<void> insertAlltUser(BuildContext context);
  void searchUser(PhonebookProvider phonebook, String search);
}
