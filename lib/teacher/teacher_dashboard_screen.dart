import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreen();
}

class _TeacherDashboardScreen extends State<TeacherDashboardScreen> {
  bool isLoading = true;

  String _teacherName = '';
  String _teacherSubject = '';
  String _profileImageUrl = '';

  Map<String, dynamic>? _activeClass;
  List<Map<String, dynamic>> _displaySchedule = [];
  String _scheduleSectionTitle = '';

  static const Color primaryBlue = Color(0xff335cfa);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final currentTime = TimeOfDay.now();

      final List<Map<String, dynamic>> todayschedule = [
        {
          "className": "XII RPL 1",
          "subject": "Web Programming",
          "startHour": 8,
          "startMinute": 0,
          "endHour": 9,
          "endMinute": 30,
          "room": "Room 204",
          "building": "Building B",
          "hasTakenAttendance": false,
        },
        {
          "className": "XI TKJ 2",
          "subject": "Network Infrastructure Administration",
          "startHour": 10,
          "startMinute": 0,
          "endHour": 11,
          "endMinute": 30,
          "room": "Room 101",
          "building": "Building A",
          "hasTakenAttendance": false,
        },
      ];

      final List<Map<String, dynamic>> tomorowSchedule = [
        {
          "className": "X RPL 1",
          "subject": "Basic Programming",
          "startHour": 7,
          "startMinute": 30,
          "endHour": 9,
          "endMinute": 0,
          "room": "Lab 1",
          "building": "Building C",
          "hasTakenAttendance": false,
        },
      ];

      Map<String, dynamic>? activeClass;
      List<Map<String, dynamic>> upcommingClasses = [];

      for (var cls in todayschedule) {
        double start = cls['startHour'] + (cls['startMinute'] / 60.0);
        double end = cls['endHour'] + (cls['endMinute'] / 60.0);
        double now = currentTime.hour + (currentTime.minute / 60.0);

        if (now >= start && now < end) {
          activeClass = cls;
        } else if (now < start) {
          upcommingClasses.add(cls);
        }
      }

      String tempTitle;
      List<Map<String, dynamic>> tempDisplaySchedule;

      if (upcommingClasses.isNotEmpty) {
        tempTitle = 'Next Schedule';
        tempDisplaySchedule = upcommingClasses;
      } else {
        tempTitle = "Tommorow's Schedule";
        tempDisplaySchedule = tomorowSchedule;
      }

      if (mounted) {
        setState(() {
          _teacherName = 'Budi Santoso';
          _teacherSubject = 'Web Programing';
          _activeClass = activeClass;
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

  String _formatTime(int hour, int minute) {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: primaryBlue)),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 220,
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
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
                                      _teacherName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _teacherSubject,
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
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    if (_activeClass != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'IN PROGRESS',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${_formatTime(_activeClass!['startHour'], _activeClass!['startMinute'])} - ${_formatTime(_activeClass!['endHour'], _activeClass!['endMinute'])}",
                                  style: const TextStyle(
                                    color: textDark,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            Text(
                              "${_activeClass!['startHour']} • ${_activeClass!['subject']}",
                              style: const TextStyle(
                                color: textDark,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${_activeClass!['room']} • ${_activeClass!['building']}",
                              style: const TextStyle(
                                color: textGrey,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryBlue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.how_to_reg, size: 20),
                                label: const Text(
                                  'Start Attendace',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                    const SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                        const Text(
                          'Teacher Menu',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'VIEW ALL',
                            style: TextStyle(
                              color: primaryBlue,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _MenuCard(
                      title: 'Create Test',
                      subTitle: 'Design new assessment',
                      icon: Icons.quiz_outlined,
                      iconBgColor: const Color(0xfff0f4ff),
                      iconColor: primaryBlue,
                      isFullWidth: true,
                      onTap: () {},
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _MenuCard(
                            title: 'Attendance\nHistory',
                            subTitle: '',
                            icon: Icons.history_rounded,
                            iconBgColor: const Color(0xfff3e8ff),
                            iconColor: const Color(0xff9333ea),
                            isFullWidth: false,
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _MenuCard(
                            title: 'Exam\nHistory',
                            subTitle: '',
                            icon: Icons.assignment_turned_in_outlined,
                            iconBgColor: const Color(0xfffff7ed),
                            iconColor: const Color(0xffea580c),
                            isFullWidth: false,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    if (_displaySchedule.isNotEmpty) ...[
                      Text(
                        _scheduleSectionTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._displaySchedule.map(
                        (cls) => _NextScheduleItem(
                          className: cls['className'],
                          subject: cls['subject'],
                          time: "${_formatTime(cls['startHour'], cls['startMinute'])} - ${_formatTime(cls['endHour'], cls['endMinute'])}",
                        ),
                      ),
                    ],
                    const SizedBox(height: 40)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final bool isFullWidth;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.isFullWidth,
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
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isFullWidth
            ? Row(
                children: [
                  _buildIconBox(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: _TeacherDashboardScreen.textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subTitle,
                          style: const TextStyle(
                            color: _TeacherDashboardScreen.textGrey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIconBox(),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      color: _TeacherDashboardScreen.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildIconBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: iconColor, size: 28),
    );
  }
}

class _NextScheduleItem extends StatelessWidget {
  final String className;
  final String subject;
  final String time;

  const _NextScheduleItem({
    required this.className,
    required this.subject,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: _TeacherDashboardScreen.primaryBlue,
                width: 6,
              ),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                className,
                style: const TextStyle(
                  color: _TeacherDashboardScreen.primaryBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.05,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subject,
                style: const TextStyle(
                  color: _TeacherDashboardScreen.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                time,
                style: const TextStyle(
                  color: _TeacherDashboardScreen.textGrey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
