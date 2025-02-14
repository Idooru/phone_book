import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.green,
    shape: CircleBorder(),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color.fromARGB(255, 231, 231, 231),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent), // 🔥 테두리 색을 투명하게
      borderRadius: BorderRadius.circular(8.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent), // 🔥 포커스 시에도 테두리 제거
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent), // 🔥 포커스 시에도 테두리 제거
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: const Color.fromARGB(255, 166, 11, 0), width: 0.4), // 🔥 포커스 시에도 테두리 제거
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
);
