import 'package:flutter/material.dart';
import 'package:attend/features/teacher/presentation/screens/exam/teacher_grading_detail_screen.dart';

class TeacherGradingListScreen extends StatefulWidget {
  final String examTitle;
  final String className;

  const TeacherGradingListScreen({
    super.key,
    this.examTitle = 'UTS Pemrograman Web',
    this.className = 'XI RPL 2',
  });

  @override
  State<TeacherGradingListScreen> createState() => _TeacherGradingListScreenState();
}

class _TeacherGradingListScreenState extends State<TeacherGradingListScreen> {
  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color greenStatus = Color(0xFF10B981);
  static const Color redStatus = Color(0xFFEF4444);

  // Tab State
  bool _isNeedGradingTab = true;

  // Dummy Data
  final List<Map<String, dynamic>> _students = [
    {
      'id': '1',
      'name': 'Andi Saputra',
      'avatar': 'https://i.pravatar.cc/150?u=1',
      'status': 'needs_grading', // 'needs_grading', 'graded'
      'pgScore': 60,
    },
    {
      'id': '2',
      'name': 'Budi Santoso',
      'avatar': 'https://i.pravatar.cc/150?u=2',
      'status': 'needs_grading',
      'pgScore': 55,
    },
    {
      'id': '3',
      'name': 'Citra Lestari',
      'avatar': 'https://i.pravatar.cc/150?u=3',
      'status': 'needs_grading',
      'pgScore': 70,
    },
    {
      'id': '4',
      'name': 'Dewi Ayu',
      'avatar': 'https://i.pravatar.cc/150?u=4',
      'status': 'graded',
      'pgScore': 65,
    },
    {
      'id': '5',
      'name': 'Eko Prasetyo',
      'avatar': 'https://i.pravatar.cc/150?u=5',
      'status': 'graded',
      'pgScore': 80,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter students based on active tab
    final filteredStudents = _students.where((s) {
      if (_isNeedGradingTab) return s['status'] == 'needs_grading';
      return s['status'] == 'graded';
    }).toList();

    final needGradingCount = _students.where((s) => s['status'] == 'needs_grading').length;
    final gradedCount = _students.where((s) => s['status'] == 'graded').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              widget.examTitle,
              style: const TextStyle(
                color: textDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.className,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _isNeedGradingTab = true),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _isNeedGradingTab ? primaryBlue : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _isNeedGradingTab
                              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                              : null,
                        ),
                        child: Text(
                          'Perlu Koreksi ($needGradingCount)',
                          style: TextStyle(
                            color: _isNeedGradingTab ? Colors.white : textGrey,
                            fontWeight: _isNeedGradingTab ? FontWeight.bold : FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _isNeedGradingTab = false),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: !_isNeedGradingTab ? primaryBlue : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: !_isNeedGradingTab
                              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                              : null,
                        ),
                        child: Text(
                          'Selesai ($gradedCount)',
                          style: TextStyle(
                            color: !_isNeedGradingTab ? Colors.white : textGrey,
                            fontWeight: !_isNeedGradingTab ? FontWeight.bold : FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Student List
          Expanded(
            child: filteredStudents.isEmpty
                ? Center(
                    child: Text(
                      _isNeedGradingTab 
                        ? 'Semua jawaban telah dikoreksi! 🎉' 
                        : 'Belum ada ujian yang selesai dikoreksi.',
                      style: TextStyle(color: textGrey, fontSize: 14),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];
                      return _buildStudentCard(student, filteredStudents, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student, List<Map<String, dynamic>> allFiltered, int currentIndex) {
    final bool isNeedGrading = student['status'] == 'needs_grading';

    return InkWell(
      onTap: () async {
        // Navigasi ke detail grading (Koreksi)
        // Kita juga mem-passing daftar student yang ada supaya bisa pakai fitur "Simpan & Lanjut"
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherGradingDetailScreen(
              studentsList: allFiltered,
              initialIndex: currentIndex,
            ),
          ),
        );
        
        // Refresh jika ada perubahan status setelah kembali dari layar koreksi
        if (result == true) {
          setState(() {
            // Dalam implementasi nyata, di sini akan memanggil fetch ulang dari database
            // Untuk dummy, list sudah ter-update secara otomatis karena menggunakan referensi objek (namun kita anggap butuh refresh UI saja)
          });
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFF3F4F6),
              backgroundImage: NetworkImage(student['avatar']),
            ),
            const SizedBox(width: 16),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'],
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isNeedGrading ? redStatus.withOpacity(0.1) : greenStatus.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isNeedGrading ? 'Belum Dinilai' : 'Selesai Dinilai',
                      style: TextStyle(
                        color: isNeedGrading ? redStatus : greenStatus,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.chevron_right,
                color: primaryBlue,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
