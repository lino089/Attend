
import 'package:attend/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  runApp(const ProviderScope(child: PresensiApp()));
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
      home: const RoleSelectionScreen(),
    );
  }
}