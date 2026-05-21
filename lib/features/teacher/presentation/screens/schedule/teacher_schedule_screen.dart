import 'package:flutter/material.dart';
import 'models/schedule_model.dart';
import 'widgets/date_picker_widget.dart';
import 'widgets/schedule_card.dart';

class TeacherScheduleScreen extends StatefulWidget {
  const TeacherScheduleScreen({super.key});

  @override
  State<TeacherScheduleScreen> createState() => _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState extends State<TeacherScheduleScreen> {
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  int _selectedDayIndex = 1; // Default: Senin (1=Senin, 2=Selasa, ..., 6=Sabtu)

  // TODO: Replace with API call to fetch schedules
  final Map<int, List<ScheduleModel>> _schedulesByDay = {
    // 1 = Senin
    1: [
      ScheduleModel(
        id: '1',
        className: 'XI RPL 2',
        subjectName: 'Pemrograman Perangkat Bergerak',
        date: DateTime(2023, 10, 30), // Senin
        startTime: '07:15',
        endTime: '08:45',
        location: 'Lab 1B',
        studentCount: 32,
      ),
      ScheduleModel(
        id: '2',
        className: 'XII RPL 1',
        subjectName: 'Basis Data',
        date: DateTime(2023, 10, 30),
        startTime: '09:00',
        endTime: '10:30',
        location: 'Ruang 04',
        studentCount: 30,
      ),
      ScheduleModel(
        id: '3',
        className: 'XI RPL 1',
        subjectName: 'Pemrograman Web',
        date: DateTime(2023, 10, 30),
        startTime: '10:45',
        endTime: '12:15',
        location: 'Lab Komputer',
        studentCount: 32,
      ),
    ],
    
    // 2 = Selasa
    2: [
      ScheduleModel(
        id: '4',
        className: 'XII RPL 3',
        subjectName: 'Jaringan Komputer',
        date: DateTime(2023, 10, 31), // Selasa
        startTime: '08:00',
        endTime: '09:30',
        location: 'Lab Jaringan',
        studentCount: 28,
      ),
      ScheduleModel(
        id: '5',
        className: 'XI RPL 2',
        subjectName: 'Sistem Operasi',
        date: DateTime(2023, 10, 31),
        startTime: '10:00',
        endTime: '11:30',
        location: 'Ruang 12',
        studentCount: 32,
      ),
    ],
    
    // 3 = Rabu
    3: [
      ScheduleModel(
        id: '6',
        className: 'XII RPL 1',
        subjectName: 'Pemrograman Berorientasi Objek',
        date: DateTime(2023, 11, 1), // Rabu
        startTime: '07:30',
        endTime: '09:00',
        location: 'Lab 2A',
        studentCount: 30,
      ),
      ScheduleModel(
        id: '7',
        className: 'XI RPL 1',
        subjectName: 'Basis Data Lanjut',
        date: DateTime(2023, 11, 1),
        startTime: '09:15',
        endTime: '10:45',
        location: 'Ruang 08',
        studentCount: 32,
      ),
    ],
    
    // 4 = Kamis
    4: [
      ScheduleModel(
        id: '8',
        className: 'XII RPL 2',
        subjectName: 'Keamanan Jaringan',
        date: DateTime(2023, 11, 2), // Kamis
        startTime: '08:00',
        endTime: '09:30',
        location: 'Lab Jaringan',
        studentCount: 29,
      ),
    ],
    
    // 5 = Jumat
    5: [
      ScheduleModel(
        id: '9',
        className: 'XI RPL 2',
        subjectName: 'Mobile Programming',
        date: DateTime(2023, 11, 3), // Jumat
        startTime: '07:30',
        endTime: '09:00',
        location: 'Lab Mobile',
        studentCount: 32,
      ),
      ScheduleModel(
        id: '10',
        className: 'XII RPL 1',
        subjectName: 'Web Development',
        date: DateTime(2023, 11, 3),
        startTime: '09:15',
        endTime: '10:45',
        location: 'Lab Web',
        studentCount: 30,
      ),
    ],
    
    // 6 = Sabtu
    6: [
      ScheduleModel(
        id: '11',
        className: 'XI RPL 1',
        subjectName: 'Database Administration',
        date: DateTime(2023, 11, 4), // Sabtu
        startTime: '08:00',
        endTime: '09:30',
        location: 'Lab Database',
        studentCount: 32,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    // Default: Senin (index 1)
    _selectedDayIndex = 1;
  }

  List<ScheduleModel> get _schedulesForSelectedDay {
    return (_schedulesByDay[_selectedDayIndex] ?? [])
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  int get _classCount => _schedulesForSelectedDay.length;

  double get _totalHours {
    return _schedulesForSelectedDay.fold(
      0.0,
      (sum, schedule) => sum + schedule.durationHours,
    );
  }

  String get _selectedDayName {
    const dayNames = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    return dayNames[_selectedDayIndex];
  }

  void _onDaySelected(int dayIndex) {
    setState(() {
      _selectedDayIndex = dayIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Center(
                child: Text(
                  'Jadwal Mengajar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),
            ),

            // Day Picker (Senin - Sabtu) - Scrollable
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 20),
              child: DatePickerWidget(
                selectedDayIndex: _selectedDayIndex,
                onDaySelected: _onDaySelected,
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Expanded(
              child: _schedulesForSelectedDay.isEmpty
                  ? _buildEmptyState()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Selected day info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDayName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                ),
                              ),
                              Text(
                                '$_classCount Kelas (${_totalHours.toStringAsFixed(0)} Jam)',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF335CFA),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Schedule list
                          ..._schedulesForSelectedDay.map((schedule) {
                            return ScheduleCard(
                              schedule: schedule,
                              onTap: () {
                                // TODO: Navigate to schedule detail or start attendance
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Jadwal: ${schedule.className} - ${schedule.subjectName}',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak Ada Jadwal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tidak ada jadwal mengajar untuk hari ini',
            style: TextStyle(
              fontSize: 14,
              color: textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
