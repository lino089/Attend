import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class presensi extends StatefulWidget {
  const presensi({super.key});

  @override
  State<presensi> createState() => _presensi();
}

class _presensi extends State<presensi> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('siswa')
          .orderBy('id')
          .snapshots(),
      builder: (context, snapshots) {
        if (snapshots.hasError)
          return const Scaffold(body: Center(child: Text('Error')));
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final docs = snapshots.data!.docs;

        int totalHadir = docs.where((d) => d['status'] == 'H').length;
        int totalSakit = docs.where((d) => d['status'] == 'S').length;
        int totalIzin = docs.where((d) => d['status'] == 'I').length;
        int totalAlpha = docs.where((d) => d['status'] == 'A').length;
        int sudahAbsen = totalHadir + totalSakit + totalIzin + totalAlpha;

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
                    Text(
                      "XI RPL 2",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
          body: Padding(
            padding: const EdgeInsets.only(top: 30, right: 15, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progres Presensi : ${(sudahAbsen / docs.length * 100).toInt().clamp(0.0, 100.0)}%',
                ),
                SizedBox(height: 5),
                LinearProgressIndicator(
                  value: sudahAbsen / docs.length,
                  backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(10),
                ),
                SizedBox(height: 40),
                Expanded(
                  child: ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var data = docs[index].data() as Map<String, dynamic>;
                      if (data['status'] == 'H') {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: card(
                          selectedStatus: false,
                          nama: data['nama'] ?? '-',
                          nis: data['nis'] ?? '-',
                          foto: data['fotoProfile'] ?? '',
                          currentStatus: data['status'],
                          index: index + 1,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          bottomNavigationBar: Container(
            height: 180,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    boxRekap(
                      totalHadir.toString(),
                      "Hadir",
                      const Color(0xFFFFF8E1),
                    ),
                    boxRekap(
                      totalSakit.toString(),
                      "Sakit",
                      const Color(0xFFFFE0B2),
                    ),
                    boxRekap(
                      totalIzin.toString(),
                      "Izin",
                      const Color(0xFFE1F5FE),
                    ),
                    boxRekap(
                      totalAlpha.toString(),
                      "Alpha",
                      const Color(0xFFFFCDD2),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBA68C8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(12),
                      ),
                    ),
                    child: Text(
                      "Kirim Presensi ($sudahAbsen)",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget boxRekap(String jumlah, String label, Color warna) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            jumlah,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}

class card extends StatelessWidget {
  const card({
    super.key,
    required this.selectedStatus,
    required this.nama,
    required this.nis,
    required this.foto,
    required this.index,
    required this.currentStatus,
  });

  final String nama, nis, foto;
  final int index;
  final bool selectedStatus;
  final String currentStatus;

  Future<void> updateStatusSiswa(String nis, String statusBaru) async {
    try {
      await FirebaseFirestore.instance.collection('siswa').doc(nis).update({
        'status': statusBaru,
      });
      print("Status $nis berhasil di update ke: $statusBaru");
    } catch (e) {
      print("Gagal update status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
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
            Text('$index.'),
            SizedBox(width: 25),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: foto.isNotEmpty ? AssetImage(foto) : null,
              child: foto.isEmpty
                  ? const Icon(Icons.person, size: 40, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "NIS : $nis",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withValues(alpha: 0.25),
                    ),
                  ),
                  SizedBox(height: 7),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _button("H", nis),
                      SizedBox(width: 10),
                      _button("S", nis),
                      SizedBox(width: 10),
                      _button("I", nis),
                      SizedBox(width: 10),
                      _button("A", nis),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button(String label, String nis) {
    bool isActive = currentStatus == label;
    Color activeColor;

    switch (label) {
      case 'H':
        activeColor = Colors.green;
        break;
      case 'S':
        activeColor = Colors.blue;
        break;
      case 'I':
        activeColor = Colors.orange;
        break;
      case 'A':
        activeColor = Colors.red;
        break;
      default:
        activeColor = Colors.black;
    }

    return InkWell(
      onTap: () {
        String statusBaru = (currentStatus == label) ? '' : label;

        updateStatusSiswa(nis, statusBaru);
      },
      customBorder: const CircleBorder(),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: isActive ? activeColor : Colors.black),
          color: isActive ? activeColor : Colors.transparent,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
