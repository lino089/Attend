import 'package:flutter/material.dart';
import 'package:attend/core/theme/app_colors.dart';
import 'package:attend/core/services/schedule_config_service.dart';
import 'package:attend/core/services/schedule_conflict_detector.dart';
import 'package:attend/features/admin/presentation/screens/manageSchedule/teacher_schedule_list_screen.dart';
import 'package:attend/features/admin/presentation/screens/manageSchedule/student_schedule_list_screen.dart';
import 'package:attend/features/admin/presentation/screens/manageSchedule/rolling_student_schedule_list_screen.dart';
import 'package:attend/features/admin/presentation/screens/manageSchedule/rolling_teacher_schedule_list_screen.dart';
import 'package:attend/features/admin/presentation/screens/manageSchedule/schedule_structure_dialogs.dart';

class ManageScheduleSelectionScreen extends StatefulWidget {
  const ManageScheduleSelectionScreen({super.key});

  @override
  State<ManageScheduleSelectionScreen> createState() => _ManageScheduleSelectionScreenState();
}

class _ManageScheduleSelectionScreenState extends State<ManageScheduleSelectionScreen> {
  final _config = ScheduleConfigService();
  final _conflictDetector = ScheduleConflictDetector();

  @override
  void initState() {
    super.initState();
    _config.addListener(_rebuild);
    _conflictDetector.addListener(_rebuild);
  }

  @override
  void dispose() {
    _config.removeListener(_rebuild);
    _conflictDetector.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleTeacherScheduleTap() {
    final mainContext = context;
    if (_config.structure == ScheduleStructure.none) {
      showScheduleStructureBottomSheet(
        context: context,
        scheduleType: 'teacher',
        onFixedScheduleSelected: () {
          _config.setStructure(ScheduleStructure.fixed);
          Navigator.push(
            mainContext,
            MaterialPageRoute(
              builder: (context) => const TeacherScheduleListScreen(),
            ),
          );
        },
        onRollingScheduleSelected: (ctx) {
          showRollingConfigBottomSheet(
            context: ctx,
            scheduleType: 'teacher',
            onConfigComplete: (patternNames) {
              _config.configureRolling(
                patternNames: patternNames,
                rotationDuration: 'Setiap 2 Minggu',
                startDate: DateTime.now(),
              );
              Navigator.push(
                mainContext,
                MaterialPageRoute(
                  builder: (context) => RollingTeacherScheduleListScreen(
                    patternNames: patternNames,
                  ),
                ),
              );
            },
          );
        },
      );
    } else if (_config.structure == ScheduleStructure.fixed) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TeacherScheduleListScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RollingTeacherScheduleListScreen(
            patternNames: _config.patternNames,
          ),
        ),
      );
    }
  }

  void _handleStudentScheduleTap() {
    final mainContext = context;
    if (_config.structure == ScheduleStructure.none) {
      showScheduleStructureBottomSheet(
        context: context,
        scheduleType: 'student',
        onFixedScheduleSelected: () {
          _config.setStructure(ScheduleStructure.fixed);
          Navigator.push(
            mainContext,
            MaterialPageRoute(
              builder: (context) => const StudentScheduleListScreen(),
            ),
          );
        },
        onRollingScheduleSelected: (ctx) {
          showRollingConfigBottomSheet(
            context: ctx,
            scheduleType: 'student',
            onConfigComplete: (patternNames) {
              _config.configureRolling(
                patternNames: patternNames,
                rotationDuration: 'Setiap 2 Minggu',
                startDate: DateTime.now(),
              );
              Navigator.push(
                mainContext,
                MaterialPageRoute(
                  builder: (context) => RollingStudentScheduleListScreen(
                    patternNames: patternNames,
                  ),
                ),
              );
            },
          );
        },
      );
    } else if (_config.structure == ScheduleStructure.fixed) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StudentScheduleListScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RollingStudentScheduleListScreen(
            patternNames: _config.patternNames,
          ),
        ),
      );
    }
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pengaturan Struktur Jadwal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 8),
              Text(
                'Struktur aktif saat ini: ${_config.structure == ScheduleStructure.fixed ? "Jadwal Tetap" : _config.structure == ScheduleStructure.rolling ? "Jadwal Bergulir" : "Belum Diatur"}',
                style: const TextStyle(color: AppColors.textGreyLabel, fontSize: 13),
              ),
              const SizedBox(height: 24),
              if (_config.structure != ScheduleStructure.none) ...[
                ListTile(
                  leading: const Icon(Icons.settings_backup_restore_rounded, color: Colors.orange),
                  title: const Text('Reset Struktur Jadwal', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Kembalikan ke pemilihan awal (None)'),
                  onTap: () {
                    _config.resetConfig();
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Konfigurasi struktur jadwal telah di-reset.')),
                    );
                  },
                ),
                const Divider(),
              ],
              ListTile(
                leading: const Icon(Icons.change_circle_outlined, color: AppColors.primaryBlue),
                title: const Text('Ubah Tipe Struktur', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Ganti tipe jadwal (Tetap <-> Bergulir)'),
                onTap: () {
                  Navigator.pop(ctx);
                  showScheduleStructureBottomSheet(
                    context: context,
                    scheduleType: 'general',
                    onFixedScheduleSelected: () {
                      _config.setStructure(ScheduleStructure.fixed);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Struktur diubah menjadi Jadwal Tetap.')),
                      );
                    },
                    onRollingScheduleSelected: (c) {
                      showRollingConfigBottomSheet(
                        context: c,
                        scheduleType: 'general',
                        onConfigComplete: (patternNames) {
                          _config.configureRolling(
                            patternNames: patternNames,
                            rotationDuration: 'Setiap 2 Minggu',
                            startDate: DateTime.now(),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Struktur diubah menjadi Jadwal Bergulir.')),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConflictBanner() {
    if (!_conflictDetector.hasConflicts) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Konflik Sinkronisasi Jadwal',
                  style: TextStyle(
                    color: Color(0xFF78350F),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Terdeteksi ${_conflictDetector.activeConflicts.length} ketidakselarasan jadwal guru & siswa.',
                  style: const TextStyle(
                    color: Color(0xFF92400E),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => showConflictDetailsBottomSheet(context: context, conflicts: _conflictDetector.activeConflicts),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF78350F).withOpacity(0.08),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Lihat',
              style: TextStyle(color: Color(0xFF78350F), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Jadwal',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textDark),
            onPressed: () => _showSettingsBottomSheet(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Optimalkan Waktu\nSekolah Anda.',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),
            
            // Conflict Alert Banner
            _buildConflictBanner(),
            
            _MenuCard(
              title: 'Kelola Jadwal Guru',
              subtitle: 'Atur jam mengajar dan rotasi pengajar.',
              icon: Icons.contact_page_outlined,
              onTap: _handleTeacherScheduleTap,
            ),
            
            const SizedBox(height: 16),
            
            _MenuCard(
              title: 'Kelola Jadwal Siswa',
              subtitle: 'Organisir kelas dan kurikulum harian.',
              icon: Icons.school_outlined,
              onTap: _handleStudentScheduleTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuCard({
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
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E6FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.primaryBlue, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textGreyLabel,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 24),
          ],
        ),
      ),
    );
  }
}
