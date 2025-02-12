import 'package:phone_book/core/validators/validate_strategy.dart';
import 'package:phone_book/domain/entities/user.dart';

class NameValidatorStrategy implements ValidatorStrategy {
  String? _error;

  @override
  bool isInvalid(String value, List<User> allUsers, User currentUser) {
    if (value.isEmpty) {
      _error = "이름이 비어있어요";
      return true;
    } else if (value.length > 4) {
      _error = "이름 길이가 너무 길어요";
      return true;
    } else if (allUsers.any((user) => user.name == value && user.name != currentUser.name)) {
      _error = "이름이 중복되었어요";
      return true;
    }
    _error = null;
    return false;
  }

  @override
  String? getError() => _error;
}
