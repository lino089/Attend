import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:attend/features/teacher/presentation/screens/exam/teacher_grading_list_screen.dart';
import 'package:attend/features/teacher/presentation/screens/exam/models/exam.dart';
import 'package:attend/features/teacher/presentation/screens/exam/models/question.dart';

class TeacherGradingExamListScreen extends StatefulWidget {
  const TeacherGradingExamListScreen({super.key});

  @override
  State<TeacherGradingExamListScreen> createState() => _TeacherGradingExamListScreenState();
}

class _TeacherGradingExamListScreenState extends State<TeacherGradingExamListScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color lightBlueBadge = Color(0xFFE8EEFF);
  static const Color redStatus = Color(0xFFEF4444);

  // Dummy data representing exams with grading status
  final List<Map<String, dynamic>> _examsWithGradingInfo = [
    {
      'exam': Exam(
        id: '1',
        name: 'UTS Pemrograman Web',
        subject: 'Rekayasa Perangkat Lunak',
        duration: 90,
        targetKKM: 75,
        instructions: '',
        questions: List.generate(40, (index) => Question(
          id: index.toString(),
          number: index + 1,
          type: QuestionType.multipleChoice,
          questionText: 'Dummy Soal $index',
          weight: 1,
          options: [],
        )),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      'kelas': 'XI RPL 2',
      'ungradedCount': 12,
    },
    {
      'exam': Exam(
        id: '2',
        name: 'UAS Basis Data',
        subject: 'Rekayasa Perangkat Lunak',
        duration: 120,
        targetKKM: 70,
        instructions: '',
        questions: List.generate(50, (index) => Question(
          id: index.toString(),
          number: index + 1,
          type: QuestionType.multipleChoice,
          questionText: 'Dummy Soal $index',
          weight: 1,
          options: [],
        )),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      'kelas': 'XI RPL 1',
      'ungradedCount': 0,
    },
    {
      'exam': Exam(
        id: '3',
        name: 'Kuis Jaringan Komputer',
        subject: 'Teknik Komputer Jaringan',
        duration: 60,
        targetKKM: 75,
        instructions: '',
        questions: List.generate(20, (index) => Question(
          id: index.toString(),
          number: index + 1,
          type: QuestionType.multipleChoice,
          questionText: 'Dummy Soal $index',
          weight: 1,
          options: [],
        )),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      'kelas': 'X TKJ 1',
      'ungradedCount': 5,
    },
  ];

  List<Map<String, dynamic>> _filteredExams = [];

  @override
  void initState() {
    super.initState();
    _filteredExams = _examsWithGradingInfo;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterExams(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredExams = _examsWithGradingInfo;
      } else {
        _filteredExams = _examsWithGradingInfo
            .where((item) {
              final exam = item['exam'] as Exam;
              return exam.name.toLowerCase().contains(query.toLowerCase()) ||
                     exam.subject.toLowerCase().contains(query.toLowerCase());
            })
            .toList();
      }
    });
  }

  void _navigateToGradingList(Map<String, dynamic> examInfo) {
    final exam = examInfo['exam'] as Exam;
    final kelas = examInfo['kelas'] as String;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherGradingListScreen(
          examTitle: exam.name,
          className: kelas,
        ),
      ),
    );
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
          'Pilih Ujian',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama ujian...',
                hintStyle: TextStyle(
                  color: textGrey.withOpacity(0.6),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: textGrey.withOpacity(0.6),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: primaryBlue, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              onChanged: _filterExams,
            ),
          ),

          // Exam List
          Expanded(
            child: _filteredExams.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredExams.length,
                    itemBuilder: (context, index) {
                      return _buildGradingExamCard(_filteredExams[index]);
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.grading_outlined,
              size: 64,
              color: primaryBlue.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Ujian tidak ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pastikan kata kunci pencarian benar.',
            style: TextStyle(
              fontSize: 14,
              color: textGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGradingExamCard(Map<String, dynamic> examInfo) {
    final exam = examInfo['exam'] as Exam;
    final int ungradedCount = examInfo['ungradedCount'];
    
    final dateFormat = DateFormat('dd MMM yyyy');
    final formattedDate = dateFormat.format(exam.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: ungradedCount > 0 
            ? Border.all(color: redStatus.withOpacity(0.3), width: 1)
            : Border.all(color: Colors.transparent),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToGradingList(examInfo),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Exam Name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        exam.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Indicator Badge
                    if (ungradedCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: redStatus.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$ungradedCount Belum Dinilai',
                          style: const TextStyle(
                            color: redStatus,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1), // Green status
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Selesai',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Subject Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: lightBlueBadge,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    exam.subject,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Stats Row
                Row(
                  children: [
                    // Total Questions
                    _buildStatItem(
                      Icons.quiz_outlined,
                      '${exam.totalQuestions} Soal',
                    ),
                    const SizedBox(width: 16),
                    // Duration
                    _buildStatItem(
                      Icons.access_time,
                      '${exam.duration} Menit',
                    ),
                    const SizedBox(width: 16),
                    // KKM
                    _buildStatItem(
                      Icons.grade_outlined,
                      'KKM ${exam.targetKKM}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Divider
                Divider(color: Colors.grey.shade200, height: 1),
                const SizedBox(height: 12),

                // Footer: Created Date & Icon Arrow
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: textGrey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Dibuat: $formattedDate',
                          style: const TextStyle(
                            fontSize: 12,
                            color: textGrey,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: textGrey,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: textGrey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
