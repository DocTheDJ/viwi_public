import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        background: Color(0xFFF8F8F8),
        primaryContainer: Colors.white,
        primary: Color(0xFF00D1FF),
        secondaryContainer: Colors.white,
        secondary: Colors.black,
        tertiary: Colors.black38,
        tertiaryContainer: Colors.black87),
    appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF8F8F8),
        elevation: 0.0,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 22),
        iconTheme: IconThemeData(color: Colors.black)),
    dividerTheme: const DividerThemeData(color: Colors.transparent));
