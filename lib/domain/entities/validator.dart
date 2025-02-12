import 'package:phone_book/core/validators/validate_strategy.dart';

class Validator {
  final ValidatorStrategy strategy;
  bool isInvalid;
  String? error;

  Validator({
    required this.strategy,
    this.isInvalid = false,
    this.error,
  });
}
