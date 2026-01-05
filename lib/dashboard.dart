import 'package:attend_app/jadwal.dart';
import 'package:attend_app/setelan.dart';
import 'package:attend_app/presensiPage.dart';
import 'package:flutter/material.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboard();
}

class _dashboard extends State<dashboard> {
  int _selectedIndex = 0;

  void onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [dashboardPage(), jadwal(), setelan()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'jadwal',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setelan'),
        ],
      ),
    );
  }
}

class dashboardPage extends StatelessWidget {
  const dashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const headerProfil(
            nama: "Rossy Rahmadani",
            jabatan: "Guru Rekayasa Perangkat Lunak",
            tanggal: "SENIN, 28 OKTOBER",
            fotourl: "",
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                card(
                  kelas: "XI RPL 2",
                  jamPel: "7:15 - 8:45",
                  status: "(Sedang Berlangsung)",
                  isActive: true,
                ),
                const SizedBox(height: 20),
                card(
                  kelas: "XI DKV 2",
                  jamPel: "9:15 - 10:45",
                  status: "(Menunggu)",
                  isActive: false,
                ),
                const SizedBox(height: 20),
                card(
                  kelas: "XI TKJ 2",
                  jamPel: "11:15 - 12:45",
                  status: "(Menunggu)",
                  isActive: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class headerProfil extends StatelessWidget {
  const headerProfil({
    super.key,
    required this.nama,
    required this.jabatan,
    required this.tanggal,
    required this.fotourl,
  });

  final String nama, jabatan, tanggal, fotourl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      jabatan,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    Text(
                      tanggal,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class card extends StatelessWidget {
  const card({
    super.key,
    required this.kelas,
    required this.jamPel,
    required this.status,
    required this.isActive,
  });

  final String kelas, jamPel, status;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(kelas, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isActive == true ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            Text('Jam Pelajaran'),
            Text(jamPel),
            SizedBox(height: 5),
            if (isActive == true)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const presensi(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Mulai Presensi',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
