import 'package:phone_book/core/validators/validate_strategy.dart';
import 'package:phone_book/domain/entities/user.dart';

class PhoneValidatorStrategy implements ValidatorStrategy {
  String? _error;
  final RegExp phoneRegex = RegExp(r'^[0-9]+$');

  @override
  bool isInvalid(String value, List<User> allUsers, User currentUser) {
    if (value.isEmpty) {
      _error = "전화번호가 비어있어요";
      return true;
    } else if (value.length > 11) {
      _error = "전화번호 길이가 너무 길어요";
      return true;
    } else if (!phoneRegex.hasMatch(value)) {
      _error = "숫자만 입력해주세요";
      return true;
    } else if (allUsers.any((user) => user.phone == value && user.phone != currentUser.phone)) {
      _error = "전화번호가 중복되었어요";
      return true;
    }
    _error = null;
    return false;
  }

  @override
  String? getError() => _error;
}
