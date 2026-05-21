class ExamInfo {
  String name;
  String subject;
  int targetKKM;
  int duration; // in minutes
  String instructions;

  ExamInfo({
    required this.name,
    required this.subject,
    required this.targetKKM,
    required this.duration,
    required this.instructions,
  });

  // Convert to JSON for database
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subject': subject,
      'targetKKM': targetKKM,
      'duration': duration,
      'instructions': instructions,
    };
  }

  // Create from JSON from database
  factory ExamInfo.fromJson(Map<String, dynamic> json) {
    return ExamInfo(
      name: json['name'] as String,
      subject: json['subject'] as String,
      targetKKM: json['targetKKM'] as int,
      duration: json['duration'] as int,
      instructions: json['instructions'] as String,
    );
  }
}
