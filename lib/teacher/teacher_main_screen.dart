import 'package:attend/teacher/teacher_dashboard_screen.dart';
import 'package:attend/teacher/teacher_schedule_screen.dart';
import 'package:attend/teacher/teacher_setting_screen.dart';
import 'package:flutter/material.dart';

class TeacherMainScreen extends StatefulWidget {
  const TeacherMainScreen({super.key});

  @override
  State<TeacherMainScreen> createState() => _TeacherMainScreen();
}

class _TeacherMainScreen extends State<TeacherMainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const TeacherDashboardScreen(),
    const TeacherScheduleScreen(),
    const TeacherSettingScreen(),
  ];
  static const Color primariBlue = Color(0xff335cfa);
  static const Color textGreyHint = Color(0xff94a3b8);

  void onTappedItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.grid_view_rounded,
                  label: 'DASHBOARD',
                  isSelect: selectedIndex == 0,
                  onTap: () => onTappedItem(0),
                ),
                _buildNavItem(
                  icon: Icons.calendar_month,
                  label: 'SCHEDULE',
                  isSelect: selectedIndex == 1,
                  onTap: () => onTappedItem(1),
                ),
                _buildNavItem(
                  icon: Icons.settings_outlined,
                  label: 'SETTINGS',
                  isSelect: selectedIndex == 2,
                  onTap: () => onTappedItem(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelect,
    required VoidCallback onTap,
  }) {
    final color = isSelect ? primariBlue : textGreyHint;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(microseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelect ? primariBlue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
