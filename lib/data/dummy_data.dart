import 'package:attend/models/schedule_model.dart';
import 'package:attend/models/teacher_model.dart';

final dummyTeacher = TeacherModel(
  name: 'Rossy Rahmadani',
  role: 'Guru Rekayasa Perangkat Lunak',
  profileImageUrl: "https://i.pravatar.cc/150?img=44",
);

final List<ScheduleModel> dummySchedule = [
  ScheduleModel(
    className: 'XI RPL 2',
    startTime: '07:15',
    endTime: "08:45",
    isOnGoing: true,
  ),
  ScheduleModel(className: 'XI DKV 2', startTime: '08:15', endTime: '09:45'),
  ScheduleModel(className: 'XI TKJ 2', startTime: '10:15', endTime: '11:45'),
];

final Map<String, List<ScheduleModel>> dummyWeaklySchedule = {
  'Senin': [],
  'Selasa': [
    ScheduleModel(
      className: "XI RPL 2",
      subject: "Pemrograman Perangkat Bergerak",
      startTime: "07:15",
      endTime: "08:45",
      location: "Lab 18",
      colorCode: 0xFF4561E9,
    ), // Biru
    ScheduleModel(
      className: "XI DKV 2",
      subject: "Desain Grafis Dasar",
      startTime: "09:00",
      endTime: "10:30",
      location: "Lab 05",
      colorCode: 0xFF00B661,
    ), // Hijau
    ScheduleModel(
      className: "XI TKJ 2",
      subject: "Administrasi Sistem Jaringan",
      startTime: "10:45",
      endTime: "12:15",
      location: "Lab 12",
      colorCode: 0xFFFF8A00,
    ), // Orange
  ],
  'Rabu': [],
  'Kamis': [],
  'Jumat': [],
};
