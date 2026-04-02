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

  List<Map<String, dynamic>> _remainingSchedule = [];

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
      if (mounted) {
        setState(() {
          _studentName = 'Ahmad Yani';
          _studentGrade = 'XII RPL 2';
          _academicStatus = {
            "title": 'Minggu Jurusa',
            'desc': 'Aktifitas belajar jurusan',
          };
          _currentClass = activeClass;
          _remainingSchedule = upcomingClasses;
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
    return SingleChildScrollView();
  }
}

class _TopMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _TopMenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xfff0f4ff),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: _StudentDashboardScreen.primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: _StudentDashboardScreen.textDark,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: _StudentDashboardScreen.textGrey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OngoingDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const OngoingDetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _StudentDashboardScreen.textGrey, size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _StudentDashboardScreen.textDark,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final bool isRest;
  final String subject;
  final String grade;
  final String time;

  const _ScheduleItem({
    required this.isRest,
    required this.subject,
    required this.grade,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isRest ? const Color(0xfff0f4ff) : Colors.grey,
              borderRadius: BorderRadius.circular(14),
            ),
            child: isRest
                ? const Icon(
                    Icons.coffee_outlined,
                    color: _StudentDashboardScreen.textDark,
                    fontWeight: FontWeight.bold,
                  )
                : const Icon(
                    Icons.face,
                    color: _StudentDashboardScreen.textGrey,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    color: _StudentDashboardScreen.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isRest ? time : "$grade • $time",
                  style: const TextStyle(color: _StudentDashboardScreen.textGrey, fontSize: 12),
                )
              ],
            ),
          ),
          if(!isRest) const Icon(Icons.chevron_right_sharp, color: Colors.grey,)
        ],
      ),
    );
  }
}
