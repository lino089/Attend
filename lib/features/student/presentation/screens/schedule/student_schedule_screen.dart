import 'package:flutter/material.dart';
import 'models/student_schedule_model.dart';
import 'widgets/student_date_picker_widget.dart';
import 'widgets/student_schedule_card.dart';

class StudentScheduleScreen extends StatefulWidget {
  const StudentScheduleScreen({super.key});

  @override
  State<StudentScheduleScreen> createState() => _StudentScheduleScreenState();
}

class _StudentScheduleScreenState extends State<StudentScheduleScreen> {
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  int _selectedDayIndex = 1; // Default: Senin (1=Senin, 2=Selasa, ..., 6=Sabtu)

  // TODO: Replace with API call to fetch schedules
  final Map<int, List<StudentScheduleModel>> _schedulesByDay = {
    // 1 = Senin
    1: [
      StudentScheduleModel(
        id: '1',
        subjectName: 'Pemrograman Web',
        date: DateTime(2023, 10, 30), // Senin
        startTime: '07:15',
        endTime: '08:45',
        location: 'Lab Komputer',
        teacherName: 'Rossy Rahmadani',
      ),
      StudentScheduleModel(
        id: '2',
        subjectName: 'Basis Data',
        date: DateTime(2023, 10, 30),
        startTime: '09:00',
        endTime: '10:30',
        location: 'Ruang 04',
        teacherName: 'Mr. Albert',
      ),
      StudentScheduleModel(
        id: '3',
        subjectName: 'Matematika',
        date: DateTime(2023, 10, 30),
        startTime: '10:45',
        endTime: '12:15',
        location: 'Ruang 12',
        teacherName: 'Mrs. Anita',
      ),
    ],

    // 2 = Selasa
    2: [
      StudentScheduleModel(
        id: '4',
        subjectName: 'Jaringan Komputer',
        date: DateTime(2023, 10, 31), // Selasa
        startTime: '08:00',
        endTime: '09:30',
        location: 'Lab Jaringan',
        teacherName: 'Mr. Budi',
      ),
      StudentScheduleModel(
        id: '5',
        subjectName: 'Bahasa Inggris',
        date: DateTime(2023, 10, 31),
        startTime: '10:00',
        endTime: '11:30',
        location: 'Ruang 08',
        teacherName: 'Mr. John',
      ),
    ],

    // 3 = Rabu
    3: [
      StudentScheduleModel(
        id: '6',
        subjectName: 'Pemrograman Berorientasi Objek',
        date: DateTime(2023, 11, 1), // Rabu
        startTime: '07:30',
        endTime: '09:00',
        location: 'Lab 2A',
        teacherName: 'Mrs. Sarah',
      ),
      StudentScheduleModel(
        id: '7',
        subjectName: 'Fisika',
        date: DateTime(2023, 11, 1),
        startTime: '09:15',
        endTime: '10:45',
        location: 'Lab Fisika',
        teacherName: 'Mr. David',
      ),
    ],

    // 4 = Kamis
    4: [
      StudentScheduleModel(
        id: '8',
        subjectName: 'Sistem Operasi',
        date: DateTime(2023, 11, 2), // Kamis
        startTime: '08:00',
        endTime: '09:30',
        location: 'Lab Komputer',
        teacherName: 'Mr. Ahmad',
      ),
    ],

    // 5 = Jumat
    5: [
      StudentScheduleModel(
        id: '9',
        subjectName: 'Pemrograman Mobile',
        date: DateTime(2023, 11, 3), // Jumat
        startTime: '07:30',
        endTime: '09:00',
        location: 'Lab Mobile',
        teacherName: 'Mrs. Linda',
      ),
      StudentScheduleModel(
        id: '10',
        subjectName: 'Bahasa Indonesia',
        date: DateTime(2023, 11, 3),
        startTime: '09:15',
        endTime: '10:45',
        location: 'Ruang 05',
        teacherName: 'Mrs. Siti',
      ),
    ],

    // 6 = Sabtu
    6: [
      StudentScheduleModel(
        id: '11',
        subjectName: 'Pendidikan Agama',
        date: DateTime(2023, 11, 4), // Sabtu
        startTime: '08:00',
        endTime: '09:30',
        location: 'Ruang 10',
        teacherName: 'Mr. Hasan',
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    // Default: Senin (index 1)
    _selectedDayIndex = 1;
  }

  List<StudentScheduleModel> get _schedulesForSelectedDay {
    return (_schedulesByDay[_selectedDayIndex] ?? [])
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  int get _subjectCount => _schedulesForSelectedDay.length;

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
                  'Jadwal Pelajaran',
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
              child: StudentDatePickerWidget(
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
                                '$_subjectCount Mata Pelajaran (${_totalHours.toStringAsFixed(0)} Jam)',
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
                            return StudentScheduleCard(
                              schedule: schedule,
                              onTap: () {
                                // TODO: Navigate to schedule detail
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Jadwal: ${schedule.subjectName}',
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
            'Tidak ada jadwal pelajaran untuk hari ini',
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
