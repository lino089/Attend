import 'package:flutter/material.dart';

class StudentExamModel {
  final String id;
  final String examTitle; // "UTS Pemrograman Web"
  final String subject; // "Rekayasa Perangkat Lunak"
  final int durationMinutes; // 90
  final int questionCount; // 45
  final int multipleChoiceCount; // Jumlah soal pilihan ganda
  final int essayCount; // Jumlah soal essay
  final DateTime deadline; // Batas waktu
  final bool isCompleted; // Sudah dikerjakan atau belum

  StudentExamModel({
    required this.id,
    required this.examTitle,
    required this.subject,
    required this.durationMinutes,
    required this.questionCount,
    required this.multipleChoiceCount,
    required this.essayCount,
    required this.deadline,
    this.isCompleted = false,
  });

  // Format duration
  String get formattedDuration => '$durationMinutes Menit';

  // Format question count
  String get formattedQuestions => '$questionCount Soal';

  // Format deadline text
  String get deadlineText {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.isNegative) {
      return 'Batas: Sudah Lewat';
    } else if (difference.inHours < 24) {
      // "Batas: Hari Ini, 23:59 WIB"
      return 'Batas: Hari Ini, ${_formatTime(deadline)} WIB';
    } else if (difference.inDays == 1) {
      // "Batas: Besok, 12:00 WIB"
      return 'Batas: Besok, ${_formatTime(deadline)} WIB';
    } else {
      // "Batas: Senin, 16 Okt, 15:00 WIB"
      return 'Batas: ${_formatDate(deadline)}, ${_formatTime(deadline)} WIB';
    }
  }

  // Get deadline color based on urgency
  Color get deadlineColor {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.isNegative) {
      return const Color(0xFFEF4444); // Red - Overdue
    } else if (difference.inHours < 24) {
      return const Color(0xFFEA580C); // Orange - Urgent
    } else {
      return const Color(0xFFF59E0B); // Yellow - Normal
    }
  }

  // Check if exam is urgent (< 24 hours)
  bool get isUrgent {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    return difference.inHours < 24 && !difference.isNegative;
  }

  // Check if exam is overdue
  bool get isOverdue {
    return DateTime.now().isAfter(deadline);
  }

  // Format time (HH:MM)
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Format date (Senin, 16 Okt)
  String _formatDate(DateTime dateTime) {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    final dayName = days[dateTime.weekday % 7];
    final day = dateTime.day;
    final month = months[dateTime.month - 1];

    return '$dayName, $day $month';
  }

  // TODO: Add toJson method for database integration
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examTitle': examTitle,
      'subject': subject,
      'durationMinutes': durationMinutes,
      'questionCount': questionCount,
      'multipleChoiceCount': multipleChoiceCount,
      'essayCount': essayCount,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // TODO: Add fromJson method for database integration
  factory StudentExamModel.fromJson(Map<String, dynamic> json) {
    return StudentExamModel(
      id: json['id'] as String,
      examTitle: json['examTitle'] as String,
      subject: json['subject'] as String,
      durationMinutes: json['durationMinutes'] as int,
      questionCount: json['questionCount'] as int,
      multipleChoiceCount: json['multipleChoiceCount'] as int,
      essayCount: json['essayCount'] as int,
      deadline: DateTime.parse(json['deadline'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  StudentExamModel copyWith({
    String? id,
    String? examTitle,
    String? subject,
    int? durationMinutes,
    int? questionCount,
    int? multipleChoiceCount,
    int? essayCount,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return StudentExamModel(
      id: id ?? this.id,
      examTitle: examTitle ?? this.examTitle,
      subject: subject ?? this.subject,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      questionCount: questionCount ?? this.questionCount,
      multipleChoiceCount: multipleChoiceCount ?? this.multipleChoiceCount,
      essayCount: essayCount ?? this.essayCount,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
