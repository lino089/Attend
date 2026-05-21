import 'package:attend/features/teacher/presentation/screens/attendance/teacher_attendance_screen.dart';
import 'package:attend/features/teacher/presentation/screens/attendance_history/teacher_attendance_history_screen.dart';
import 'package:attend/features/teacher/presentation/screens/exam/teacher_exam_list_screen.dart';
import 'package:attend/features/teacher/presentation/screens/exam/teacher_grading_exam_list_screen.dart';
import 'package:attend/features/teacher/presentation/screens/exam_history/teacher_exam_history_screen.dart';
import 'package:attend/features/teacher/presentation/screens/presence/teacher_qr_scanner_screen.dart';
import 'package:attend/features/teacher/presentation/screens/exam/teacher_grade_report_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:attend/core/services/schedule_config_service.dart';
import 'package:attend/core/services/schedule_engine.dart';
import 'package:attend/shared/widgets/shimmer_loading.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  bool _isLoading = true;
  late final ScheduleConfigService _configService;

  // Presence state
  bool _hasCheckedIn = false;
  bool _hasCheckedOut = false;
  String? _checkInTimeStr;
  String? _checkOutTimeStr;
  String? _checkInStatus;

  // Profile data
  String _teacherName = 'Budi Santoso';
  String _teacherSubject = 'Web Programming';
  String _profileImageUrl = '';

  // Debug & Simulator state
  bool _debugMode = false;
  int _simulatedHour = 8;
  int _simulatedMinute = 0;
  bool _simulatedAttendanceDone = false; // "Start Attendance" clicked state

  // Master daily schedule for teacher simulation
  final List<Map<String, dynamic>> _teacherDailySchedule = [
    {
      'subject': 'Web Programming',
      'grade': 'XII RPL 1',
      'startTime': '07:30',
      'endTime': '09:00',
      'location': 'Lab Komputer 2',
      'teacher': 'Budi Santoso',
      'isRest': false,
      'classCode': 'XII RPL 1',
    },
    {
      'subject': 'Network Security',
      'grade': 'XI TKJ 1',
      'startTime': '09:00',
      'endTime': '09:30',
      'location': 'Lab Komputer 1',
      'teacher': 'Budi Santoso',
      'isRest': false,
      'classCode': 'XI TKJ 1',
    },
    {
      'subject': 'Istirahat',
      'startTime': '09:30',
      'endTime': '10:00',
      'isRest': true,
      'classCode': 'ISTIRAHAT',
    },
    {
      'subject': 'Web Programming',
      'grade': 'XII RPL 2',
      'startTime': '10:00',
      'endTime': '12:00',
      'location': 'Lab Komputer 2',
      'teacher': 'Budi Santoso',
      'isRest': false,
      'classCode': 'XII RPL 2',
    },
    {
      'subject': 'Istirahat Kedua',
      'startTime': '12:00',
      'endTime': '13:00',
      'isRest': true,
      'classCode': 'ISTIRAHAT',
    },
    {
      'subject': 'Mobile Programming',
      'grade': 'XI RPL 2',
      'startTime': '13:00',
      'endTime': '14:30',
      'location': 'Lab Komputer 3',
      'teacher': 'Budi Santoso',
      'isRest': false,
      'classCode': 'XI RPL 2',
    },
  ];

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color greenStatus = Color(0xFF10B981);
  static const Color purpleIcon = Color(0xFF9333EA);
  static const Color orangeIcon = Color(0xFFEA580C);

  @override
  void initState() {
    super.initState();
    _configService = ScheduleConfigService();
    _configService.addListener(_onConfigChanged);
    _fetchDashboardData();
  }

  @override
  void dispose() {
    _configService.removeListener(_onConfigChanged);
    super.dispose();
  }

  void _onConfigChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate database latency
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _teacherName = 'Budi Santoso';
        _teacherSubject = 'Web Programming';
        _profileImageUrl = '';
        _isLoading = false;
      });
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
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    if (_isLoading) {
      return _buildShimmerLoading();
    }

    // Determine current active time
    final activeTime = _debugMode
        ? DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            _simulatedHour,
            _simulatedMinute,
          )
        : DateTime.now();

    // Calculate lesson states
    final lessonState = ScheduleEngine.calculateCurrentState(
      currentTime: activeTime,
      dailySchedule: _teacherDailySchedule,
      hasCompletedAttendance: _simulatedAttendanceDone,
    );

    // Get remaining schedule (excluding ongoing/upcoming/rest lesson that is already shown)
    final remaining = ScheduleEngine.getRemainingSchedule(
      currentTime: activeTime,
      dailySchedule: _teacherDailySchedule,
    ).where((lesson) {
      if (lessonState.status == LessonStatus.ongoing ||
          lessonState.status == LessonStatus.ongoingDone ||
          lessonState.status == LessonStatus.breakTime ||
          lessonState.status == LessonStatus.upcoming) {
        return lesson['subject'] != lessonState.subject ||
            lesson['startTime'] != lessonState.startTime;
      }
      return true;
    }).toList();

    final showActiveClassCard = lessonState.status == LessonStatus.ongoing ||
        lessonState.status == LessonStatus.ongoingDone ||
        lessonState.status == LessonStatus.upcoming;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Blue Background
            _buildHeader(),

            // Content Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Active Class Card (Start Attendance)
                  if (showActiveClassCard) ...[
                    _buildActiveClassCard(lessonState),
                    const SizedBox(height: 32),
                  ],

                  // Teacher Menu Section
                  const Text(
                    'Teacher Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Presence Button (dynamic: Masuk / Pulang / Selesai)
                  _buildPresenceButton(),
                  const SizedBox(height: 16),

                  _buildPrimaryActionRow(),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildMenuCard(
                          title: 'Attendance\nHistory',
                          icon: Icons.history_rounded,
                          iconBgColor: const Color(0xFFF3E8FF),
                          iconColor: purpleIcon,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TeacherAttendanceHistoryScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMenuCard(
                          title: 'Exam\nHistory',
                          icon: Icons.assignment_turned_in_outlined,
                          iconBgColor: const Color(0xFFFFF7ED),
                          iconColor: orangeIcon,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TeacherExamHistoryScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildFullWidthMenuCard(
                    title: 'Rekap Nilai Siswa',
                    subtitle: 'Lihat nilai siswa',
                    icon: Icons.table_view_rounded,
                    iconBgColor: const Color(0xFFECFDF5),
                    iconColor: const Color(0xFF10B981),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const TeacherGradeReportListScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Next Schedule Section
                  if (remaining.isNotEmpty) ...[
                    const Text(
                      'Next Schedule',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ...remaining.map(
                      (schedule) => _buildNextScheduleCard(schedule),
                    ),
                  ],

                  // Debug Simulator Card
                  _buildDebugSimulator(),

                  const SizedBox(height: 100), // Space for bottom navigation
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Shimmer Header
            Container(
              width: double.infinity,
              height: 180,
              decoration: const BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const ShimmerPlaceholder(width: 56, height: 56, borderRadius: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            ShimmerPlaceholder(width: 160, height: 18, borderRadius: 4),
                            SizedBox(height: 8),
                            ShimmerPlaceholder(width: 100, height: 12, borderRadius: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const ShimmerCard(height: 180),
                  const SizedBox(height: 24),
                  Row(
                    children: const [
                      Expanded(child: ShimmerCard(height: 120)),
                      SizedBox(width: 16),
                      Expanded(child: ShimmerCard(height: 120)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const ShimmerCard(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Row(
            children: [
              // Profile Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withOpacity(0.2),
                backgroundImage: _profileImageUrl.isNotEmpty
                    ? NetworkImage(_profileImageUrl)
                    : null,
                child: _profileImageUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.white, size: 32)
                    : null,
              ),
              const SizedBox(width: 16),

              // Profile Info
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
                    const SizedBox(height: 4),
                    Text(
                      _teacherSubject,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getTodayDate(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Notification Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Navigasi ke Notifikasi'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveClassCard(LessonCardState state) {
    Color badgeColor;
    Color badgeTextColor;
    String badgeText;
    IconData statusIcon;
    bool isButtonEnabled = false;
    String buttonText = "Start Attendance";
    IconData buttonIcon = Icons.how_to_reg;

    switch (state.status) {
      case LessonStatus.upcoming:
        badgeColor = Colors.orange.shade50;
        badgeTextColor = Colors.orange.shade700;
        badgeText = 'MENDATANG';
        statusIcon = Icons.lock_outline;
        isButtonEnabled = false;
        buttonText = 'Mulai Presensi (Mendatang)';
        buttonIcon = Icons.lock_outline;
        break;
      case LessonStatus.ongoing:
        badgeColor = greenStatus.withOpacity(0.1);
        badgeTextColor = greenStatus;
        badgeText = 'SEDANG BERLANGSUNG';
        statusIcon = Icons.play_circle_fill_rounded;
        isButtonEnabled = true;
        buttonText = 'Start Attendance';
        buttonIcon = Icons.how_to_reg;
        break;
      case LessonStatus.ongoingDone:
        badgeColor = Colors.blue.shade50;
        badgeTextColor = primaryBlue;
        badgeText = 'PRESENSI SELESAI';
        statusIcon = Icons.check_circle_rounded;
        isButtonEnabled = false;
        buttonText = 'Presensi Selesai';
        buttonIcon = Icons.check_circle_rounded;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
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
          // Status and Time Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: badgeTextColor, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      badgeText,
                      style: TextStyle(
                        color: badgeTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Time
              Text(
                '${state.startTime} - ${state.endTime} WIB',
                style: const TextStyle(
                  color: textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Class Info
          Text(
            '${state.location} • ${state.subject}',
            style: const TextStyle(
              color: textDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sisa waktu: ${state.minutesRemaining} menit',
            style: const TextStyle(color: textGrey, fontSize: 14),
          ),

          const SizedBox(height: 24),

          // Start Attendance Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: isButtonEnabled
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherAttendanceScreen(
                            classId: '123',
                            className: state.location,
                            subject: state.subject,
                          ),
                        ),
                      ).then((_) {
                        setState(() {
                          _simulatedAttendanceDone = true;
                        });
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonEnabled ? primaryBlue : Colors.grey.shade100,
                foregroundColor: isButtonEnabled ? Colors.white : Colors.grey.shade400,
                disabledBackgroundColor: Colors.grey.shade100,
                disabledForegroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              icon: Icon(buttonIcon, size: 20),
              label: Text(
                buttonText,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryActionRow() {
    return Row(
      children: [
        Expanded(
          child: _buildSmallActionCard(
            title: 'Create Test',
            subtitle: 'New exam',
            icon: Icons.quiz_outlined,
            iconBgColor: const Color(0xFFF0F4FF),
            iconColor: primaryBlue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeacherExamListScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSmallActionCard(
            title: 'Penilaian',
            subtitle: 'Koreksi esai',
            icon: Icons.checklist_rtl_rounded,
            iconBgColor: greenStatus.withOpacity(0.1),
            iconColor: greenStatus,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeacherGradingExamListScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSmallActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: textDark,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: textGrey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresenceButton() {
    String title;
    String subtitle;
    IconData icon;
    List<Color> gradientColors;
    bool isDisabled = false;

    if (!_hasCheckedIn) {
      title = 'Presensi Kehadiran';
      subtitle = 'Belum presensi hari ini';
      icon = Icons.qr_code_scanner_rounded;
      gradientColors = [const Color(0xFF335CFA), const Color(0xFF7C3AED)];
    } else if (!_hasCheckedOut) {
      title = 'Presensi Pulang';
      subtitle = 'Masuk: $_checkInTimeStr ✓ $_checkInStatus';
      icon = Icons.logout_rounded;
      gradientColors = [const Color(0xFF10B981), const Color(0xFF0D9488)];
    } else {
      title = 'Presensi Selesai';
      subtitle = 'Masuk: $_checkInTimeStr • Pulang: $_checkOutTimeStr';
      icon = Icons.check_circle_rounded;
      gradientColors = [const Color(0xFF94A3B8), const Color(0xFF64748B)];
      isDisabled = true;
    }

    return InkWell(
      onTap: isDisabled
          ? null
          : () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeacherQrScannerScreen(
                    isCheckOut: _hasCheckedIn,
                  ),
                ),
              );

              if (mounted) {
                final now = DateTime.now();
                final timeStr =
                    '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';
                setState(() {
                  if (!_hasCheckedIn) {
                    _hasCheckedIn = true;
                    _checkInTimeStr = timeStr;
                    _checkInStatus = 'Tepat Waktu';
                  } else if (!_hasCheckedOut) {
                    _hasCheckedOut = true;
                    _checkOutTimeStr = timeStr;
                  }
                });
              }
            },
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (!isDisabled)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: textDark,
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

  Widget _buildFullWidthMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
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
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: textGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: textGrey.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextScheduleCard(Map<String, dynamic> schedule) {
    return Container(
      width: double.infinity,
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
            border: Border(left: BorderSide(color: primaryBlue, width: 6)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule['classCode'],
                style: const TextStyle(
                  color: primaryBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                schedule['subject'],
                style: const TextStyle(
                  color: textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${schedule['startTime']} - ${schedule['endTime']}',
                style: const TextStyle(color: textGrey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDebugSimulator() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.shade200, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bug_report, color: Colors.amber),
              const SizedBox(width: 8),
              const Text(
                'SIMULATOR WAKTU (DEBUG GURU)',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),
              Switch.adaptive(
                value: _debugMode,
                activeColor: Colors.amber,
                onChanged: (val) {
                  setState(() {
                    _debugMode = val;
                  });
                },
              ),
            ],
          ),
          if (_debugMode) ...[
            const Divider(height: 20),
            Text(
              'Waktu Simulasi: ${TimeOfDay(hour: _simulatedHour, minute: _simulatedMinute).format(context)} WIB',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: textDark,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTimeButton('07:00', 7, 0, 'Sebelum Sekolah (Buffer)'),
                _buildTimeButton('08:00', 8, 0, 'Jam 1: Web Programming XII RPL 1'),
                _buildTimeButton('09:15', 9, 15, 'Jam 2: Network Security XI TKJ 1'),
                _buildTimeButton('09:45', 9, 45, 'Istirahat 1'),
                _buildTimeButton('11:00', 11, 0, 'Jam 3: Web Programming XII RPL 2'),
                _buildTimeButton('12:30', 12, 30, 'Istirahat 2'),
                _buildTimeButton('13:30', 13, 30, 'Jam 4: Mobile Programming XI RPL 2'),
                _buildTimeButton('15:00', 15, 0, 'Setelah Sekolah (Selesai)'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Simulasikan Sudah Mulai Presensi:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),
                const Spacer(),
                Checkbox(
                  value: _simulatedAttendanceDone,
                  activeColor: primaryBlue,
                  onChanged: (val) {
                    setState(() {
                      _simulatedAttendanceDone = val ?? false;
                    });
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeButton(String label, int hour, int minute, String desc) {
    final bool isSelected = _simulatedHour == hour && _simulatedMinute == minute;
    return Tooltip(
      message: desc,
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Colors.amber.shade300,
        backgroundColor: Colors.white,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _simulatedHour = hour;
              _simulatedMinute = minute;
              _simulatedAttendanceDone = false;
            });
          }
        },
      ),
    );
  }
}
