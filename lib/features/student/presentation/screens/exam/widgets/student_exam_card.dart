import 'package:flutter/material.dart';
import '../models/student_exam_model.dart';

class StudentExamCard extends StatelessWidget {
  final StudentExamModel exam;
  final VoidCallback onTap;

  const StudentExamCard({
    super.key,
    required this.exam,
    required this.onTap,
  });

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Exam Title
          Text(
            exam.examTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 6),

          // Subject
          Text(
            exam.subject,
            style: const TextStyle(
              fontSize: 14,
              color: textGrey,
            ),
          ),
          const SizedBox(height: 16),

          // Info Row 1: Duration and Question Count
          Row(
            children: [
              // Duration
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: textGrey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    exam.formattedDuration,
                    style: const TextStyle(
                      fontSize: 13,
                      color: textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),

              // Question Count
              Row(
                children: [
                  const Icon(
                    Icons.assignment_outlined,
                    size: 16,
                    color: textGrey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    exam.formattedQuestions,
                    style: const TextStyle(
                      fontSize: 13,
                      color: textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Info Row 2: Deadline
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: exam.deadlineColor,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  exam.deadlineText,
                  style: TextStyle(
                    fontSize: 13,
                    color: exam.deadlineColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: exam.isOverdue ? null : onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                exam.isOverdue ? 'Waktu Habis' : 'Ikuti Ujian',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: exam.isOverdue ? textGrey : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
