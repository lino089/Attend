import 'package:flutter/material.dart';
import 'models/exam_history_model.dart';
import 'models/exam_summary_model.dart';
import 'widgets/exam_summary_card.dart';
import 'widgets/exam_history_card.dart';

class TeacherExamHistoryScreen extends StatefulWidget {
  const TeacherExamHistoryScreen({super.key});

  @override
  State<TeacherExamHistoryScreen> createState() =>
      _TeacherExamHistoryScreenState();
}

class _TeacherExamHistoryScreenState extends State<TeacherExamHistoryScreen> {
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  String _selectedClass = 'Semua Kelas';
  String _selectedStatus = 'Semua Status';

  // TODO: Replace with API call to fetch exam summary
  final ExamSummaryModel _summary = ExamSummaryModel(
    totalExams: 8,
    pendingGradingCount: 2,
  );

  // TODO: Replace with API call to fetch exam history
  final List<ExamHistoryModel> _examList = [
    ExamHistoryModel(
      id: '1',
      examName: 'UTS Pemrograman Web',
      className: 'XI RPL 2',
      date: DateTime(2023, 10, 16),
      durationMinutes: 90,
      status: ExamStatus.notGraded,
      notGradedCount: 12,
      totalStudents: 32,
    ),
    ExamHistoryModel(
      id: '2',
      examName: 'Ulangan Harian Basis Data',
      className: 'XI RPL 1',
      date: DateTime(2023, 10, 14),
      durationMinutes: 60,
      status: ExamStatus.graded,
    ),
    ExamHistoryModel(
      id: '3',
      examName: 'UAS Jaringan Komputer',
      className: 'XII RPL 3',
      date: DateTime(2023, 10, 18),
      durationMinutes: 120,
      status: ExamStatus.notGraded,
      notGradedCount: 8,
      totalStudents: 30,
    ),
    ExamHistoryModel(
      id: '4',
      examName: 'Quiz Pemrograman Berorientasi Objek',
      className: 'XI RPL 2',
      date: DateTime(2023, 10, 12),
      durationMinutes: 45,
      status: ExamStatus.graded,
    ),
    ExamHistoryModel(
      id: '5',
      examName: 'Ulangan Tengah Semester Sistem Operasi',
      className: 'XII RPL 1',
      date: DateTime(2023, 10, 20),
      durationMinutes: 90,
      status: ExamStatus.graded,
    ),
  ];

  List<ExamHistoryModel> get _filteredExams {
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
                // Class Filter
                Expanded(
                  child: _buildFilterDropdown(
                    value: _selectedClass,
                    items: [
                      'Semua Kelas',
                      'XI RPL 1',
                      'XI RPL 2',
                      'XII RPL 1',
                      'XII RPL 3',
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedClass = value!;
                      });
                      // TODO: Implement filter by class
                    },
                  ),
                ),
                const SizedBox(width: 16),
                
                // Status Filter
                Expanded(
                  child: _buildFilterDropdown(
                    value: _selectedStatus,
                    items: [
                      'Semua Status',
                      'Belum Dinilai',
                      'Selesai Dinilai',
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                      // TODO: Implement filter by status
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
                        // Summary Card
                        ExamSummaryCard(summary: _summary),
                        const SizedBox(height: 24),

                        // Exam History List
                        ..._filteredExams.map((exam) {
                          return ExamHistoryCard(
                            exam: exam,
                            onTap: () {
                              // TODO: Navigate to exam grading/detail screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    exam.isGraded
                                        ? 'Lihat hasil: ${exam.examName}'
                                        : 'Mulai penilaian: ${exam.examName}',
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
          icon: Icon(Icons.keyboard_arrow_down, color: textGrey, size: 20),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
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
