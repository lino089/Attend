class TeacherPresence {
  final String teacherId;
  final String teacherName;
  final String subject;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? statusIn;   // "Tepat Waktu" / "Terlambat"
  final String? statusOut;  // "Tepat Waktu" / "Pulang Awal"
  final double? latitude;
  final double? longitude;
  final String? photoUrl;

  TeacherPresence({
    required this.teacherId,
    required this.teacherName,
    required this.subject,
    this.checkInTime,
    this.checkOutTime,
    this.statusIn,
    this.statusOut,
    this.latitude,
    this.longitude,
    this.photoUrl,
  });

  TeacherPresence copyWith({
    String? teacherId,
    String? teacherName,
    String? subject,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? statusIn,
    String? statusOut,
    double? latitude,
    double? longitude,
    String? photoUrl,
  }) {
    return TeacherPresence(
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      subject: subject ?? this.subject,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      statusIn: statusIn ?? this.statusIn,
      statusOut: statusOut ?? this.statusOut,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  bool get hasCheckedIn => checkInTime != null;
  bool get hasCheckedOut => checkOutTime != null;
}
