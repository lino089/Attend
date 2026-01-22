import 'package:flutter/material.dart';
import 'package:attend_app/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:attend_app/updata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();

    uploadSemuaSiswa();
  }

  Future<void> uploadSemuaSiswa() async {
    CollectionReference siswaRef = FirebaseFirestore.instance.collection(
      'siswa',
    );

    for (var siswa in daftarSiswaRPL) {
      await siswaRef.doc(siswa.nis).set(siswa.toMap());
    }
    print("selesai Upload!");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: dashboard());
  }
}
