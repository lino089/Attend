import 'package:flutter/material.dart';
import '../models/attendance_summary_model.dart';

class AttendanceSummaryCard extends StatelessWidget {
  final AttendanceSummaryModel summary;

  const AttendanceSummaryCard({
    super.key,
    required this.summary,
  });

  static const Color primaryBlue = Color(0xFF335CFA);
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
          // Total Kelas Diajar
          const Text(
            'Total Kelas Diajar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            summary.totalClassesTaught.toString(),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 20),
          
          // Rata-rata Kehadiran
          const Text(
            'RATA-RATA KEHADIRAN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            summary.formattedAverageAttendance,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
