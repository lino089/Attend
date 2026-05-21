import 'package:flutter/material.dart';

class StudentExamHistoryModel {
  final String id;
  final String examName;
  final String subjectName; // Mata pelajaran
  final DateTime date;
  final int durationMinutes;
  final int? score; // Nilai (null jika belum dinilai)
  final int maxScore; // Nilai maksimal (default 100)

  StudentExamHistoryModel({
    required this.id,
    required this.examName,
    required this.subjectName,
    required this.date,
    required this.durationMinutes,
    this.score,
    this.maxScore = 100,
  });

  // Check if exam is graded
  bool get isGraded => score != null;

  // Format date to Indonesian format
  String get formattedDate {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    final dayName = days[date.weekday % 7];
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;

    return '$dayName, $day $month $year';
  }

  // Format duration
  String get formattedDuration => '$durationMinutes Menit';

  // Get score text
  String get scoreText {
    if (score == null) return 'BELUM DINILAI';
    return score.toString();
  }

  // Get score color based on value
  Color get scoreColor {
    if (score == null) return const Color(0xFF64748B); // Grey
    if (score! >= 80) return const Color(0xFF10B981); // Green
    if (score! >= 60) return const Color(0xFFEA580C); // Orange
    return const Color(0xFFEF4444); // Red
  }

  // Get score background color
  Color get scoreBgColor {
    return scoreColor.withValues(alpha: 0.1);
  }

  // TODO: Add toJson method for database integration
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examName': examName,
      'subjectName': subjectName,
      'date': date.toIso8601String(),
      'durationMinutes': durationMinutes,
      'score': score,
      'maxScore': maxScore,
    };
  }

  // TODO: Add fromJson method for database integration
  factory StudentExamHistoryModel.fromJson(Map<String, dynamic> json) {
    return StudentExamHistoryModel(
      id: json['id'] as String,
      examName: json['examName'] as String,
      subjectName: json['subjectName'] as String,
      date: DateTime.parse(json['date'] as String),
      durationMinutes: json['durationMinutes'] as int,
      score: json['score'] as int?,
      maxScore: json['maxScore'] as int? ?? 100,
    );
  }

  StudentExamHistoryModel copyWith({
    String? id,
    String? examName,
    String? subjectName,
    DateTime? date,
    int? durationMinutes,
    int? score,
    int? maxScore,
  }) {
    return StudentExamHistoryModel(
      id: id ?? this.id,
      examName: examName ?? this.examName,
      subjectName: subjectName ?? this.subjectName,
      date: date ?? this.date,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
    );
  }
}
