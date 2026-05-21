class AttendanceHistoryModel {
  final String id;
  final String subjectName;
  final String className;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int presentCount;
  final int totalStudents;

  AttendanceHistoryModel({
    required this.id,
    required this.subjectName,
    required this.className,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.presentCount,
    required this.totalStudents,
  });

  // Calculate attendance percentage
  double get attendancePercentage {
    if (totalStudents == 0) return 0;
    return (presentCount / totalStudents) * 100;
  }

  // Check if attendance is good (> 80%)
  bool get isGoodAttendance => attendancePercentage > 80;

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
    
    return '$dayName, $day $month';
  }

  // Format time range
  String get timeRange => '$startTime - $endTime';

  // TODO: Add toJson method for database integration
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectName': subjectName,
      'className': className,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'presentCount': presentCount,
      'totalStudents': totalStudents,
    };
  }

  // TODO: Add fromJson method for database integration
  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryModel(
      id: json['id'] as String,
      subjectName: json['subjectName'] as String,
      className: json['className'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      presentCount: json['presentCount'] as int,
      totalStudents: json['totalStudents'] as int,
    );
  }

  AttendanceHistoryModel copyWith({
    String? id,
    String? subjectName,
    String? className,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? presentCount,
    int? totalStudents,
  }) {
    return AttendanceHistoryModel(
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      className: className ?? this.className,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      presentCount: presentCount ?? this.presentCount,
      totalStudents: totalStudents ?? this.totalStudents,
    );
  }
}
