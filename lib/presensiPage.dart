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
                offset: Offset(0, 4),
              ),
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
      body: 
        Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, right: 15, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Progres Presensi'),
                SizedBox(height: 5),
                LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(10),
                ),
                SizedBox(height: 40),
                card(selectedStatus: true),
                SizedBox(height: 15),
                card(selectedStatus: true),
              ],
          ),
        ),
      ),
    );
  }
}

class card extends StatelessWidget {
  const card({super.key, required this.selectedStatus});
  final bool selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('1.'),
            SizedBox(width: 25),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              child: const Icon(Icons.person, size: 40, color: Colors.white),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Mulyono", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 1),
                Text(
                  "NIS : 12345",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withValues(alpha: 0.25),
                  ),
                ),
                SizedBox(height: 7),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _button("H"),
                    SizedBox(width: 10),
                    _button("S"),
                    SizedBox(width: 10),
                    _button("I"),
                    SizedBox(width: 10),
                    _button("A"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _button(String label) {
    return InkWell(
      onTap: () {},
      customBorder: const CircleBorder(),
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
          color: Colors.transparent,
        ),
        child: Center(
          child: 
          Text(
            label,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
