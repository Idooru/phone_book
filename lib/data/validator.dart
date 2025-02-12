enum Category { name, phone, email }

class Validator {
  final Category category;
  bool isInvalid;
  String? error;

  Validator({
    required this.category,
    this.isInvalid = false,
    this.error,
  });
}
