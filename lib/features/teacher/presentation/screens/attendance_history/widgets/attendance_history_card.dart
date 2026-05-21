import 'package:flutter/material.dart';
import '../models/attendance_history_model.dart';

class AttendanceHistoryCard extends StatelessWidget {
  final AttendanceHistoryModel history;
  final VoidCallback onTap;

  const AttendanceHistoryCard({
    super.key,
    required this.history,
    required this.onTap,
  });

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color greenBadge = Color(0xFF10B981);
  static const Color greyBadge = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    final badgeColor = history.isGoodAttendance ? greenBadge : greyBadge;
    final badgeText = '${history.presentCount}/${history.totalStudents} Hadir';

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
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject name and attendance badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    history.subjectName,
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
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date and time
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: textGrey,
                ),
                const SizedBox(width: 6),
                Text(
                  '${history.formattedDate} • ${history.timeRange}',
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
                      history.className,
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
