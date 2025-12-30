import 'package:attend_app/jadwal.dart';
import 'package:attend_app/setelan.dart';
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
        children: [
          Center(child: Text('halaman dashboard utama')),
          jadwal(),
          setelan(),
        ],
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
    throw UnimplementedError();
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
              SizedBox(width: 5),
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
          children: [
            Row(
              children: [
                Text(
                  kelas,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  status
                )
              ],
            ),
            Text(
              'Jam Pelajaran'
            ),
            Text(
              jamPel
            ),
            SizedBox(height: 5),
            if(isActive == true)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: const Text(
                    'Mulai Presensi',
                    style: TextStyle(color: Colors.white),
                  )
                ),
              )
          ],
        ),
      ),
    );
  }
}
