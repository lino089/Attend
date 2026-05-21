import 'package:flutter/material.dart';
import 'package:attend/core/theme/app_colors.dart';
import 'package:attend/features/admin/presentation/screens/manageTeacherAttendance/models/attendance_config_model.dart';
import 'package:attend/features/admin/presentation/screens/manageTeacherAttendance/widgets/qr_setup_tab.dart';
import 'package:attend/features/admin/presentation/screens/manageTeacherAttendance/widgets/monitoring_tab.dart';

class ManageTeacherAttendanceScreen extends StatefulWidget {
  const ManageTeacherAttendanceScreen({super.key});

  @override
  State<ManageTeacherAttendanceScreen> createState() =>
      _ManageTeacherAttendanceScreenState();
}

class _ManageTeacherAttendanceScreenState
    extends State<ManageTeacherAttendanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // TODO: Load from database
  AttendanceConfig _config = AttendanceConfig(
    schoolName: 'SMKN 1 Bantul',
    latitude: -7.7956,
    longitude: 110.3695,
    radiusMeters: 50,
    checkInTime: '07:00',
    checkOutTime: '15:00',
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onConfigChanged(AttendanceConfig newConfig) {
    setState(() {
      _config = newConfig;
    });
    // TODO: Save to database
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
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Presensi Guru',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textGreyHint,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_2_rounded, size: 18),
                      SizedBox(width: 6),
                      Text('Pengaturan'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.monitor_heart_outlined, size: 18),
                      SizedBox(width: 6),
                      Text('Pemantauan'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          QrSetupTab(
            config: _config,
            onConfigChanged: _onConfigChanged,
          ),
          const MonitoringTab(),
        ],
      ),
    );
  }
}
