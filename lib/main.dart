import 'package:attend/screens/admin/admin_main_screen.dart';
import 'package:attend/screens/teacher/teacher_main_screen.dart';
import 'package:flutter/material.dart';


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
        scaffoldBackgroundColor: const Color(0xFFF7F8FA), 
        fontFamily: 'Roboto', 
      ),
      home: const AdminMainScreen(),
    );
  }
}