import 'package:flutter/material.dart';
import '../models/student_exam_history_model.dart';

class StudentExamHistoryCard extends StatelessWidget {
  final StudentExamHistoryModel exam;
  final VoidCallback onTap;

  const StudentExamHistoryCard({
    super.key,
    required this.exam,
    required this.onTap,
  });

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
            // Exam name and score badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    exam.examName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildScoreBadge(),
              ],
            ),
            const SizedBox(height: 12),

            // Date and duration
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: textGrey,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${exam.formattedDate} • ${exam.formattedDuration}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: textGrey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Subject name and arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 18,
                      color: primaryBlue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      exam.subjectName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.chevron_right,
                  color: textGrey,
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: exam.scoreBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        exam.scoreText,
        style: TextStyle(
          fontSize: exam.isGraded ? 16 : 10,
          fontWeight: FontWeight.bold,
          color: exam.scoreColor,
          letterSpacing: exam.isGraded ? 0 : 0.5,
        ),
      ),
    );
  }
}
