import 'package:flutter/material.dart';
import 'teacher_grade_report_detail_screen.dart';

class TeacherGradeReportListScreen extends StatefulWidget {
  const TeacherGradeReportListScreen({super.key});

  @override
  State<TeacherGradeReportListScreen> createState() =>
      _TeacherGradeReportListScreenState();
}

class _TeacherGradeReportListScreenState extends State<TeacherGradeReportListScreen> {
  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color bgGrey = Color(0xFFF8F9FA);

  String _searchQuery = '';
  String _selectedClass = 'Semua Kelas';

  // Dummy exam data
  final List<Map<String, dynamic>> _exams = [
    {
      'id': 'exam_1',
      'name': 'UTS Pemrograman Web',
      'subject': 'Web Programming',
      'className': 'XII RPL 1',
      'targetKKM': 75,
      'date': '18 Mei 2026',
      'totalStudents': 32,
      'status': 'Selesai Dinilai',
      'averageScore': 81.5,
    },
    {
      'id': 'exam_2',
      'name': 'Ulangan Harian Basis Data',
      'subject': 'Database System',
      'className': 'XI RPL 2',
      'targetKKM': 70,
      'date': '14 Mei 2026',
      'totalStudents': 30,
      'status': 'Selesai Dinilai',
      'averageScore': 78.2,
    },
    {
      'id': 'exam_3',
      'name': 'UAS Jaringan Komputer',
      'subject': 'Computer Network',
      'className': 'XII RPL 3',
      'targetKKM': 75,
      'date': '19 Mei 2026',
      'totalStudents': 32,
      'status': 'Belum Dinilai',
      'averageScore': 0.0,
    },
    {
      'id': 'exam_4',
      'name': 'Quiz Pemrograman OOP',
      'subject': 'Object-Oriented Programming',
      'className': 'XI RPL 2',
      'targetKKM': 75,
      'date': '10 Mei 2026',
      'totalStudents': 30,
      'status': 'Selesai Dinilai',
      'averageScore': 83.4,
    },
  ];

  List<Map<String, dynamic>> get _filteredExams {
    return _exams.where((exam) {
      final matchesSearch = exam['name']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          exam['subject'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesClass =
          _selectedClass == 'Semua Kelas' || exam['className'] == _selectedClass;
      return matchesSearch && matchesClass;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rekap Nilai Siswa',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter & Search Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // Search Input
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari nama ujian atau mata pelajaran...',
                    hintStyle: const TextStyle(color: textGrey, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: textGrey),
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Class filter dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedClass,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, color: textGrey),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                      items: [
                        'Semua Kelas',
                        'XI RPL 2',
                        'XII RPL 1',
                        'XII RPL 3',
                      ].map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedClass = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // List content
          Expanded(
            child: _filteredExams.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredExams.length,
                    itemBuilder: (context, index) {
                      final exam = _filteredExams[index];
                      final isGraded = exam['status'] == 'Selesai Dinilai';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
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
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeacherGradeReportDetailScreen(
                                    examData: exam,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: primaryBlue.withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          exam['className'],
                                          style: const TextStyle(
                                            color: primaryBlue,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isGraded
                                              ? const Color(0xFFECFDF5)
                                              : const Color(0xFFFEF3C7),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          exam['status'],
                                          style: TextStyle(
                                            color: isGraded
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFFD97706),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    exam['name'],
                                    style: const TextStyle(
                                      color: textDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    exam['subject'],
                                    style: const TextStyle(
                                      color: textGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'KKM',
                                            style: TextStyle(color: textGrey, fontSize: 11),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${exam['targetKKM']}',
                                            style: const TextStyle(
                                              color: textDark,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Peserta',
                                            style: TextStyle(color: textGrey, fontSize: 11),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${exam['totalStudents']} Siswa',
                                            style: const TextStyle(
                                              color: textDark,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Rata-rata Kelas',
                                            style: TextStyle(color: textGrey, fontSize: 11),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            isGraded ? '${exam['averageScore']}' : '-',
                                            style: TextStyle(
                                              color: isGraded ? const Color(0xFF10B981) : textDark,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.table_rows_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Ujian Tidak Ditemukan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textGrey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sesuaikan pencarian atau filter kelas Anda.',
            style: TextStyle(fontSize: 14, color: textGrey),
          ),
        ],
      ),
    );
  }
}
