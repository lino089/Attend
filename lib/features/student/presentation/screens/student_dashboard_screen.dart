import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:attend/features/student/presentation/screens/exam/student_exam_list_screen.dart';
import 'exam_history/student_exam_history_screen.dart';
import 'package:attend/core/services/schedule_config_service.dart';
import 'package:attend/core/services/schedule_engine.dart';
import 'package:attend/shared/widgets/shimmer_loading.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color lightBlueBg = Color(0xFFF0F4FF);
  static const Color bgGrey = Color(0xFFF8F9FA);

  bool _isLoading = true;
  late final ScheduleConfigService _configService;

  // Student Info
  String _studentName = "";
  String _studentGrade = "";
  String? _studentPhotoUrl;
  Map<String, String>? _academicStatus;

  // Debug & Simulation state
  bool _debugMode = false;
  int _simulatedHour = 8;
  int _simulatedMinute = 0;
  bool _simulatedAttendanceDone = false;

  // Master schedule for student simulation
  final List<Map<String, dynamic>> _studentDailySchedule = [
    {
      "subject": "Matematika",
      "grade": "XII RPL 2",
      "startTime": "07:30",
      "endTime": "09:00",
      "teacherName": "Mrs. Rossy",
      "teacherPhotoUrl": null,
      "location": "Lab Komputer 2",
      "isRest": false,
    },
    {
      "subject": "Bahasa Inggris",
      "grade": "XII RPL 2",
      "startTime": "09:00",
      "endTime": "09:30",
      "teacherName": "Mr. John",
      "teacherPhotoUrl": null,
      "location": "Ruang Kelas 12",
      "isRest": false,
    },
    {
      "subject": "Istirahat",
      "startTime": "09:30",
      "endTime": "10:00",
      "isRest": true,
    },
    {
      "subject": "Pemrograman Web",
      "grade": "XII RPL 2",
      "startTime": "10:00",
      "endTime": "12:00",
      "teacherName": "Mrs. Rossy",
      "teacherPhotoUrl": null,
      "location": "Lab Komputer 2",
      "isRest": false,
    },
    {
      "subject": "Istirahat Kedua",
      "startTime": "12:00",
      "endTime": "13:00",
      "isRest": true,
    },
    {
      "subject": "Fisika",
      "grade": "XII RPL 2",
      "startTime": "13:00",
      "endTime": "14:30",
      "teacherName": "Mr. Albert",
      "teacherPhotoUrl": null,
      "location": "Ruang Fisika",
      "isRest": false,
    },
  ];

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
        _studentName = "Ahmad Baihaqi";
        _studentGrade = "XII RPL 2";
        _studentPhotoUrl = null;

        _academicStatus = {
          "title": "DEPARTMENT WEEK",
          "description": "Special activities scheduled for this week",
        };

        _isLoading = false;
      });
    }
  }

  String _getTodayDate() {
    final now = DateTime.now();
    final months = [
      'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
      'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER',
    ];
    final weekdays = [
      'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY',
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
      dailySchedule: _studentDailySchedule,
      hasCompletedAttendance: _simulatedAttendanceDone,
    );

    // Get remaining schedule (excluding ongoing/upcoming/rest lesson that is already shown)
    final remaining = ScheduleEngine.getRemainingSchedule(
      currentTime: activeTime,
      dailySchedule: _studentDailySchedule,
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

    return Scaffold(
      backgroundColor: bgGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Menu Cards
                  _buildTopMenuCards(),

                  const SizedBox(height: 24),

                  // Ongoing Class Card (only if it is not ended/notStarted)
                  if (lessonState.status != LessonStatus.ended &&
                      lessonState.status != LessonStatus.notStarted) ...[
                    _buildOngoingClassCard(lessonState),
                    const SizedBox(height: 24),
                  ],

                  // Academic Status Card (only for Rolling Schedule structure)
                  if (_configService.isRolling && _academicStatus != null) ...[
                    _buildAcademicStatusCard(),
                    const SizedBox(height: 32),
                  ],

                  // Remaining Schedule Section
                  if (remaining.isNotEmpty) ...[
                    _buildScheduleHeader(),
                    const SizedBox(height: 16),
                    _buildScheduleList(remaining),
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
      backgroundColor: bgGrey,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Expanded(child: ShimmerCard(height: 140)),
                      SizedBox(width: 16),
                      Expanded(child: ShimmerCard(height: 140)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const ShimmerCard(height: 180),
                  const SizedBox(height: 24),
                  const ShimmerCard(height: 120),
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
      width: double.infinity,
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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: _studentPhotoUrl != null
                      ? Image.network(
                          _studentPhotoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderPhoto();
                          },
                        )
                      : _buildPlaceholderPhoto(),
                ),
              ),

              const SizedBox(width: 16),

              // Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _studentName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Grade: $_studentGrade",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
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

  Widget _buildPlaceholderPhoto() {
    return Container(
      color: Colors.white.withOpacity(0.2),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  Widget _buildTopMenuCards() {
    return Row(
      children: [
        Expanded(
          child: _buildMenuCard(
            icon: Icons.assignment_outlined,
            title: 'EXAM',
            subtitle: 'View exam schedule',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentExamListScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMenuCard(
            icon: Icons.history_rounded,
            title: 'EXAM HISTORY',
            subtitle: 'Check previous scores',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentExamHistoryScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: primaryBlue,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: textDark,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: textGrey,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingClassCard(LessonCardState state) {
    Color badgeColor;
    Color badgeTextColor;
    String badgeText;
    IconData statusIcon;
    bool isClickable = false;

    switch (state.status) {
      case LessonStatus.upcoming:
        badgeColor = Colors.orange.shade50;
        badgeTextColor = Colors.orange.shade700;
        badgeText = 'MENDATANG';
        statusIcon = Icons.lock_outline;
        isClickable = false;
        break;
      case LessonStatus.ongoing:
        badgeColor = primaryBlue.withOpacity(0.1);
        badgeTextColor = primaryBlue;
        badgeText = 'SEKARANG BERLANGSUNG';
        statusIcon = Icons.play_circle_outline;
        isClickable = true;
        break;
      case LessonStatus.ongoingDone:
        badgeColor = Colors.green.shade50;
        badgeTextColor = Colors.green.shade700;
        badgeText = 'PRESENSI SELESAI';
        statusIcon = Icons.check_circle_outline;
        isClickable = false;
        break;
      case LessonStatus.breakTime:
        badgeColor = Colors.grey.shade100;
        badgeTextColor = Colors.grey.shade700;
        badgeText = 'SEDANG ISTIRAHAT';
        statusIcon = Icons.coffee_outlined;
        isClickable = false;
        break;
      case LessonStatus.ended:
      case LessonStatus.notStarted:
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
            blurRadius: 20,
            offset: const Offset(0, 4),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              if (state.status == LessonStatus.ongoing ||
                  state.status == LessonStatus.ongoingDone ||
                  state.status == LessonStatus.breakTime ||
                  state.status == LessonStatus.upcoming)
                Text(
                  '${state.minutesRemaining} m sisa',
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            state.subject,
            style: const TextStyle(
              color: textDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (state.status != LessonStatus.breakTime) ...[
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.access_time,
              text: '${state.startTime} - ${state.endTime} WIB',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.location_on_outlined,
              text: state.location,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.person_outline,
              text: 'Guru: ${state.teacher}',
            ),
            if (state.status == LessonStatus.ongoing) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _simulatedAttendanceDone = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Presensi berhasil dilakukan!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Lakukan Presensi Masuk',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ] else ...[
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.access_time,
              text: '${state.startTime} - ${state.endTime} WIB',
            ),
            const SizedBox(height: 8),
            const Text(
              'Gunakan waktu istirahat sebaik mungkin untuk menyegarkan pikiran Anda.',
              style: TextStyle(color: textGrey, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          color: textGrey,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: textGrey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAcademicStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: lightBlueBg,
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
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                color: primaryBlue,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _academicStatus!['description']!,
                  style: const TextStyle(
                    color: primaryBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Remaining Schedule',
          style: TextStyle(
            color: textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Navigasi ke Calendar'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: const Text(
            'VIEW CALENDAR',
            style: TextStyle(
              color: primaryBlue,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleList(List<Map<String, dynamic>> schedules) {
    return Column(
      children: schedules.map((schedule) {
        return _buildScheduleCard(schedule);
      }).toList(),
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> schedule) {
    final bool isRest = schedule['isRest'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Teacher Photo or Rest Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isRest
                  ? textGrey.withOpacity(0.1)
                  : primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: isRest
                ? const Icon(
                    Icons.local_cafe_outlined,
                    color: textGrey,
                    size: 24,
                  )
                : (schedule['teacherPhotoUrl'] != null
                    ? ClipOval(
                        child: Image.network(
                          schedule['teacherPhotoUrl'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              color: primaryBlue,
                              size: 28,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        color: primaryBlue,
                        size: 28,
                      )),
          ),

          const SizedBox(width: 16),

          // Schedule Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule['subject'],
                  style: TextStyle(
                    color: isRest ? textGrey : textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isRest
                      ? '${schedule['startTime']} - ${schedule['endTime']}'
                      : '${schedule['grade']} • ${schedule['startTime']} - ${schedule['endTime']}',
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
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
                'SIMULATOR WAKTU (DEBUG)',
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
                _buildTimeButton('08:00', 8, 0, 'Jam 1: Matematika'),
                _buildTimeButton('09:15', 9, 15, 'Jam 2: Bhs Inggris'),
                _buildTimeButton('09:45', 9, 45, 'Istirahat 1'),
                _buildTimeButton('11:00', 11, 0, 'Jam 3: Pemrograman Web'),
                _buildTimeButton('12:30', 12, 30, 'Istirahat 2'),
                _buildTimeButton('13:30', 13, 30, 'Jam 4: Fisika'),
                _buildTimeButton('15:00', 15, 0, 'Setelah Sekolah (Selesai)'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Simulasikan Sudah Presensi:',
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
