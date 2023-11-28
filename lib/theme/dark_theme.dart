import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        background: Color(0xFF373636),
        primaryContainer: Color(0xFF242424),
        primary: Color(0xFF00D1FF),
        secondaryContainer: Color(0xFF373636),
        secondary: Colors.white,
        tertiary: Colors.white60,
        tertiaryContainer: Colors.white24),
    appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF373636),
        elevation: 0.0,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
        iconTheme: IconThemeData(color: Colors.white)),
    dividerTheme: const DividerThemeData(color: Colors.transparent));
