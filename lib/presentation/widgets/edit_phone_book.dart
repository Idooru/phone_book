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

  const EditPhoneBookDialog({
    super.key,
    required this.allUser,
    required this.currentUser,
  });

  @override
  State<EditPhoneBookDialog> createState() => EditPhoneBookState();
}

class EditPhoneBookState extends State<EditPhoneBookDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  late final Validator nameValidator;
  late final Validator phoneValidator;
  late final Validator emailValidator;

  late PhonebookProvider phonebookProvider;

  bool isSubmitAble = true;

  @override
  void initState() {
    super.initState();

    // 현재 사용자의 입력 정보를 edit 창에 표시
    nameController.text = widget.currentUser.name;
    phoneController.text = widget.currentUser.phone;
    emailController.text = widget.currentUser.email;

    // 검증 전략 초기화
    nameValidator = Validator(strategy: NameValidatorStrategy(), isInvalid: false);
    phoneValidator = Validator(strategy: PhoneValidatorStrategy(), isInvalid: false);
    emailValidator = Validator(strategy: EmailValidatorStrategy(), isInvalid: false);

    // 현재 입력된 정보를 검증 목록에서 제외 시킴
    List<User> exclusiveNames(String name) => widget.allUser.where((User user) => user.name != widget.currentUser.name).toList();
    List<User> exclusivePhones(String phone) => widget.allUser.where((User user) => user.phone != widget.currentUser.phone).toList();
    List<User> exclusiveEmails(String email) => widget.allUser.where((User user) => user.email != widget.currentUser.email).toList();

    // 각 컨트롤러 별로 입력 감지 이벤트를 등록 시킴
    // 입력이 일어날 때마다 검증 validate 호출
    nameController.addListener(() => validate(validator: nameValidator, controller: nameController, getRemainUsers: exclusiveNames));
    phoneController.addListener(() => validate(validator: phoneValidator, controller: phoneController, getRemainUsers: exclusivePhones));
    emailController.addListener(() => validate(validator: emailValidator, controller: emailController, getRemainUsers: exclusiveEmails));
  }

  void validate({
    required Validator validator,
    required TextEditingController controller,
    required List<User> Function(String) getRemainUsers,
  }) {
    setState(() {
      validator.isInvalid = validator.strategy.isInvalid(value: controller.text, users: getRemainUsers(controller.text));
      validator.error = validator.strategy.getError();
    });

    validateSubmitable();
  }

  void pressSubmit(User user) {
    int index = widget.allUser.indexWhere((User userParam) => userParam.name == user.name);

    User newUser = User(
      nameController.text,
      phoneController.text,
      emailController.text,
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
        width: MediaQuery.of(context).size.width * 0.7,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(fontSize: 15.0),
                controller: nameController,
                decoration: InputDecoration(
                  label: Text("Name"),
                  border: OutlineInputBorder(),
                  helperText: "이름을 입력하세요.",
                  counterText: "입력길이: ${nameController.text.length}",
                  errorText: nameValidator.isInvalid ? nameValidator.error : null,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(fontSize: 15.0),
                controller: phoneController,
                decoration: InputDecoration(
                  label: Text("Phone"),
                  border: OutlineInputBorder(),
                  helperText: "전화번호를 입력하세요.",
                  counterText: "입력길이: ${phoneController.text.length}",
                  errorText: phoneValidator.isInvalid ? phoneValidator.error : null,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(fontSize: 15.0),
                controller: emailController,
                decoration: InputDecoration(
                  label: Text("Email"),
                  border: OutlineInputBorder(),
                  helperText: "이메일을 입력하세요.",
                  counterText: "입력길이: ${emailController.text.length}",
                  errorText: emailValidator.isInvalid ? emailValidator.error : null,
                ),
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
              onPressed: isSubmitAble ? () => pressSubmit(widget.currentUser) : null,
              child: Text("submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        )
      ],
    );
  }
}
