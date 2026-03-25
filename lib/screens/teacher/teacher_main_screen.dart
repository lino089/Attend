import 'package:attend/screens/teacher/teacher_dashboard_screen.dart';
import 'package:attend/screens/teacher/teacher_schedule_screen.dart';
import 'package:attend/screens/teacher/teacher_settings_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const ScheduleScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF4A65E5),
            unselectedItemColor: const Color(0xFF9CA3AF),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.grid_view_rounded, 0),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.calendar_today, 1),
                label: "Jadwal"
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.settings_outlined, 2),
                label: 'Pengaturan'
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    bool isActivate = selectedIndex == index;
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 4, top: 5),
      decoration:  BoxDecoration(
        color:  isActivate ? const Color(0xFFED1FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Icon(icon, size: 22, color: isActivate ? const Color(0xFF4A65E5) : const Color(0xFF9CA3AF)),
    );
  }
}
