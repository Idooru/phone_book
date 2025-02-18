class User {
  final String name;
  final String phone;
  final String email;

  const User({
    required this.name,
    required this.phone,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"],
      phone: json["phone"],
      email: json["email"],
    );
  }
}
