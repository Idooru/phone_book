import 'package:flutter/material.dart';
import 'package:phone_book/core/validators/email_validator.dart';
import 'package:phone_book/core/validators/name_validator.dart';
import 'package:phone_book/core/validators/phone_validator.dart';
import 'package:phone_book/domain/entities/user.dart';
import 'package:phone_book/domain/entities/validator.dart';
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

    widget.nameController.addListener(() => validate(validator: nameValidator, controller: widget.nameController));
    widget.phoneController.addListener(() => validate(validator: phoneValidator, controller: widget.phoneController));
    widget.emailController.addListener(() => validate(validator: emailValidator, controller: widget.emailController));

    nameValidator = Validator(strategy: NameValidatorStrategy());
    phoneValidator = Validator(strategy: PhoneValidatorStrategy());
    emailValidator = Validator(strategy: EmailValidatorStrategy());
  }

  void validate({
    required Validator validator,
    required TextEditingController controller,
  }) {
    setState(() {
      validator.isInvalid = validator.strategy.isInvalid(controller.text, widget.allUser, widget.currentUser);
      validator.error = validator.strategy.getError();
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
