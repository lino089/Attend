class QuestionOption {
  String id;
  String label; // A, B, C, D, E
  String text;
  bool isCorrect;

  QuestionOption({
    required this.id,
    required this.label,
    required this.text,
    this.isCorrect = false,
  });

  QuestionOption copyWith({
    String? id,
    String? label,
    String? text,
    bool? isCorrect,
  }) {
    return QuestionOption(
      id: id ?? this.id,
      label: label ?? this.label,
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'text': text,
      'isCorrect': isCorrect,
    };
  }

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] as String,
      label: json['label'] as String,
      text: json['text'] as String,
      isCorrect: json['isCorrect'] as bool? ?? false,
    );
  }
}
