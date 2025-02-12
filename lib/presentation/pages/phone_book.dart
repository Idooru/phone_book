import 'package:flutter/material.dart';
import 'package:phone_book/domain/entities/user.dart';
import 'package:phone_book/presentation/state/phonebook_provider.dart';
import 'package:phone_book/presentation/widgets/edit_phone_book.dart';
import 'package:provider/provider.dart';

class PhoneBookPage extends StatefulWidget {
  const PhoneBookPage({super.key});

  @override
  State<PhoneBookPage> createState() => PhoneBookState();
}

class PhoneBookState extends State<PhoneBookPage> {
  late List<User> users;
  late PhonebookProvider phonebookProvider;

  void pressEdit(User user) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return EditPhoneBookDialog(
          allUser: users,
          currentUser: user,
        );
      },
    );
  }

  void pressTrailing(User user) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("edit"),
                onTap: () {
                  pressEdit(user);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("delete"),
                onTap: () {
                  phonebookProvider.deleteUser(user);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    phonebookProvider = context.watch<PhonebookProvider>();
    users = phonebookProvider.users;

    return Scaffold(
      appBar: AppBar(
        title: Text("phone book"),
      ),
      body: ListView.separated(
        itemCount: users.length,
        itemBuilder: (context, index) {
          User user = users[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("images/big.jpeg"),
            ),
            title: Text(user.name),
            subtitle: Text(user.phone),
            trailing: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                pressTrailing(user);
              },
            ),
            onTap: () {
              debugPrint("사용자 이름: ${user.name}");
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 5,
            color: Colors.grey[300],
          );
        },
      ),
    );
  }
}
