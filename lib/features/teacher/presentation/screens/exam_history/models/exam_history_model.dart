enum ExamStatus {
  notGraded,  // Belum dinilai
  graded,     // Selesai dinilai
}

class ExamHistoryModel {
  final String id;
  final String examName;
  final String className;
  final DateTime date;
  final int durationMinutes;
  final ExamStatus status;
  final int? notGradedCount; // Jumlah yang belum dinilai (null jika sudah selesai)
  final int? totalStudents;  // Total siswa

  ExamHistoryModel({
    required this.id,
    required this.examName,
    required this.className,
    required this.date,
    required this.durationMinutes,
    required this.status,
    this.notGradedCount,
    this.totalStudents,
  });

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
    final year = date.year;
    
    return '$dayName, $day $month $year';
  }

  // Format duration
  String get formattedDuration => '$durationMinutes Menit';

  // Get status text
  String get statusText {
    if (status == ExamStatus.notGraded && notGradedCount != null) {
      return '$notGradedCount BELUM DINILAI';
    }
    return 'SELESAI DINILAI';
  }

  // Get status color
  String get statusColorHex {
    return status == ExamStatus.notGraded ? '#EA580C' : '#10B981';
  }

  // Check if exam is graded
  bool get isGraded => status == ExamStatus.graded;

  // TODO: Add toJson method for database integration
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examName': examName,
      'className': className,
      'date': date.toIso8601String(),
      'durationMinutes': durationMinutes,
      'status': status.toString(),
      'notGradedCount': notGradedCount,
      'totalStudents': totalStudents,
    };
  }

  // TODO: Add fromJson method for database integration
  factory ExamHistoryModel.fromJson(Map<String, dynamic> json) {
    return ExamHistoryModel(
      id: json['id'] as String,
      examName: json['examName'] as String,
      className: json['className'] as String,
      date: DateTime.parse(json['date'] as String),
      durationMinutes: json['durationMinutes'] as int,
      status: json['status'].toString().contains('notGraded')
          ? ExamStatus.notGraded
          : ExamStatus.graded,
      notGradedCount: json['notGradedCount'] as int?,
      totalStudents: json['totalStudents'] as int?,
    );
  }

  ExamHistoryModel copyWith({
    String? id,
    String? examName,
    String? className,
    DateTime? date,
    int? durationMinutes,
    ExamStatus? status,
    int? notGradedCount,
    int? totalStudents,
  }) {
    return ExamHistoryModel(
      id: id ?? this.id,
      examName: examName ?? this.examName,
      className: className ?? this.className,
      date: date ?? this.date,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      notGradedCount: notGradedCount ?? this.notGradedCount,
      totalStudents: totalStudents ?? this.totalStudents,
    );
  }
}
