import 'package:flutter/material.dart';
import 'models/student_exam_history_model.dart';
import 'widgets/student_exam_history_card.dart';

class StudentExamHistoryScreen extends StatefulWidget {
  const StudentExamHistoryScreen({super.key});

  @override
  State<StudentExamHistoryScreen> createState() =>
      _StudentExamHistoryScreenState();
}

class _StudentExamHistoryScreenState extends State<StudentExamHistoryScreen> {
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  String _selectedSubject = 'Semua Mata Pelajaran';
  String _selectedPeriod = 'Semua Periode';

  // TODO: Replace with API call to fetch exam history
  final List<StudentExamHistoryModel> _examList = [
    StudentExamHistoryModel(
      id: '1',
      examName: 'UTS Pemrograman Web',
      subjectName: 'Pemrograman Web',
      date: DateTime(2023, 10, 16),
      durationMinutes: 90,
      score: 85,
      maxScore: 100,
    ),
    StudentExamHistoryModel(
      id: '2',
      examName: 'Ulangan Harian Basis Data',
      subjectName: 'Basis Data',
      date: DateTime(2023, 10, 14),
      durationMinutes: 60,
      score: 92,
      maxScore: 100,
    ),
    StudentExamHistoryModel(
      id: '3',
      examName: 'Quiz Jaringan Komputer',
      subjectName: 'Jaringan Komputer',
      date: DateTime(2023, 10, 18),
      durationMinutes: 45,
      score: null, // Belum dinilai
      maxScore: 100,
    ),
    StudentExamHistoryModel(
      id: '4',
      examName: 'UAS Pemrograman Berorientasi Objek',
      subjectName: 'Pemrograman Berorientasi Objek',
      date: DateTime(2023, 10, 12),
      durationMinutes: 120,
      score: 78,
      maxScore: 100,
    ),
    StudentExamHistoryModel(
      id: '5',
      examName: 'Ulangan Tengah Semester Sistem Operasi',
      subjectName: 'Sistem Operasi',
      date: DateTime(2023, 10, 20),
      durationMinutes: 90,
      score: 55,
      maxScore: 100,
    ),
  ];

  List<StudentExamHistoryModel> get _filteredExams {
    // TODO: Implement actual filtering logic
    return _examList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat Ujian',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: textDark),
            onPressed: () {
              // TODO: Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur pencarian akan segera hadir'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Row(
              children: [
                // Subject Filter
                Expanded(
                  child: _buildFilterDropdown(
                    value: _selectedSubject,
                    items: [
                      'Semua Mata Pelajaran',
                      'Pemrograman Web',
                      'Basis Data',
                      'Jaringan Komputer',
                      'Pemrograman Berorientasi Objek',
                      'Sistem Operasi',
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedSubject = value!;
                      });
                      // TODO: Implement filter by subject
                    },
                  ),
                ),
                const SizedBox(width: 16),

                // Period Filter
                Expanded(
                  child: _buildFilterDropdown(
                    value: _selectedPeriod,
                    items: [
                      'Semua Periode',
                      'Oktober 2023',
                      'September 2023',
                      'Agustus 2023',
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedPeriod = value!;
                      });
                      // TODO: Implement filter by period
                    },
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _filteredExams.isEmpty
                ? _buildEmptyState()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Exam History List
                        ..._filteredExams.map((exam) {
                          return StudentExamHistoryCard(
                            exam: exam,
                            onTap: () {
                              // TODO: Navigate to exam detail/result screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    exam.isGraded
                                        ? 'Lihat hasil: ${exam.examName}'
                                        : 'Ujian belum dinilai: ${exam.examName}',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: textGrey, size: 20),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Riwayat Ujian',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Riwayat ujian akan muncul di sini',
            style: TextStyle(
              fontSize: 14,
              color: textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
