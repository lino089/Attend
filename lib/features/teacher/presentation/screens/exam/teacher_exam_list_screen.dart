import 'package:flutter/material.dart';
import 'package:attend/features/teacher/presentation/screens/exam/create_exam_step1_screen.dart';
import 'package:attend/features/teacher/presentation/screens/exam/edit_exam_screen.dart';
import 'package:attend/features/teacher/presentation/screens/exam/models/exam.dart';
import 'package:intl/intl.dart';

class TeacherExamListScreen extends StatefulWidget {
  const TeacherExamListScreen({super.key});

  @override
  State<TeacherExamListScreen> createState() => _TeacherExamListScreenState();
}

class _TeacherExamListScreenState extends State<TeacherExamListScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // List of exams
  final List<Exam> _exams = [];
  List<Exam> _filteredExams = [];

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color lightBlueBadge = Color(0xFFE8EEFF);

  @override
  void initState() {
    super.initState();
    _filteredExams = _exams;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToCreateExam() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateExamStep1Screen(),
      ),
    );

    if (result != null && result is Exam) {
      setState(() {
        _exams.add(result);
        _filterExams(_searchController.text);
      });
    }
  }

  void _navigateToEditExam(Exam exam) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExamScreen(exam: exam),
      ),
    );

    if (result != null && result is Exam) {
      setState(() {
        final index = _exams.indexWhere((e) => e.id == exam.id);
        if (index != -1) {
          _exams[index] = result;
          _filterExams(_searchController.text);
        }
      });
    }
  }

  void _filterExams(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredExams = _exams;
      } else {
        _filteredExams = _exams
            .where((exam) =>
                exam.name.toLowerCase().contains(query.toLowerCase()) ||
                exam.subject.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _deleteExam(String examId) {
    setState(() {
      _exams.removeWhere((exam) => exam.id == examId);
      _filterExams(_searchController.text);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ujian berhasil dihapus'),
        duration: Duration(seconds: 2),
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
          'Bank Ujian',
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

          // Exam List or Empty State
          Expanded(
            child: _filteredExams.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredExams.length,
                    itemBuilder: (context, index) {
                      return _buildExamCard(_filteredExams[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateExam,
        backgroundColor: primaryBlue,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
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
              Icons.description_outlined,
              size: 64,
              color: primaryBlue.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum ada ujian',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap tombol + untuk membuat ujian baru',
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

  Widget _buildExamCard(Exam exam) {
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
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // TODO: Navigate to exam detail screen
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Exam Name & Actions
                Row(
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
                    // Edit Button
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      color: primaryBlue,
                      onPressed: () => _navigateToEditExam(exam),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    // Delete Button
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: Colors.red,
                      onPressed: () {
                        _showDeleteConfirmation(exam);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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

                // Footer: Created Date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: textGrey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Dibuat: $formattedDate',
                      style: TextStyle(
                        fontSize: 12,
                        color: textGrey,
                      ),
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
          style: TextStyle(
            fontSize: 12,
            color: textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(Exam exam) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Hapus Ujian?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ujian "${exam.name}"? Tindakan ini tidak dapat dibatalkan.',
          style: TextStyle(color: textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: textGrey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteExam(exam.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
