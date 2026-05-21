class ExamSummaryModel {
  final int totalExams;
  final int pendingGradingCount;

  ExamSummaryModel({
    required this.totalExams,
    required this.pendingGradingCount,
  });

  // Check if there are pending exams
  bool get hasPendingGrading => pendingGradingCount > 0;

  // Format pending text
  String get pendingText => '$pendingGradingCount Menunggu Penilaian';

  // TODO: Add toJson method for database integration
  Map<String, dynamic> toJson() {
    return {
      'totalExams': totalExams,
      'pendingGradingCount': pendingGradingCount,
    };
  }

  // TODO: Add fromJson method for database integration
  factory ExamSummaryModel.fromJson(Map<String, dynamic> json) {
    return ExamSummaryModel(
      totalExams: json['totalExams'] as int,
      pendingGradingCount: json['pendingGradingCount'] as int,
    );
  }

  ExamSummaryModel copyWith({
    int? totalExams,
    int? pendingGradingCount,
  }) {
    return ExamSummaryModel(
      totalExams: totalExams ?? this.totalExams,
      pendingGradingCount: pendingGradingCount ?? this.pendingGradingCount,
    );
  }
}
