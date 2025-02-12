import 'package:phone_book/domain/entities/user.dart';

abstract class ValidatorStrategy {
  bool isInvalid(String value, List<User> allUsers, User currentUser);
  String? getError();
}
