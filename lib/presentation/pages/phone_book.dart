import 'package:flutter/material.dart';
import 'package:phone_book/domain/entities/user.dart';
import 'package:phone_book/presentation/state/phonebook_provider.dart';
import 'package:phone_book/presentation/widgets/add_phone_book.dart';
import 'package:phone_book/presentation/widgets/edit_phone_book.dart';
import 'package:provider/provider.dart';

class PhoneBookPage extends StatelessWidget {
  const PhoneBookPage({super.key});

  void pressAdd(BuildContext context, PhonebookProvider phonebook) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddPhoneBookDialog(allUser: phonebook.users);
      },
    );
  }

  void pressEdit(BuildContext context, PhonebookProvider phonebook, User user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return EditPhoneBookDialog(allUser: phonebook.users, currentUser: user);
      },
    );
  }

  void pressTrailing(BuildContext context, PhonebookProvider phonebook, User user) {
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
                  pressEdit(context, phonebook, user);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("delete"),
                onTap: () {
                  phonebook.deleteUser(user);
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
    return Scaffold(
      appBar: AppBar(
        title: Text("phone book"),
      ),
      floatingActionButton: Align(
        alignment: Alignment(1.0, 1.07),
        child: SizedBox(
          width: 65,
          height: 65,
          child: FloatingActionButton(
            backgroundColor: Colors.green[600],
            shape: CircleBorder(),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              pressAdd(context, context.read<PhonebookProvider>());
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Builder(builder: (context) {
            debugPrint("빈 영역");
            return Container();
          }),
          Expanded(
            child: Builder(
              builder: (context) {
                debugPrint("사용자 정보 영역");
                return Consumer<PhonebookProvider>(
                  builder: (context, phonebook, child) {
                    return ListView.separated(
                      itemCount: phonebook.users.length,
                      itemBuilder: (context, index) {
                        User user = phonebook.users[index];
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
                              pressTrailing(context, phonebook, user);
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
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
