class AttendanceSummaryModel {
  final int totalClassesTaught;
  final double averageAttendance; // percentage (0-100)

  AttendanceSummaryModel({
    required this.totalClassesTaught,
    required this.averageAttendance,
  });

  // Format average attendance as percentage string
  String get formattedAverageAttendance {
    return '${averageAttendance.toStringAsFixed(0)}%';
  }

  // TODO: Add toJson method for database integration
  Map<String, dynamic> toJson() {
    return {
      'totalClassesTaught': totalClassesTaught,
      'averageAttendance': averageAttendance,
    };
  }

  // TODO: Add fromJson method for database integration
  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      totalClassesTaught: json['totalClassesTaught'] as int,
      averageAttendance: (json['averageAttendance'] as num).toDouble(),
    );
  }

  AttendanceSummaryModel copyWith({
    int? totalClassesTaught,
    double? averageAttendance,
  }) {
    return AttendanceSummaryModel(
      totalClassesTaught: totalClassesTaught ?? this.totalClassesTaught,
      averageAttendance: averageAttendance ?? this.averageAttendance,
    );
  }
}
