import 'package:intl/intl.dart';

enum LessonStatus {
  upcoming,       // Pelajaran mendatang (dalam buffer 30 menit sebelum mulai)
  ongoing,        // Sedang berlangsung (belum absensi)
  ongoingDone,    // Sedang berlangsung (sudah absensi)
  breakTime,      // Sedang istirahat sekolah
  ended,          // Selesai (semua pelajaran hari ini berakhir)
  notStarted      // Jauh sebelum pelajaran pertama dimulai (misal malam/pagi buta)
}

class LessonCardState {
  final LessonStatus status;
  final String subject;
  final String startTime;
  final String endTime;
  final String teacher;
  final String location;
  final int minutesRemaining;

  LessonCardState({
    required this.status,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.teacher,
    required this.location,
    required this.minutesRemaining,
  });
}

class ScheduleEngine {
  static const int upcomingBufferMinutes = 30; // 30 menit sebelum pelajaran pertama

  /// Menghitung status pelajaran aktif saat ini
  static LessonCardState calculateCurrentState({
    required DateTime currentTime,
    required List<Map<String, dynamic>> dailySchedule,
    required bool hasCompletedAttendance,
  }) {
    if (dailySchedule.isEmpty) {
      return LessonCardState(
        status: LessonStatus.ended,
        subject: '',
        startTime: '',
        endTime: '',
        teacher: '',
        location: '',
        minutesRemaining: 0,
      );
    }

    final currentMinutes = currentTime.hour * 60 + currentTime.minute;

    // Temukan jam pelajaran pertama dan terakhir
    int? firstLessonStart;
    int? lastLessonEnd;

    for (final lesson in dailySchedule) {
      final start = _parseTimeToMinutes(lesson['startTime'] ?? '00:00');
      final end = _parseTimeToMinutes(lesson['endTime'] ?? '00:00');
      if (firstLessonStart == null || start < firstLessonStart) {
        firstLessonStart = start;
      }
      if (lastLessonEnd == null || end > lastLessonEnd) {
        lastLessonEnd = end;
      }
    }

    // 1. Kondisi: Sebelum Jam Pelajaran Pertama
    if (currentMinutes < firstLessonStart!) {
      final diff = firstLessonStart - currentMinutes;
      if (diff <= upcomingBufferMinutes) {
        // Dalam rentang buffer 30 menit -> status "Mendatang"
        final nextLesson = dailySchedule.firstWhere((l) => !(l['isRest'] ?? false));
        return LessonCardState(
          status: LessonStatus.upcoming,
          subject: nextLesson['subject'] ?? '',
          startTime: nextLesson['startTime'] ?? '',
          endTime: nextLesson['endTime'] ?? '',
          teacher: nextLesson['teacherName'] ?? nextLesson['teacher'] ?? '',
          location: nextLesson['location'] ?? 'Lab',
          minutesRemaining: diff,
        );
      } else {
        return LessonCardState(
          status: LessonStatus.notStarted,
          subject: '',
          startTime: '',
          endTime: '',
          teacher: '',
          location: '',
          minutesRemaining: 0,
        );
      }
    }

    // 2. Kondisi: Setelah Semua Pelajaran Selesai
    if (currentMinutes >= lastLessonEnd!) {
      return LessonCardState(
        status: LessonStatus.ended,
        subject: '',
        startTime: '',
        endTime: '',
        teacher: '',
        location: '',
        minutesRemaining: 0,
      );
    }

    // 3. Kondisi: Di Tengah Hari Sekolah (Jam Pelajaran sedang aktif)
    for (final lesson in dailySchedule) {
      final start = _parseTimeToMinutes(lesson['startTime'] ?? '00:00');
      final end = _parseTimeToMinutes(lesson['endTime'] ?? '00:00');

      if (currentMinutes >= start && currentMinutes < end) {
        final isRest = lesson['isRest'] ?? false;
        
        if (isRest) {
          return LessonCardState(
            status: LessonStatus.breakTime,
            subject: 'Sedang Istirahat',
            startTime: lesson['startTime'] ?? '',
            endTime: lesson['endTime'] ?? '',
            teacher: '',
            location: '',
            minutesRemaining: end - currentMinutes,
          );
        } else {
          return LessonCardState(
            status: hasCompletedAttendance ? LessonStatus.ongoingDone : LessonStatus.ongoing,
            subject: lesson['subject'] ?? '',
            startTime: lesson['startTime'] ?? '',
            endTime: lesson['endTime'] ?? '',
            teacher: lesson['teacherName'] ?? lesson['teacher'] ?? '',
            location: lesson['location'] ?? 'Lab Komputer',
            minutesRemaining: end - currentMinutes,
          );
        }
      }
    }

    // Fallback jika berada di antara sela-sela perpindahan jam yang tidak terdefinisi
    return LessonCardState(
      status: LessonStatus.notStarted,
      subject: '',
      startTime: '',
      endTime: '',
      teacher: '',
      location: '',
      minutesRemaining: 0,
    );
  }

  /// Memfilter sisa jadwal (Remaining Schedule) setelah jam sekarang
  static List<Map<String, dynamic>> getRemainingSchedule({
    required DateTime currentTime,
    required List<Map<String, dynamic>> dailySchedule,
  }) {
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    return dailySchedule.where((lesson) {
      final end = _parseTimeToMinutes(lesson['endTime'] ?? '00:00');
      return end > currentMinutes;
    }).toList();
  }

  static int _parseTimeToMinutes(String timeStr) {
    try {
      final parts = timeStr.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    } catch (_) {
      return 0;
    }
  }
}
