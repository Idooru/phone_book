import 'package:flutter/material.dart';
import 'package:phone_book/domain/entities/validator.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String domain;
  final TextEditingController controller;
  final Validator validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.domain,
    required this.controller,
    required this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode focusNode = FocusNode();
  late Color backgroundColor = Theme.of(context).inputDecorationTheme.fillColor!;

  String helperText = "";
  bool isInputted = false;

  @override
  void initState() {
    super.initState();
    helperText = "${widget.domain}을 입력해주세요.";
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        helperText = "${widget.domain}을 입력해주세요.";
        isInputted = false;
      } else {
        helperText = "${widget.domain}을 입력하였습니다.";
        isInputted = true;
      }
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(fontSize: 13.0),
      focusNode: focusNode,
      controller: widget.controller,
      decoration: InputDecoration(
        label: Text(widget.label),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        helper: Text(
          helperText,
          style: TextStyle(
            color: isInputted ? Colors.green : Colors.grey,
            fontSize: 12,
          ),
        ),
        counterText: "입력길이: ${widget.controller.text.length}",
        errorText: widget.validator.isInvalid ? widget.validator.error : null,
      ),
    );
  }
}
