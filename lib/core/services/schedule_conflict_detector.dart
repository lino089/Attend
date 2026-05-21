import 'package:flutter/material.dart';

enum ConflictType {
  teacherOverlap,  // Guru mengajar dua kelas berbeda di jam yang sama
  mismatch,        // Kelas menjadwalkan Guru A, tapi Guru A menjadwalkan mengajar kelas lain / kosong
  classOverlap     // Kelas memiliki 2 mapel/guru berbeda di jam yang sama
}

class ScheduleConflict {
  final String id;
  final String day;
  final String timeSlot;
  final String? className;
  final String? teacherName;
  final String? teacherNip;
  final String subject;
  final ConflictType type;
  final String description;

  ScheduleConflict({
    required this.id,
    required this.day,
    required this.timeSlot,
    this.className,
    this.teacherName,
    this.teacherNip,
    required this.subject,
    required this.type,
    required this.description,
  });
}

// Model data jadwal internal untuk pencarian konflik
class FlatScheduleItem {
  final String className;
  final String teacherName;
  final String teacherNip;
  final String subject;
  final String day;
  final String startTime;
  final String endTime;

  FlatScheduleItem({
    required this.className,
    required this.teacherName,
    required this.teacherNip,
    required this.subject,
    required this.day,
    required this.startTime,
    required this.endTime,
  });
}

class ScheduleConflictDetector extends ChangeNotifier {
  // Singleton Pattern
  static final ScheduleConflictDetector _instance = ScheduleConflictDetector._internal();
  factory ScheduleConflictDetector() => _instance;
  ScheduleConflictDetector._internal() {
    _initializeMockData();
  }

  // Database mock terpusat
  final List<FlatScheduleItem> _studentSchedules = [];
  final List<FlatScheduleItem> _teacherSchedules = [];

  List<ScheduleConflict> _activeConflicts = [];

  List<ScheduleConflict> get activeConflicts => _activeConflicts;
  bool get hasConflicts => _activeConflicts.isNotEmpty;

  void _initializeMockData() {
    // 1. Data Jadwal Siswa (Kelas)
    _studentSchedules.addAll([
      FlatScheduleItem(
        className: 'XII TKJ 1',
        teacherName: 'Bp. Hendra Wijaya',
        teacherNip: '198203102009031002',
        subject: 'Pemrograman Web',
        day: 'Senin',
        startTime: '07:30',
        endTime: '09:00',
      ),
      FlatScheduleItem(
        className: 'X RPL 1',
        teacherName: 'Ibu Susi Simanjuntak',
        teacherNip: '198512122010042001',
        subject: 'Fisika',
        day: 'Senin',
        startTime: '07:30',
        endTime: '09:00',
      ),
      FlatScheduleItem(
        className: 'XII RPL 1',
        teacherName: 'Bp. Hendra Wijaya',
        teacherNip: '198203102009031002',
        subject: 'Basis Data',
        day: 'Senin',
        startTime: '09:15',
        endTime: '10:45',
      ),
    ]);

    // 2. Data Jadwal Guru
    _teacherSchedules.addAll([
      // Konflik Mismatch: Guru Hendra menjadwalkan mengajar XII RPL 1 pada jam 07:30 - 09:00 Senin,
      // tetapi Jadwal Siswa XII TKJ 1 menjadwalkan Guru Hendra pada jam yang sama.
      FlatScheduleItem(
        className: 'XII RPL 1', 
        teacherName: 'Bp. Hendra Wijaya',
        teacherNip: '198203102009031002',
        subject: 'Pemrograman Web',
        day: 'Senin',
        startTime: '07:30',
        endTime: '09:00',
      ),
      // Konflik Guru Overlap: Guru Hendra menjadwalkan mengajar XI RPL 1 juga pada jam 07:30 - 09:00 Senin!
      FlatScheduleItem(
        className: 'XI RPL 1',
        teacherName: 'Bp. Hendra Wijaya',
        teacherNip: '198203102009031002',
        subject: 'Fisika Terapan',
        day: 'Senin',
        startTime: '07:30',
        endTime: '09:00',
      ),
      FlatScheduleItem(
        className: 'X RPL 1',
        teacherName: 'Ibu Susi Simanjuntak',
        teacherNip: '198512122010042001',
        subject: 'Fisika',
        day: 'Senin',
        startTime: '07:30',
        endTime: '09:00',
      ),
    ]);

    detectConflicts();
  }

  // Melakukan kalkulasi deteksi konflik
  void detectConflicts() {
    List<ScheduleConflict> conflicts = [];

    // --- DETEKSI KONFLIK 1: Overlap Guru ---
    // Mencari jika ada guru yang mengajar di lebih dari 1 kelas pada waktu yang sama
    for (int i = 0; i < _teacherSchedules.length; i++) {
      final s1 = _teacherSchedules[i];
      for (int j = i + 1; j < _teacherSchedules.length; j++) {
        final s2 = _teacherSchedules[j];
        
        if (s1.teacherNip == s2.teacherNip &&
            s1.day == s2.day &&
            _isTimeOverlapping(s1.startTime, s1.endTime, s2.startTime, s2.endTime)) {
          conflicts.add(ScheduleConflict(
            id: 'overlap_t_${s1.teacherNip}_${s1.day}_${s1.startTime}',
            day: s1.day,
            timeSlot: '${s1.startTime} - ${s1.endTime}',
            teacherName: s1.teacherName,
            teacherNip: s1.teacherNip,
            subject: s1.subject,
            type: ConflictType.teacherOverlap,
            description: 'Guru ${s1.teacherName} dijadwalkan mengajar Kelas ${s1.className} dan Kelas ${s2.className} secara bersamaan.',
          ));
        }
      }
    }

    // --- DETEKSI KONFLIK 2: Mismatch (Tidak Sinkron) ---
    // Mencari jika kelas menjadwalkan Guru A, tetapi di jadwal Guru A mengajar kelas lain/tidak terjadwal
    for (final studentSched in _studentSchedules) {
      // Temukan jadwal guru yang bersesuaian di hari dan slot waktu yang sama
      final matchingTeacherScheds = _teacherSchedules.where((t) =>
        t.teacherNip == studentSched.teacherNip &&
        t.day == studentSched.day &&
        _isTimeOverlapping(studentSched.startTime, studentSched.endTime, t.startTime, t.endTime)
      ).toList();

      if (matchingTeacherScheds.isEmpty) {
        // Guru tidak menjadwalkan kelas ini sama sekali di waktu ini
        conflicts.add(ScheduleConflict(
          id: 'mismatch_empty_${studentSched.className}_${studentSched.day}_${studentSched.startTime}',
          day: studentSched.day,
          timeSlot: '${studentSched.startTime} - ${studentSched.endTime}',
          className: studentSched.className,
          teacherName: studentSched.teacherName,
          teacherNip: studentSched.teacherNip,
          subject: studentSched.subject,
          type: ConflictType.mismatch,
          description: 'Jadwal Kelas ${studentSched.className} mencatat diajar oleh ${studentSched.teacherName}, tetapi di jadwal guru tidak ada sesi ini.',
        ));
      } else {
        // Cek jika guru malah mencatat mengajar kelas lain
        for (final teacherSched in matchingTeacherScheds) {
          if (teacherSched.className != studentSched.className) {
            conflicts.add(ScheduleConflict(
              id: 'mismatch_diff_${studentSched.className}_${teacherSched.className}_${studentSched.day}_${studentSched.startTime}',
              day: studentSched.day,
              timeSlot: '${studentSched.startTime} - ${studentSched.endTime}',
              className: studentSched.className,
              teacherName: studentSched.teacherName,
              teacherNip: studentSched.teacherNip,
              subject: studentSched.subject,
              type: ConflictType.mismatch,
              description: 'Jadwal tidak singkron: Kelas ${studentSched.className} mencatat diajar ${studentSched.teacherName}, tetapi di jadwal guru ia mengajar Kelas ${teacherSched.className}.',
            ));
          }
        }
      }
    }

    // --- DETEKSI KONFLIK 3: Overlap Kelas ---
    for (int i = 0; i < _studentSchedules.length; i++) {
      final s1 = _studentSchedules[i];
      for (int j = i + 1; j < _studentSchedules.length; j++) {
        final s2 = _studentSchedules[j];
        
        if (s1.className == s2.className &&
            s1.day == s2.day &&
            _isTimeOverlapping(s1.startTime, s1.endTime, s2.startTime, s2.endTime)) {
          conflicts.add(ScheduleConflict(
            id: 'overlap_c_${s1.className}_${s1.day}_${s1.startTime}',
            day: s1.day,
            timeSlot: '${s1.startTime} - ${s1.endTime}',
            className: s1.className,
            subject: '${s1.subject} & ${s2.subject}',
            type: ConflictType.classOverlap,
            description: 'Kelas ${s1.className} memiliki jadwal ganda (${s1.subject} oleh ${s1.teacherName} dan ${s2.subject} oleh ${s2.teacherName}) secara bersamaan.',
          ));
        }
      }
    }

    _activeConflicts = conflicts;
    notifyListeners();
  }

  bool _isTimeOverlapping(String start1, String end1, String start2, String end2) {
    try {
      final s1 = _toMinutes(start1);
      final e1 = _toMinutes(end1);
      final s2 = _toMinutes(start2);
      final e2 = _toMinutes(end2);

      return (s1 < e2 && s2 < e1);
    } catch (_) {
      return false;
    }
  }

  int _toMinutes(String timeStr) {
    final parts = timeStr.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  // API untuk cek spesifik konflik per-kelas
  bool hasConflictForClass(String className) {
    return _activeConflicts.any((c) => c.className == className || c.description.contains('Kelas $className'));
  }

  // API untuk cek spesifik konflik per-guru
  bool hasConflictForTeacher(String teacherNip) {
    return _activeConflicts.any((c) => c.teacherNip == teacherNip);
  }

  // Tambah/Update jadwal secara dinamis
  void addOrUpdateStudentSchedule(FlatScheduleItem item) {
    _studentSchedules.removeWhere((s) => s.className == item.className && s.day == item.day && s.startTime == item.startTime);
    _studentSchedules.add(item);
    detectConflicts();
  }

  void addOrUpdateTeacherSchedule(FlatScheduleItem item) {
    _teacherSchedules.removeWhere((s) => s.teacherNip == item.teacherNip && s.day == item.day && s.startTime == item.startTime);
    _teacherSchedules.add(item);
    detectConflicts();
  }
}
