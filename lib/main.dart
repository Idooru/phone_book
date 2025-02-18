import 'package:flutter/material.dart';
import 'package:phone_book/core/themes/theme_data.dart';
import 'package:phone_book/core/utils/get_it_initializor.dart';
import 'package:phone_book/presentation/state/phonebook_provider.dart';
import 'package:phone_book/presentation/pages/phonebook_page.dart';
import 'package:provider/provider.dart';

void main() {
  initLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PhonebookProvider(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: PhoneBookPage(),
    );
  }
}
