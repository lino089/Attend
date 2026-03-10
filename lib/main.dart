import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const PresensiApp());
}

class PresensiApp extends StatelessWidget {
  const PresensiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Presensi',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F6FE), 
        fontFamily: 'Roboto', 
      ),
      home: const MainScreen(),
    );
  }
}