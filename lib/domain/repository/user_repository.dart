import 'package:phone_book/presentation/state/phonebook_provider.dart';

typedef ListUserJson = List<Map<String, dynamic>>;

abstract interface class UserRepository {
  Future<List<Map<String, dynamic>>> fetchJson();
  void inserAlltUser(ListUserJson jsonData, PhonebookProvider phonebookProvider);
}
