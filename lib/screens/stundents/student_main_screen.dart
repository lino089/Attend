import 'package:attend/screens/stundents/student_dashboard_screen.dart';
import 'package:flutter/material.dart';

class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreen();
}

class _StudentMainScreen extends State<StudentMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const StudentDashboardScreen(),
    const Center(child: Text('Halaman Jadwal Siswa')),
    const Center(child: Text('Halaman Riwayat Ujian')),
    const Center(child: Text('Halaman Profil Siswa')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f8fa),
      body: _pages[_selectedIndex],
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
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xff4a65e5),
            unselectedItemColor: const Color(0xff9ca3af),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon:  _buildNavIcon(Icons.home_rounded, 0),
                label: 'BERANDA'
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.calendar_today_rounded, 1),
                label: 'JADWAL'
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.history_rounded, 2),
                label: 'RIWAYAT'
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.person_outline_rounded, 3),
                label: 'PROFIL'
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    bool isActive = _selectedIndex == index;
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 4, top: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xffedf1ff) : Colors.transparent,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Icon(icon, color: isActive ? const Color(0xff4a65e5): const Color(0xff9ca3af)),
    );
  }
}
