import 'package:flutter/material.dart';
import 'package:phone_book/core/utils/get_it_initializor.dart';
import 'package:phone_book/domain/entities/user.dart';
import 'package:phone_book/domain/service/phonebook_service.dart';
import 'package:phone_book/presentation/state/phonebook_provider.dart';
import 'package:phone_book/presentation/widgets/add_phonebook_dialog.dart';
import 'package:phone_book/presentation/widgets/edit_phonebook_dialog.dart';
import 'package:phone_book/presentation/widgets/search_contact_widget.dart';
import 'package:provider/provider.dart';

class PhonebookContactPage extends StatelessWidget {
  final PhonebookService phonebookService = locator<PhonebookService>();

  PhonebookContactPage({super.key});

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

  int calculateCount(PhonebookProvider phonebook) {
    if (phonebook.isSearched && phonebook.searchedUsers.isEmpty) {
      // 검색중이긴 하나 검색한 초성으로 사용자를 찾을 수 없을 때
      return 1;
    } else if (phonebook.isSearched) {
      // 검색중이면서 검색한 초성의 사용자가 존재함
      return phonebook.searchedUsers.length;
    } else {
      // 아직 검색을 시도하지 않음
      return phonebook.users.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    phonebookService.insertAlltUser(context);

    return Scaffold(
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: FloatingActionButton(
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.green,
            expandedHeight: 135,
            pinned: true,
            floating: true,
            snap: true,
            centerTitle: false,
            leading: Icon(Icons.contact_page, color: Colors.white),
            title: Text("전화번호부", style: TextStyle(color: Colors.white)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: SearchContactWidget(),
            ),
          ),
          Consumer<PhonebookProvider>(
            builder: (BuildContext context, PhonebookProvider phonebook, Widget? child) {
              return SliverFixedExtentList(
                itemExtent: 70.0, // 리스트 항목의 고정 높이 설정
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    List<User> users = phonebook.isSearched ? phonebook.searchedUsers : phonebook.users;

                    if (users.isEmpty) {
                      return Center(child: Text("해당 사용자를 찾을 수 없습니다."));
                    }

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
                          pressTrailing(context, phonebook, user);
                        },
                      ),
                      onTap: () {
                        debugPrint("사용자 이름: ${user.name}");
                      },
                    );
                  },
                  childCount: calculateCount(phonebook),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
