import 'package:flutter/material.dart';
import 'package:attend/core/theme/app_colors.dart';
import 'package:attend/features/admin/presentation/screens/manageTeacherAttendance/models/teacher_presence_model.dart';

class MonitoringTab extends StatefulWidget {
  const MonitoringTab({super.key});

  @override
  State<MonitoringTab> createState() => _MonitoringTabState();
}

class _MonitoringTabState extends State<MonitoringTab> {
  DateTime _selectedDate = DateTime.now();
  String _activeFilter = 'masuk'; // 'masuk' or 'pulang'

  // TODO: Replace with actual data from database
  final int _hadirCount = 45;
  final int _terlambatCount = 3;
  final int _belumHadirCount = 2;

  final List<TeacherPresence> _presenceLog = [
    TeacherPresence(
      teacherId: '1',
      teacherName: 'Drs. Supriyadi',
      subject: 'Fisika',
      checkInTime: DateTime(2026, 5, 19, 6, 45),
      statusIn: 'Tepat Waktu',
      latitude: -7.7956,
      longitude: 110.3695,
    ),
    TeacherPresence(
      teacherId: '2',
      teacherName: 'Siti Aminah, M.Pd',
      subject: 'Matematika',
      checkInTime: DateTime(2026, 5, 19, 6, 55),
      statusIn: 'Tepat Waktu',
      latitude: -7.7958,
      longitude: 110.3697,
    ),
    TeacherPresence(
      teacherId: '3',
      teacherName: 'Budi Hartono',
      subject: 'Bahasa Inggris',
      checkInTime: DateTime(2026, 5, 19, 7, 12),
      statusIn: 'Terlambat',
      latitude: -7.7960,
      longitude: 110.3700,
    ),
    TeacherPresence(
      teacherId: '4',
      teacherName: 'Dewi Lestari',
      subject: 'Seni Budaya',
      checkInTime: DateTime(2026, 5, 19, 6, 50),
      statusIn: 'Tepat Waktu',
      latitude: -7.7955,
      longitude: 110.3694,
    ),
    TeacherPresence(
      teacherId: '5',
      teacherName: 'Ahmad Fauzi',
      subject: 'Pendidikan Agama',
      checkInTime: DateTime(2026, 5, 19, 7, 20),
      statusIn: 'Terlambat',
      latitude: -7.7962,
      longitude: 110.3701,
    ),
  ];

  String _getFormattedDate(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    final weekdays = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu',
    ];
    return "${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          _buildSummaryCards(),
          const SizedBox(height: 20),

          // Filter Chips
          _buildFilterChips(),
          const SizedBox(height: 20),

          // Date Picker
          _buildDatePicker(),
          const SizedBox(height: 20),

          // Activity Log Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Log Aktivitas',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_presenceLog.length} entri',
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Activity List
          ..._presenceLog.map((presence) => _buildActivityCard(presence)),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Hadir',
            count: _hadirCount,
            icon: Icons.check_circle_rounded,
            color: const Color(0xFF10B981),
            bgColor: const Color(0xFFECFDF5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            title: 'Terlambat',
            count: _terlambatCount,
            icon: Icons.schedule_rounded,
            color: const Color(0xFFF59E0B),
            bgColor: const Color(0xFFFFF7ED),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            title: 'Belum',
            count: _belumHadirCount,
            icon: Icons.cancel_rounded,
            color: const Color(0xFFEF4444),
            bgColor: const Color(0xFFFEF2F2),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Row(
      children: [
        _buildFilterChip('Presensi Masuk', 'masuk', Icons.login_rounded),
        const SizedBox(width: 12),
        _buildFilterChip('Presensi Pulang', 'pulang', Icons.logout_rounded),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    final isActive = _activeFilter == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeFilter = value),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryBlue : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive ? AppColors.primaryBlue : Colors.grey.shade200,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? Colors.white : AppColors.textGreyHint,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : AppColors.textGreyHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            const Icon(Icons.calendar_month_outlined, color: AppColors.primaryBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _getFormattedDate(_selectedDate),
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(TeacherPresence presence) {
    final isCheckIn = _activeFilter == 'masuk';
    final time = isCheckIn ? presence.checkInTime : presence.checkOutTime;
    final status = isCheckIn ? presence.statusIn : presence.statusOut;
    final isLate = status == 'Terlambat' || status == 'Pulang Awal';

    if (time == null) return const SizedBox.shrink();

    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} WIB';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.bgLightBlue,
            child: Text(
              presence.teacherName[0],
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  presence.teacherName,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  presence.subject,
                  style: const TextStyle(
                    color: AppColors.textGreyHint,
                    fontSize: 12,
                  ),
                ),
                if (presence.latitude != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: AppColors.textGreyHint.withOpacity(0.7),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${presence.latitude!.toStringAsFixed(4)}, ${presence.longitude!.toStringAsFixed(4)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textGreyHint.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Time & Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isLate
                      ? const Color(0xFFFFF7ED)
                      : const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: isLate
                            ? const Color(0xFFD97706)
                            : const Color(0xFF059669),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isLate
                          ? Icons.schedule_rounded
                          : Icons.check_circle,
                      color: isLate
                          ? const Color(0xFFD97706)
                          : const Color(0xFF059669),
                      size: 12,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                (status ?? '').toUpperCase(),
                style: TextStyle(
                  color: isLate
                      ? const Color(0xFFD97706)
                      : AppColors.textLightGrey,
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
