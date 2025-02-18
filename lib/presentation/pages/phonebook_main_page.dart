import 'package:flutter/material.dart';
import 'package:phone_book/presentation/pages/phonebook_call_page.dart';
import 'package:phone_book/presentation/pages/phonebook_contact_page.dart';
import 'package:phone_book/presentation/pages/phonebook_history_page.dart';

class PhonebookMainPage extends StatefulWidget {
  const PhonebookMainPage({super.key});

  @override
  State<PhonebookMainPage> createState() => _PhonebookMainPageState();
}

class _PhonebookMainPageState extends State<PhonebookMainPage> {
  int selectedIndex = 1;

  List<Widget> pages = [
    PhonebookCallPage(),
    PhonebookContactPage(),
    PhonebookHistoryPage(),
  ];

  void tapBottomNavigator(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages.elementAt(selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: "call",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page),
            label: "contact",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "history",
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.green,
        onTap: tapBottomNavigator,
      ),
    );
  }
}
