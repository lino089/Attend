import 'package:flutter_test/flutter_test.dart';
import 'package:attend/core/services/schedule_config_service.dart';
import 'package:attend/core/services/schedule_conflict_detector.dart';
import 'package:attend/core/services/schedule_engine.dart';

void main() {
  group('ScheduleConfigService Tests', () {
    late ScheduleConfigService configService;

    setUp(() {
      configService = ScheduleConfigService();
      configService.resetConfig();
    });

    test('Initial config should be ScheduleStructure.none', () {
      expect(configService.structure, ScheduleStructure.none);
      expect(configService.isConfigured, isFalse);
    });

    test('setStructure updates structure correctly', () {
      configService.setStructure(ScheduleStructure.fixed);
      expect(configService.structure, ScheduleStructure.fixed);
      expect(configService.isFixed, isTrue);
      expect(configService.isRolling, isFalse);
    });

    test('configureRolling sets rolling structure and patterns', () {
      final patterns = ['Pattern A', 'Pattern B'];
      final start = DateTime(2026, 5, 21);
      configService.configureRolling(
        patternNames: patterns,
        rotationDuration: 'Setiap 1 Minggu',
        startDate: start,
      );

      expect(configService.structure, ScheduleStructure.rolling);
      expect(configService.isRolling, isTrue);
      expect(configService.patternNames, patterns);
      expect(configService.rotationDuration, 'Setiap 1 Minggu');
      expect(configService.startDate, start);
    });
  });

  group('ScheduleEngine Tests', () {
    final dailySchedule = [
      {
        "subject": "Matematika",
        "startTime": "07:30",
        "endTime": "09:00",
        "teacher": "Mrs. Rossy",
        "location": "Lab Komputer 2",
        "isRest": false,
      },
      {
        "subject": "Istirahat",
        "startTime": "09:00",
        "endTime": "09:30",
        "isRest": true,
      },
      {
        "subject": "Fisika",
        "startTime": "09:30",
        "endTime": "11:00",
        "teacher": "Mr. Albert",
        "location": "Ruang Fisika",
        "isRest": false,
      }
    ];

    test('Status: notStarted (Before buffer time)', () {
      final time = DateTime(2026, 5, 21, 6, 0); // 06:00 (1.5 hours before 07:30)
      final state = ScheduleEngine.calculateCurrentState(
        currentTime: time,
        dailySchedule: dailySchedule,
        hasCompletedAttendance: false,
      );
      expect(state.status, LessonStatus.notStarted);
    });

    test('Status: upcoming (Within 30 min buffer)', () {
      final time = DateTime(2026, 5, 21, 7, 10); // 07:10 (20 min before 07:30)
      final state = ScheduleEngine.calculateCurrentState(
        currentTime: time,
        dailySchedule: dailySchedule,
        hasCompletedAttendance: false,
      );
      expect(state.status, LessonStatus.upcoming);
      expect(state.subject, 'Matematika');
      expect(state.minutesRemaining, 20);
    });

    test('Status: ongoing (During class, not checked in)', () {
      final time = DateTime(2026, 5, 21, 8, 0); // 08:00 (during Matematika)
      final state = ScheduleEngine.calculateCurrentState(
        currentTime: time,
        dailySchedule: dailySchedule,
        hasCompletedAttendance: false,
      );
      expect(state.status, LessonStatus.ongoing);
      expect(state.subject, 'Matematika');
      expect(state.minutesRemaining, 60);
    });

    test('Status: ongoingDone (During class, checked in)', () {
      final time = DateTime(2026, 5, 21, 8, 0); // 08:00 (during Matematika)
      final state = ScheduleEngine.calculateCurrentState(
        currentTime: time,
        dailySchedule: dailySchedule,
        hasCompletedAttendance: true,
      );
      expect(state.status, LessonStatus.ongoingDone);
      expect(state.subject, 'Matematika');
    });

    test('Status: breakTime (During rest period)', () {
      final time = DateTime(2026, 5, 21, 9, 15); // 09:15 (during Istirahat)
      final state = ScheduleEngine.calculateCurrentState(
        currentTime: time,
        dailySchedule: dailySchedule,
        hasCompletedAttendance: false,
      );
      expect(state.status, LessonStatus.breakTime);
      expect(state.subject, 'Sedang Istirahat');
      expect(state.minutesRemaining, 15);
    });

    test('Status: ended (After last class)', () {
      final time = DateTime(2026, 5, 21, 11, 30); // 11:30 (after Fisika ends at 11:00)
      final state = ScheduleEngine.calculateCurrentState(
        currentTime: time,
        dailySchedule: dailySchedule,
        hasCompletedAttendance: false,
      );
      expect(state.status, LessonStatus.ended);
    });

    test('getRemainingSchedule returns only future/current slots', () {
      final time = DateTime(2026, 5, 21, 9, 15); // During break
      final remaining = ScheduleEngine.getRemainingSchedule(
        currentTime: time,
        dailySchedule: dailySchedule,
      );
      expect(remaining.length, 2); // Break (ends 09:30) and Fisika (ends 11:00)
      expect(remaining[0]['subject'], 'Istirahat');
      expect(remaining[1]['subject'], 'Fisika');
    });
  });

  group('ScheduleConflictDetector Tests', () {
    late ScheduleConflictDetector detector;

    setUp(() {
      detector = ScheduleConflictDetector();
    });

    test('Initial mock data has conflicts due to preset teacher overlap and mismatch', () {
      expect(detector.hasConflicts, isTrue);
      expect(detector.activeConflicts.length, greaterThan(0));
    });

    test('Conflict checking by class and teacher', () {
      // XII RPL 1 and XII TKJ 1 have conflict alerts in mock initialization
      expect(detector.hasConflictForClass('XII TKJ 1'), isTrue);
      expect(detector.hasConflictForTeacher('198203102009031002'), isTrue); // Bp. Hendra Wijaya NIP
    });

    test('Adding a class overlap conflict', () {
      // Adding Class Overlap on Kelas X RPL 1 (Senin 07:30-09:00 already has Ibu Susi Fisika)
      detector.addOrUpdateStudentSchedule(
        FlatScheduleItem(
          className: 'X RPL 1',
          teacherName: 'Bp. Hendra Wijaya',
          teacherNip: '198203102009031002',
          subject: 'Pemrograman Web',
          day: 'Senin',
          startTime: '08:00',
          endTime: '09:30',
        ),
      );

      final classOverlapConflicts = detector.activeConflicts.where((c) => c.type == ConflictType.classOverlap).toList();
      expect(classOverlapConflicts.isNotEmpty, isTrue);
    });
  });
}
