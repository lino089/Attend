import 'package:flutter/material.dart';

class AttendanceReportModel {
  final String id;
  final String studentName;
  final String className;
  final String nis;
  final String status;
  final String avatarUrl;

  AttendanceReportModel({
    required this.id,
    required this.studentName,
    required this.className,
    required this.nis,
    required this.status,
    required this.avatarUrl,
  });
}

final List<AttendanceReportModel> dummyReport = [
  AttendanceReportModel(
    id: 'R01',
    studentName: 'Aditya Prasetya Wibawa',
    className: 'XI RPL 2',
    nis: '17792',
    status: 'SAKIT',
    avatarUrl: "https://i.pravatar.cc/150?img=11",
  ),
  AttendanceReportModel(
    id: 'R02',
    studentName: 'Bunga Citra Lestari',
    className: 'XI RPL 2',
    nis: '17795',
    status: 'Alpha',
    avatarUrl: "https://i.pravatar.cc/150?img=5",
  ),
  AttendanceReportModel(
    id: 'R02',
    studentName: 'Dimas Anggara Putra',
    className: 'XI RPL 2',
    nis: '17801',
    status: 'IZIN',
    avatarUrl: "https://i.pravatar.cc/150?img=12",
  ),
];

class AdminAttandanceReportScreen extends StatefulWidget {
  const AdminAttandanceReportScreen({super.key});

  @override
  State<AdminAttandanceReportScreen> createState() =>
      _AdminAttandanceReportScreen();
}

class _AdminAttandanceReportScreen extends State<AdminAttandanceReportScreen> {
  bool _isLoading = true;
  List<AttendanceReportModel> _reports = [];

  @override
  void initState() {
    super.initState();
    _fecthReports();
  }

  Future<void> _fecthReports() async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _reports = List.from(dummyReport);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int countSakit = _reports.where((r) => r.status == 'SAKIT').length;
    int countIzin = _reports.where((r) => r.status == 'IZIN').length;
    int countAlpha = _reports.where((r) => r.status == 'ALPHA').length;

    return Scaffold(
      backgroundColor: const Color(0xfff7f8fa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xff1f2937)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Laporan Presensi',
          style: TextStyle(
            color: Color(0xff1f2937),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 20),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff4a65e5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 8,
            shadowColor: const Color(0xff4a65e5).withOpacity(0.5),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Tambah Manual',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: Color(0xff4a65e5),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Senin, 16 Des 2025',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1f2937),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Semua Kelas',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1f2937),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.search_rounded,
                        color: Colors.grey.shade500,
                        size: 20,
                      ),
                      hintText: 'Cari nama atau NIS',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Color(0xff6b7280),
                ),
                children: [
                  const TextSpan(text: 'Total Hari Ini: '),
                  TextSpan(
                    text: '$countSakit SAKIT',
                    style: const TextStyle(color: Color(0xffe91e63)),
                  ),
                  const TextSpan(text: ' , '),
                  TextSpan(
                    text: '$countIzin IZIN',
                    style: const TextStyle(color: Color(0xff5c6bc0)),
                  ),
                  const TextSpan(text: ' , '),
                  TextSpan(
                    text: '$countAlpha ALPHA',
                    style: const TextStyle(color: Color(0xffe53935)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xff4a65e5)),
                  )
                : _reports.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada data presensi',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 80,
                    ),
                    itemCount: _reports.length,
                    itemBuilder: (context, index) {
                      return _buildReportCard(_reports[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(AttendanceReportModel report) {
    Color badgeColor;
    switch (report.status) {
      case 'SAKIT':
        badgeColor = const Color(0xfff48fb1);
        break;
      case 'ALPHA':
        badgeColor = const Color(0xfff06292);
      case 'IZIN':
        badgeColor = const Color(0xffb39ddb);
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(report.avatarUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.studentName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1f2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${report.className} • NIS: ${report.nis}",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xff6b7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              report.status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
