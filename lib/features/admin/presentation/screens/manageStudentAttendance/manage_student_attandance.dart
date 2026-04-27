import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageStudentAttendancePage extends StatefulWidget {
  const ManageStudentAttendancePage({Key? key}) : super(key: key);

  @override
  State<ManageStudentAttendancePage> createState() => _ManageStudentAttendancePageState();
}

class _ManageStudentAttendancePageState extends State<ManageStudentAttendancePage> {
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;

  // Data Rekap
  int _totalPermit = 12;
  int _totalSick = 8;
  int _totalAlpa = 5;

  // List Kelas
  List<Map<String, dynamic>> _classList = [
    {"className": "XII RPL 1", "permit": 2, "sick": 1, "alpa": 0},
    {"className": "XII RPL 2", "permit": 0, "sick": 2, "alpa": 3},
    {"className": "XI TKJ 1", "permit": 5, "sick": 0, "alpa": 1},
    {"className": "XI TKJ 2", "permit": 1, "sick": 4, "alpa": 0},
    {"className": "X MM 1", "permit": 4, "sick": 1, "alpa": 1},
  ];

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color bgLight = Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();
    _fetchAttendanceByDate();
  }

  Future<void> _fetchAttendanceByDate() async {
    setState(() => _isLoading = true);
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.white,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchAttendanceByDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kelola Presensi Siswa',
          style: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. DROPDOWN TANGGAL
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: InkWell(
              onTap: () => _selectDate(context),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, color: primaryBlue, size: 24),
                    const SizedBox(width: 16),
                    Text(
                      DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate),
                      style: const TextStyle(color: textDark, fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: textGrey),
                  ],
                ),
              ),
            ),
          ),

          // 2. SUMMARY TAGS (Horizontal, Sesuai Desain)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                _buildSummaryCard('Izin', _totalPermit, const Color(0xFF335CFA), const Color(0xFFEEF2FF)),
                const SizedBox(width: 12),
                _buildSummaryCard('Sakit', _totalSick, const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
                const SizedBox(width: 12),
                _buildSummaryCard('Alpa', _totalAlpa, const Color(0xFFEF4444), const Color(0xFFFEE2E2)),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 3. LIST KELAS
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: primaryBlue))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: _classList.length,
                    itemBuilder: (context, index) {
                      return _buildClassCard(_classList[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // WIDGET KOTAK RINGKASAN
  Widget _buildSummaryCard(String label, int count, Color color, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(color: textGrey, fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(count.toString(), style: const TextStyle(color: textDark, fontSize: 24, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  // WIDGET KARTU KELAS
  Widget _buildClassCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          // TODO: Munculkan Modal Bottom Sheet Daftar Siswa
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['className'],
                    style: const TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  // DI SINI PERBAIKANNYA: Teks tidak lagi disingkat
                  Row(
                    children: [
                      _smallCountBadge('Izin', item['permit'], const Color(0xFF335CFA), const Color(0xFFEEF2FF)),
                      const SizedBox(width: 12),
                      _smallCountBadge('Sakit', item['sick'], const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
                      const SizedBox(width: 12),
                      _smallCountBadge('Alpa', item['alpa'], const Color(0xFFEF4444), const Color(0xFFFEE2E2)),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET BADGE Izin/Sakit/Alpa
  Widget _smallCountBadge(String label, int count, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 6, height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            "$label : $count", // Menampilkan teks lengkap (contoh: Izin : 2)
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}