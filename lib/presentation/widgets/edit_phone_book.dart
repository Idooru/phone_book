import 'package:flutter/material.dart';
import 'package:phone_book/data/user.dart';
import 'package:phone_book/data/validator.dart';
import 'package:phone_book/presentation/state/phonebook_provider.dart';
import 'package:provider/provider.dart';

class EditPhoneBookDialog extends StatefulWidget {
  final List<User> allUser;
  final User currentUser;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  const EditPhoneBookDialog({
    super.key,
    required this.allUser,
    required this.currentUser,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
  });

  @override
  State<EditPhoneBookDialog> createState() => EditPhoneBookState();
}

class EditPhoneBookState extends State<EditPhoneBookDialog> {
  late final Validator nameValidator;
  late final Validator phoneValidator;
  late final Validator emailValidator;

  late PhonebookProvider phonebookProvider;

  bool isSubmitAble = true;

  @override
  void initState() {
    super.initState();
    widget.nameController.addListener(validateName);
    widget.phoneController.addListener(validatePhone);
    widget.emailController.addListener(validateEmail);

    nameValidator = Validator(category: Category.name);
    phoneValidator = Validator(category: Category.phone);
    emailValidator = Validator(category: Category.email);
  }

  void validateName() {
    String name = widget.nameController.text;

    bool isDuplicatedName(String name) {
      List<User> remainUsers = widget.allUser.where((User user) => user.name != widget.currentUser.name).toList();
      return remainUsers.any((User user) => user.name == name);
    }

    setState(() {
      if (name.isEmpty) {
        nameValidator.isInvalid = true;
        nameValidator.error = "이름이 비어있어요";
      } else if (name.length > 4) {
        nameValidator.isInvalid = true;
        nameValidator.error = "이름 길이가 너무 길어요";
      } else if (isDuplicatedName(name)) {
        nameValidator.isInvalid = true;
        nameValidator.error = "이름이 중복되었어요";
      } else {
        nameValidator.isInvalid = false;
        nameValidator.error = null;
      }
    });

    validateSubmitable();
  }

  void validatePhone() {
    String phone = widget.phoneController.text;

    bool isDuplicatedPhone(String phone) {
      List<User> remainUsers = widget.allUser.where((User user) => user.phone != widget.currentUser.phone).toList();
      return remainUsers.any((User user) => user.phone == phone);
    }

    bool isValidPhone(String phone) {
      final RegExp phoneRegex = RegExp(r'^[0-9]+$');
      return phoneRegex.hasMatch(phone);
    }

    setState(() {
      if (phone.isEmpty) {
        phoneValidator.isInvalid = true;
        phoneValidator.error = "전화번호가 비어있어요";
      } else if (phone.length > 11) {
        phoneValidator.isInvalid = true;
        phoneValidator.error = "전화번호 길이가 너무 길어요";
      } else if (!isValidPhone(phone)) {
        phoneValidator.isInvalid = true;
        phoneValidator.error = "숫자만 입력해주세요";
      } else if (isDuplicatedPhone(phone)) {
        phoneValidator.isInvalid = true;
        phoneValidator.error = "전화번호가 중복되었어요";
      } else {
        phoneValidator.isInvalid = false;
        phoneValidator.error = null;
      }
    });

    validateSubmitable();
  }

  void validateEmail() {
    String email = widget.emailController.text;

    bool isDuplicatedEmail(String email) {
      List<User> remainUsers = widget.allUser.where((User user) => user.email != widget.currentUser.email).toList();
      return remainUsers.any((User user) => user.email == email);
    }

    bool isValidEmail(String email) {
      final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      return emailRegex.hasMatch(email);
    }

    setState(() {
      if (email.isEmpty) {
        emailValidator.isInvalid = true;
        emailValidator.error = "이메일이 비어있어요";
      } else if (email.length > 25) {
        emailValidator.isInvalid = true;
        emailValidator.error = "이메일 길이가 너무 길어요";
      } else if (!isValidEmail(email)) {
        emailValidator.isInvalid = true;
        emailValidator.error = "이메일 형식을 갖춰주세요";
      } else if (isDuplicatedEmail(email)) {
        emailValidator.isInvalid = true;
        emailValidator.error = "이메일이 중복되었어요";
      } else {
        emailValidator.isInvalid = false;
        emailValidator.error = null;
      }
    });

    validateSubmitable();
  }

  void pressSubmit(User user) {
    int index = widget.allUser.indexWhere((User userParam) => userParam.name == user.name);

    User newUser = User(
      widget.nameController.text,
      widget.phoneController.text,
      widget.emailController.text,
    );

    phonebookProvider.updateUsers(index, newUser);

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void validateSubmitable() {
    setState(() {
      isSubmitAble = !(nameValidator.isInvalid || phoneValidator.isInvalid || emailValidator.isInvalid);
    });
  }

  @override
  Widget build(BuildContext context) {
    phonebookProvider = context.watch<PhonebookProvider>();

    return AlertDialog(
      title: Text("수정"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: TextStyle(fontSize: 15.0),
              controller: widget.nameController,
              decoration: InputDecoration(
                label: Text("Name"),
                border: OutlineInputBorder(),
                helperText: "이름을 입력하세요.",
                counterText: "입력길이: ${widget.nameController.text.length}",
                errorText: nameValidator.isInvalid ? nameValidator.error : null,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              style: TextStyle(fontSize: 15.0),
              controller: widget.phoneController,
              decoration: InputDecoration(
                label: Text("Phone"),
                border: OutlineInputBorder(),
                helperText: "전화번호를 입력하세요.",
                counterText: "입력길이: ${widget.phoneController.text.length}",
                errorText: phoneValidator.isInvalid ? phoneValidator.error : null,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              style: TextStyle(fontSize: 15.0),
              controller: widget.emailController,
              decoration: InputDecoration(
                label: Text("Email"),
                border: OutlineInputBorder(),
                helperText: "이메일을 입력하세요.",
                counterText: "입력길이: ${widget.emailController.text.length}",
                errorText: emailValidator.isInvalid ? emailValidator.error : null,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      actions: [
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 238, 238, 238),
                fixedSize: Size(100, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text("cancel", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                fixedSize: Size(100, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: isSubmitAble ? () => pressSubmit(widget.currentUser) : null,
              child: Text("submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        )
      ],
    );
  }
}
