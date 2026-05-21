class ScheduleModel {
  final String id;
  final String className;
  final String subjectName;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String location;
  final int studentCount;

  ScheduleModel({
    required this.id,
    required this.className,
    required this.subjectName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.studentCount,
  });

  // Format time range
  String get timeRange => '$startTime - $endTime';

  // Format date to Indonesian format (Selasa, 29 Oktober)
  String get formattedDate {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    final dayName = days[date.weekday % 7];
    final day = date.day;
    final month = months[date.month - 1];
    
    return '$dayName, $day $month';
  }

  // Get short day name (SEN, SEL, RAB, etc.)
  String get dayName {
    final days = ['MIN', 'SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB'];
    return days[date.weekday % 7];
  }

  // Calculate duration in hours
  double get durationHours {
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);
    return (end - start) / 60; // Convert minutes to hours
  }

  int _parseTime(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  // TODO: Add toJson method for database integration
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'className': className,
      'subjectName': subjectName,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'studentCount': studentCount,
    };
  }

  // TODO: Add fromJson method for database integration
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] as String,
      className: json['className'] as String,
      subjectName: json['subjectName'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      location: json['location'] as String,
      studentCount: json['studentCount'] as int,
    );
  }

  ScheduleModel copyWith({
    String? id,
    String? className,
    String? subjectName,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? location,
    int? studentCount,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      className: className ?? this.className,
      subjectName: subjectName ?? this.subjectName,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      studentCount: studentCount ?? this.studentCount,
    );
  }
}
