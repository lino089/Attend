import 'package:flutter/material.dart';
import '../models/exam_summary_model.dart';

class ExamSummaryCard extends StatelessWidget {
  final ExamSummaryModel summary;

  const ExamSummaryCard({
    super.key,
    required this.summary,
  });

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color orangeStatus = Color(0xFFEA580C);
  static const Color lightBlueBg = Color(0xFFE8EEFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: lightBlueBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Ujian
          Text(
            'Total Ujian: ${summary.totalExams}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          
          // Menunggu Penilaian (if any)
          if (summary.hasPendingGrading) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: orangeStatus,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  summary.pendingText,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: orangeStatus,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
