import 'package:flutter/material.dart';
import '../models/exam_history_model.dart';

class ExamHistoryCard extends StatelessWidget {
  final ExamHistoryModel exam;
  final VoidCallback onTap;

  const ExamHistoryCard({
    super.key,
    required this.exam,
    required this.onTap,
  });

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color orangeStatus = Color(0xFFEA580C);
  static const Color greenStatus = Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    final statusColor = exam.isGraded ? greenStatus : orangeStatus;
    final statusBgColor = exam.isGraded 
        ? greenStatus.withValues(alpha: 0.1)
        : orangeStatus.withValues(alpha: 0.1);

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
            // Exam name and status badge
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    exam.statusText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date and duration
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: textGrey,
                ),
                const SizedBox(width: 6),
                Text(
                  '${exam.formattedDate} • ${exam.formattedDuration}',
                  style: TextStyle(
                    fontSize: 13,
                    color: textGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Class name and arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 18,
                      color: primaryBlue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      exam.className,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                Icon(
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
}
