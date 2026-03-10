import 'package:attend/models/schedule_model.dart';
import 'package:attend/models/teacher_model.dart';

final dummyTeacher = TeacherModel(
  name: "Rossy Rahmadani",
  role: 'Guru Rekayasa Perangkat Lunak',
  profileImageUrl: "https://i.pravatar.cc/150?img=44"
);

final List<ScheduleModel> dummySchedules = [
  ScheduleModel(className: "XI RPL 2", startTime: "7:15", endTime: "8:45", isOngoing: true),
  ScheduleModel(className: "XI DKV 2", startTime: "8:15", endTime: "9:45", isOngoing: false),
  ScheduleModel(className: "XI TKJ 2", startTime: "10:15", endTime: "11:45", isOngoing: false),
];

final Map<String, List<ScheduleModel>> dummyWeeklySchedules = {
  'Senin': [
    ScheduleModel(className: "X RPL 1", startTime: "07:15", endTime: "09:45", subject: "Dasar Program Keahlian", location: "Ruang Teori 1", colorCode: 0xFF5169F6),
    ScheduleModel(className: "X RPL 2", startTime: "10:15", endTime: "12:30", subject: "Dasar Program Keahlian", location: "Ruang Teori 2", colorCode: 0xFFF65151),
  ],
  'Selasa': [
    ScheduleModel(className: "XI RPL 2", startTime: "07:15", endTime: "08:45", subject: "Pemrograman Perangkat Bergerak", location: "Lab 18", colorCode: 0xFFB062D7),
    ScheduleModel(className: "XI DKV 2", startTime: "08:15", endTime: "09:45", subject: "Desain Grafis Percetakan", location: "Lab 18", colorCode: 0xFF179E5E),
    ScheduleModel(className: "XI TKJ 2", startTime: "10:15", endTime: "11:45", subject: "Administrasi Sistem Jaringan", location: "Lab 18", colorCode: 0xFFE02B2B),
  ],
  'Rabu': [
    ScheduleModel(className: "XII RPL 1", startTime: "07:15", endTime: "10:15", subject: "Produk Kreatif & Kewirausahaan", location: "Lab 19", colorCode: 0xFFF09819),
  ],
  'Kamis': [], // Contoh hari kosong/tidak ada jadwal
  'Jumat': [
    ScheduleModel(className: "XI RPL 1", startTime: "07:30", endTime: "09:00", subject: "Basis Data", location: "Lab 20", colorCode: 0xFF2B9EE0),
  ],
};