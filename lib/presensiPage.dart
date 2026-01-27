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
      body: Padding(
        padding: const EdgeInsets.only(top: 30, right: 15, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progres Presensi'),
            SizedBox(height: 5),
            LinearProgressIndicator(
              value: 0.0,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
            SizedBox(height: 40),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('siswa')
                    .orderBy('id')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return const Text('Error mengambil data');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var data = docs[index].data() as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
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
        updateStatusSiswa(nis, label);
      },
      customBorder: const CircleBorder(),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: isActive ? activeColor : Colors.black,),
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
