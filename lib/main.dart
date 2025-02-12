import 'package:flutter/material.dart';
import 'package:phone_book/presentation/state/phonebook_provider.dart';
import 'package:phone_book/presentation/pages/phone_book.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => PhonebookProvider())],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PhoneBookPage(),
    );
  }
}
