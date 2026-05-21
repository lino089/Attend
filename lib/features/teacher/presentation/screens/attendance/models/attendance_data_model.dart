class AttendanceData {
  final String classId;
  final String className;
  final String subject;
  final DateTime date;
  final List<StudentAttendance> absences; // Hanya S, I, A

  AttendanceData({
    required this.classId,
    required this.className,
    required this.subject,
    required this.date,
    required this.absences,
  });

  // Convert to JSON for database
  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'className': className,
      'subject': subject,
      'date': date.toIso8601String(),
      'absences': absences.map((a) => a.toJson()).toList(),
    };
  }

  // Create from JSON from database
  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      classId: json['classId'] as String,
      className: json['className'] as String,
      subject: json['subject'] as String,
      date: DateTime.parse(json['date'] as String),
      absences: (json['absences'] as List)
          .map((a) => StudentAttendance.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }
}

class StudentAttendance {
  final String studentId;
  final String status; // 'S', 'I', atau 'A'

  StudentAttendance({
    required this.studentId,
    required this.status,
  });

  // Convert to JSON for database
  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'status': status,
    };
  }

  // Create from JSON from database
  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    return StudentAttendance(
      studentId: json['studentId'] as String,
      status: json['status'] as String,
    );
  }
}
