import 'package:attend/features/teacher/presentation/screens/exam/models/question_option.dart';

/// Model untuk menyimpan backup jawaban saat user ganti tipe soal
class QuestionBackup {
  // Backup untuk Multiple Choice
  List<QuestionOption>? multipleChoiceOptions;
  String? multipleChoiceCorrectAnswer;

  // Backup untuk Essay
  String? essayRubric;

  QuestionBackup({
    this.multipleChoiceOptions,
    this.multipleChoiceCorrectAnswer,
    this.essayRubric,
  });

  // Copy with method
  QuestionBackup copyWith({
    List<QuestionOption>? multipleChoiceOptions,
    String? multipleChoiceCorrectAnswer,
    String? essayRubric,
  }) {
    return QuestionBackup(
      multipleChoiceOptions:
          multipleChoiceOptions ?? this.multipleChoiceOptions,
      multipleChoiceCorrectAnswer:
          multipleChoiceCorrectAnswer ?? this.multipleChoiceCorrectAnswer,
      essayRubric: essayRubric ?? this.essayRubric,
    );
  }
}
