import 'package:attend/features/teacher/presentation/screens/exam/models/question_option.dart';

enum QuestionType { multipleChoice, essay }

class Question {
  String id;
  int number;
  QuestionType type;
  String questionText;
  int weight; // bobot
  List<QuestionOption> options; // for multiple choice
  String? referenceAnswer; // for essay
  String? imageUrl;

  Question({
    required this.id,
    required this.number,
    required this.type,
    required this.questionText,
    required this.weight,
    required this.options,
    this.referenceAnswer,
    this.imageUrl,
  });

  Question copyWith({
    String? id,
    int? number,
    QuestionType? type,
    String? questionText,
    int? weight,
    List<QuestionOption>? options,
    String? referenceAnswer,
    String? imageUrl,
  }) {
    return Question(
      id: id ?? this.id,
      number: number ?? this.number,
      type: type ?? this.type,
      questionText: questionText ?? this.questionText,
      weight: weight ?? this.weight,
      options: options ?? this.options,
      referenceAnswer: referenceAnswer ?? this.referenceAnswer,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'type': type == QuestionType.multipleChoice ? 'multiple_choice' : 'essay',
      'questionText': questionText,
      'weight': weight,
      'options': options.map((o) => o.toJson()).toList(),
      'referenceAnswer': referenceAnswer,
      'imageUrl': imageUrl,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      number: json['number'] as int,
      type: json['type'] == 'multiple_choice' 
          ? QuestionType.multipleChoice 
          : QuestionType.essay,
      questionText: json['questionText'] as String,
      weight: json['weight'] as int,
      options: (json['options'] as List)
          .map((o) => QuestionOption.fromJson(o))
          .toList(),
      referenceAnswer: json['referenceAnswer'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
