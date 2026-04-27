import 'package:attend/shared/widgets/ongoing_detail_row.dart';
import 'package:attend/shared/widgets/schedule_item.dart';
import 'package:attend/shared/widgets/top_menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreen();
}

class _StudentDashboardScreen extends State<StudentDashboardScreen> {
  bool isLoading = true;

  String _studentName = "";
  String _studentGrade = "";
  String _profileImageUrl = "";

  Map<String, String>? _academicStatus;

  Map<String, dynamic>? _currentClass;

  List<Map<String, dynamic>> _displaySchedule = [];
  String _scheduleSectionTitle = "";

  static const Color primaryBlue = Color(0xff335cfa);
  static const Color textDark = Color(0xff1e293b);
  static const Color textGrey = Color(0xff64748b);

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final currentTime = TimeOfDay.now();

      final List<Map<String, dynamic>> fetchSchedule = [
        {
          "subject": "Pemrograman Web",
          "startHour": 9,
          "startMinute": 30,
          "endHour": 12,
          "endMinute": 0,
          "location": "Lab Komputer 2",
          "teacher": "Rossy Rahmadani",
          "isRest": false,
        },
        {
          "subject": "Physics",
          "startHour": 12, "startMinute": 30, // Disesuaikan agar logika jalan
          "endHour": 14, "endMinute": 0,
          "location": "Room 101",
          "teacher": "Mr. Albert",
          "isRest": false,
        },
        {
          "subject": "Rest",
          "startHour": 12,
          "startMinute": 0,
          "endHour": 12,
          "endMinute": 30,
          "location": "-",
          "teacher": "-",
          "isRest": true,
        },
      ];

      final List<Map<String, dynamic>> tomorrowSchedule = [
        {
          "subject": "Mathematics",
          "startHour": 7,
          "startMinute": 30,
          "endHour": 9,
          "endMinute": 0,
          "location": "Room 201",
          "teacher": "Mrs. Anita",
          "isRest": false,
        },
        {
          "subject": "English",
          "startHour": 9,
          "startMinute": 0,
          "endHour": 10,
          "endMinute": 30,
          "location": "Language Lab",
          "teacher": "Mr. John",
          "isRest": false,
        },
      ];

      Map<String, dynamic>? activeClass;
      List<Map<String, dynamic>> upcomingClasses = [];

      for (var cls in fetchSchedule) {
        double start = cls['startHour'] + (cls['startMinute'] / 60.0);
        double end = cls['endHour'] + (cls['endMinute'] / 60.0);
        double now = currentTime.hour + (currentTime.minute / 60.0);

        if (now >= start && now < end) {
          activeClass = cls;
        } else if (now < start) {
          upcomingClasses.add(cls);
        }
      }

      String tempTitle;
      List<Map<String, dynamic>> tempDisplaySchedule;

      if (upcomingClasses.isNotEmpty) {
        tempTitle = 'Remaining Schedule';
        tempDisplaySchedule = tomorrowSchedule;
      } else {
        tempTitle = 'Tomorrow Schedule';
        tempDisplaySchedule = tomorrowSchedule;
      }

      if (mounted) {
        setState(() {
          _studentName = 'Ahmad Yani';
          _studentGrade = 'XII RPL 2';
          _academicStatus = {
            "title": 'Minggu Jurusan',
            'desc': 'Aktifitas belajar jurusan',
          };
          _currentClass = activeClass;
          _scheduleSectionTitle = tempTitle;
          _displaySchedule = tempDisplaySchedule;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  String _getTodayDate() {
    final now = DateTime.now();
    final months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];
    final weekdays = [
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'SUNDAY',
    ];
    return "${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: primaryBlue)),
      );
    }
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white24,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _studentName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Grade: $_studentGrade",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getTodayDate(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.notifications_none_rounded, color: Colors.white,),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(
                        child: TopMenuCard(
                          title: 'EXAM',
                          subtitle: 'View',
                          icon: Icons.assignment_outlined,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TopMenuCard(
                          title: 'EXAM HISTORY',
                          subtitle: 'Check pevioud scores',
                          icon: Icons.history_rounded,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  if (_currentClass != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sekarang berlangsung',
                            style: TextStyle(
                              color: primaryBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _currentClass!['subject'],
                            style: const TextStyle(
                              color: textDark,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          OngoingDetailRow(
                            icon: Icons.access_time,
                            text:
                                '${_formatTime(_currentClass!['startHour'], _currentClass!['startMinute'])} - ${_formatTime(_currentClass!['endHour'], _currentClass!['endMinute'])} WIB',
                          ),
                          const SizedBox(height: 12),
                          OngoingDetailRow(
                            icon: Icons.location_on_outlined,
                            text: _currentClass!['location'],
                          ),
                          const SizedBox(height: 12),
                          OngoingDetailRow(
                            icon: Icons.person_outline,
                            text: "Guru: ${_currentClass!['teacher']}",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (_academicStatus != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xfff0f4ff),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ACADEMIC STATUS',
                            style: TextStyle(
                              color: primaryBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _academicStatus!['title']!,
                            style: const TextStyle(
                              color: primaryBlue,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: primaryBlue,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _academicStatus!['desc']!,
                                  style: const TextStyle(
                                    color: primaryBlue,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  if(_displaySchedule.isNotEmpty) ...[
                    Text(
                      _scheduleSectionTitle,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textDark),
                    ),
                    const SizedBox(height: 16),
                    ..._displaySchedule.map((cls) => ScheduleItem(
                      isRest: cls['isRest'],
                      subject: cls['subject'],
                      grade: _studentGrade,
                      time: "${_formatTime(cls['startHour'], cls['startMinute'])} - ${_formatTime(cls['endHour'], cls['endMinute'])}",
                    ))
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int hour, int minute) {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }
}

