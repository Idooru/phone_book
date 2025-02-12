import 'package:phone_book/core/validators/validate_strategy.dart';
import 'package:phone_book/domain/entities/user.dart';

class EmailValidatorStrategy implements ValidatorStrategy {
  String? _error;
  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  bool isInvalid(String value, List<User> users) {
    if (value.isEmpty) {
      _error = "이메일이 비어있어요";
      return true;
    } else if (value.length > 25) {
      _error = "이메일 길이가 너무 길어요";
      return true;
    } else if (!emailRegex.hasMatch(value)) {
      _error = "이메일 형식을 갖춰주세요";
      return true;
    } else if (users.any((user) => user.email == value)) {
      _error = "이메일이 중복되었어요";
      return true;
    }
    _error = null;
    return false;
  }

  @override
  String? getError() => _error;
}
