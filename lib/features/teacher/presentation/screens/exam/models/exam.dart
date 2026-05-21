import 'package:attend/features/teacher/presentation/screens/exam/models/question.dart';

class Exam {
  final String id;
  final String name;
  final String subject;
  final int targetKKM;
  final int duration; // in minutes
  final String instructions;
  final List<Question> questions;
  final DateTime createdAt;

  Exam({
    required this.id,
    required this.name,
    required this.subject,
    required this.targetKKM,
    required this.duration,
    required this.instructions,
    required this.questions,
    required this.createdAt,
  });

  // Computed properties
  int get totalQuestions => questions.length;

  int get multipleChoiceCount =>
      questions.where((q) => q.type == QuestionType.multipleChoice).length;

  int get essayCount =>
      questions.where((q) => q.type == QuestionType.essay).length;

  int get totalWeight => questions.fold(0, (sum, q) => sum + q.weight);

  // Convert to JSON for database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'targetKKM': targetKKM,
      'duration': duration,
      'instructions': instructions,
      'questions': questions.map((q) => q.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON from database
  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      targetKKM: json['targetKKM'] as int,
      duration: json['duration'] as int,
      instructions: json['instructions'] as String,
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Copy with method for updates
  Exam copyWith({
    String? id,
    String? name,
    String? subject,
    int? targetKKM,
    int? duration,
    String? instructions,
    List<Question>? questions,
    DateTime? createdAt,
  }) {
    return Exam(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      targetKKM: targetKKM ?? this.targetKKM,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
      questions: questions ?? this.questions,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
