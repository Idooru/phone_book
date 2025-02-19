import 'package:flutter/material.dart';
import 'package:phone_book/core/utils/get_it_initializor.dart';
import 'package:phone_book/domain/service/phonebook_service.dart';
import 'package:phone_book/presentation/state/phonebook_provider.dart';
import 'package:provider/provider.dart';

class SearchContactWidget extends StatefulWidget {
  const SearchContactWidget({super.key});

  @override
  State<SearchContactWidget> createState() => _SearchContactWidgetState();
}

class _SearchContactWidgetState extends State<SearchContactWidget> {
  final PhonebookService phonebookService = locator<PhonebookService>();
  final FocusNode focusNode = FocusNode();

  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhonebookProvider>(
      builder: (BuildContext context, PhonebookProvider phonbook, Widget? child) {
        return Container(
          height: 80,
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: (String search) => phonebookService.searchUser(phonbook, search),
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => focusNode.requestFocus(),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: "이름 입력",
            ),
          ),
        );
      },
    );
  }
}
