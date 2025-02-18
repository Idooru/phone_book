import 'package:flutter/material.dart';
import 'package:phone_book/core/validators/email_validator.dart';
import 'package:phone_book/core/validators/name_validator.dart';
import 'package:phone_book/core/validators/phone_validator.dart';
import 'package:phone_book/core/widgets/custom_text_field.dart';
import 'package:phone_book/domain/entities/user.dart';
import 'package:phone_book/domain/entities/validator.dart';
import 'package:phone_book/presentation/state/phonebook_provider.dart';
import 'package:provider/provider.dart';

class AddPhoneBookDialog extends StatefulWidget {
  final List<User> allUser;

  const AddPhoneBookDialog({
    super.key,
    required this.allUser,
  });

  @override
  State<AddPhoneBookDialog> createState() => AddPhoneBookDialogState();
}

class AddPhoneBookDialogState extends State<AddPhoneBookDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  late final Validator nameValidator;
  late final Validator phoneValidator;
  late final Validator emailValidator;

  bool isSubmitAble = true;

  @override
  void initState() {
    super.initState();

    // 검증 전략 초기화
    nameValidator = Validator(strategy: NameValidatorStrategy(), isInvalid: true);
    phoneValidator = Validator(strategy: PhoneValidatorStrategy(), isInvalid: true);
    emailValidator = Validator(strategy: EmailValidatorStrategy(), isInvalid: true);

    // 각 컨트롤러 별로 입력 감지 이벤트를 등록 시킴
    // 입력이 일어날 때마다 검증 validate 호출
    nameController.addListener(() => validate(validator: nameValidator, controller: nameController));
    phoneController.addListener(() => validate(validator: phoneValidator, controller: phoneController));
    emailController.addListener(() => validate(validator: emailValidator, controller: emailController));

    validateSubmitable();
  }

  void validate({
    required Validator validator,
    required TextEditingController controller,
  }) {
    setState(() {
      validator.isInvalid = validator.strategy.isInvalid(value: controller.text, users: widget.allUser);
      validator.error = validator.strategy.getError();
    });

    validateSubmitable();
  }

  void pressSubmit(PhonebookProvider phonebook) {
    User newUser = User(
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
    );

    phonebook.createUser(newUser);

    Navigator.of(context).pop();
  }

  void validateSubmitable() {
    setState(() {
      isSubmitAble = !(nameValidator.isInvalid || phoneValidator.isInvalid || emailValidator.isInvalid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhonebookProvider>(
      builder: (BuildContext context, PhonebookProvider phonebook, Widget? child) {
        return AlertDialog(
          title: Text("생성"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    label: "Name",
                    domain: "이름",
                    controller: nameController,
                    validator: nameValidator,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    label: "Phone",
                    domain: "전화번호",
                    controller: phoneController,
                    validator: phoneValidator,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    label: "Email",
                    domain: "이메일",
                    controller: emailController,
                    validator: emailValidator,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actions: [
            OverflowBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 238, 238, 238),
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.3, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("cancel", style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.3, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  onPressed: isSubmitAble ? () => pressSubmit(phonebook) : null,
                  child: Text("submit", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
