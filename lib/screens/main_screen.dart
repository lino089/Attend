import 'package:attend/screens/profile_screen.dart';
import 'package:attend/screens/schedule_screen.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const ScheduleScreen(), 
    const ProfileScreen(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded, size: 30), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded, size: 30), label: 'Jadwal'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded, size: 30), label: 'Profil'),
        ],
      ),
    );
  }
}