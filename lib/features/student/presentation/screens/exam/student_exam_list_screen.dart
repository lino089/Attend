import 'package:flutter/material.dart';
import 'models/student_exam_model.dart';
import 'widgets/student_exam_card.dart';
import 'student_exam_preparation_screen.dart';

class StudentExamListScreen extends StatefulWidget {
  const StudentExamListScreen({super.key});

  @override
  State<StudentExamListScreen> createState() => _StudentExamListScreenState();
}

class _StudentExamListScreenState extends State<StudentExamListScreen> {
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  // TODO: Replace with API call to fetch available exams
  final List<StudentExamModel> _examList = [
    StudentExamModel(
      id: '1',
      examTitle: 'UTS Pemrograman Web',
      subject: 'Rekayasa Perangkat Lunak',
      durationMinutes: 90,
      questionCount: 45,
      multipleChoiceCount: 35,
      essayCount: 10,
      deadline: DateTime.now().add(const Duration(hours: 5)), // Hari ini
      isCompleted: false,
    ),
    StudentExamModel(
      id: '2',
      examTitle: 'Kuis Jaringan Dasar',
      subject: 'Teknik Komputer Jaringan',
      durationMinutes: 45,
      questionCount: 20,
      multipleChoiceCount: 15,
      essayCount: 5,
      deadline: DateTime.now().add(const Duration(days: 1, hours: 12)), // Besok
      isCompleted: false,
    ),
    StudentExamModel(
      id: '3',
      examTitle: 'Ulangan Harian Basis Data',
      subject: 'Basis Data',
      durationMinutes: 60,
      questionCount: 30,
      multipleChoiceCount: 25,
      essayCount: 5,
      deadline: DateTime.now().add(const Duration(days: 2)),
      isCompleted: false,
    ),
    StudentExamModel(
      id: '4',
      examTitle: 'Quiz Matematika',
      subject: 'Matematika',
      durationMinutes: 30,
      questionCount: 15,
      multipleChoiceCount: 12,
      essayCount: 3,
      deadline: DateTime.now().add(const Duration(days: 3)),
      isCompleted: false,
    ),
  ];

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
          'Daftar Ujian',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _examList.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _examList.length,
              itemBuilder: (context, index) {
                final exam = _examList[index];
                return StudentExamCard(
                  exam: exam,
                  onTap: () {
                    // TODO: Navigate to exam taking screen
                    _startExam(exam);
                  },
                );
              },
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
            'Belum Ada Ujian',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Daftar ujian akan muncul di sini',
            style: TextStyle(
              fontSize: 14,
              color: textGrey,
            ),
          ),
        ],
      ),
    );
  }

  void _startExam(StudentExamModel exam) {
    // Check if exam is still available
    if (exam.isOverdue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Waktu ujian sudah habis'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (exam.isCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ujian sudah dikerjakan'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Navigate to exam preparation screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentExamPreparationScreen(exam: exam),
      ),
    );
  }
}
