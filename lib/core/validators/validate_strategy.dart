import 'package:phone_book/domain/entities/user.dart';

abstract class ValidatorStrategy {
  bool isInvalid({required String value, required List<User> users});
  String? getError();
}
