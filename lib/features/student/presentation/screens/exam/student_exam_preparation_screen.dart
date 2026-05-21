import 'package:flutter/material.dart';
import 'models/student_exam_model.dart';
import 'student_exam_active_screen.dart';

class StudentExamPreparationScreen extends StatelessWidget {
  final StudentExamModel exam;

  const StudentExamPreparationScreen({
    super.key,
    required this.exam,
  });

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color warningBg = Color(0xFFFEF3C7); // Light yellow
  static const Color warningText = Color(0xFFB45309); // Dark orange

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
          'Persiapan Ujian',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Large Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 60,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 24),

            // Exam Title
            Text(
              exam.examTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),

            // Subject
            Text(
              exam.subject,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: textGrey,
              ),
            ),
            const SizedBox(height: 32),

            // Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Duration Info
                  _buildInfoRow(
                    icon: Icons.access_time,
                    label: 'Durasi Ujian',
                    value: exam.formattedDuration,
                  ),
                  const SizedBox(height: 16),

                  // Question Breakdown
                  _buildInfoRow(
                    icon: Icons.assignment_outlined,
                    label: 'Jumlah Soal',
                    value: '${exam.questionCount} Soal',
                  ),
                  const SizedBox(height: 12),

                  // Multiple Choice Count
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: textGrey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Pilihan Ganda: ${exam.multipleChoiceCount} Soal',
                          style: const TextStyle(
                            fontSize: 14,
                            color: textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Essay Count
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: textGrey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Essay: ${exam.essayCount} Soal',
                          style: const TextStyle(
                            fontSize: 14,
                            color: textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Deadline Info
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Batas Waktu',
                    value: exam.deadlineText.replaceFirst('Batas: ', ''),
                    valueColor: exam.deadlineColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Warning Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: warningBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: warningText.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: warningText,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Perhatian!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: warningText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pastikan koneksi internet stabil. Ujian hanya dapat dikerjakan sekali dan tidak dapat diulang.',
                          style: TextStyle(
                            fontSize: 13,
                            color: warningText,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Start Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to exam taking screen
                  _startExam(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Mulai Kerjakan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  side: const BorderSide(color: textGrey, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Batal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textGrey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: textGrey,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: textGrey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _startExam(BuildContext context) {
    // Konversi StudentExamModel ke format yang dibutuhkan StudentExamActiveScreen
    final Map<String, dynamic> examData = {
      'examTitle': exam.examTitle,
      'subject': exam.subject,
      'duration': exam.durationMinutes, // dalam menit
      'pgCount': exam.multipleChoiceCount,
      'essayCount': exam.essayCount,
    };

    // Navigate to exam active screen (exam taking screen)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentExamActiveScreen(examData: examData),
      ),
    );
  }
}
