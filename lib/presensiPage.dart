import 'package:flutter/material.dart';

class presensi extends StatefulWidget {
  const presensi({super.key});

  @override
  State<presensi> createState() => _presensi();
}

class _presensi extends State<presensi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 4,
                offset: Offset(0, 4)
              )
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
            toolbarHeight: 70,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("XI RPL 2", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  "Pemrograman Perangkat bergerak",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.withAlpha(155),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progres Presensi'
              ),
              SizedBox(height: 5),
              LinearProgressIndicator(
                value: 0.7,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 10,
                borderRadius: BorderRadius.circular(10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
