import 'package:flutter/material.dart';
import 'models/attendance_history_model.dart';
import 'models/attendance_summary_model.dart';
import 'widgets/attendance_summary_card.dart';
import 'widgets/attendance_history_card.dart';

class TeacherAttendanceHistoryScreen extends StatefulWidget {
  const TeacherAttendanceHistoryScreen({super.key});

  @override
  State<TeacherAttendanceHistoryScreen> createState() =>
      _TeacherAttendanceHistoryScreenState();
}

class _TeacherAttendanceHistoryScreenState
    extends State<TeacherAttendanceHistoryScreen> {
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  String _selectedClass = 'Semua Kelas';
  String _selectedMonth = 'Oktober 2023';

  // TODO: Replace with API call to fetch attendance summary
  final AttendanceSummaryModel _summary = AttendanceSummaryModel(
    totalClassesTaught: 12,
    averageAttendance: 95.0,
  );

  // TODO: Replace with API call to fetch attendance history
  final List<AttendanceHistoryModel> _historyList = [
    AttendanceHistoryModel(
      id: '1',
      subjectName: 'Pemrograman Web',
      className: 'XI RPL 2',
      date: DateTime(2023, 10, 14),
      startTime: '09:30',
      endTime: '12:00',
      presentCount: 30,
      totalStudents: 32,
    ),
    AttendanceHistoryModel(
      id: '2',
      subjectName: 'Basis Data',
      className: 'XI RPL 1',
      date: DateTime(2023, 10, 16),
      startTime: '13:00',
      endTime: '15:30',
      presentCount: 31,
      totalStudents: 32,
    ),
    AttendanceHistoryModel(
      id: '3',
      subjectName: 'Pemrograman Berorientasi Objek',
      className: 'XII RPL 3',
      date: DateTime(2023, 10, 18),
      startTime: '07:30',
      endTime: '10:00',
      presentCount: 28,
      totalStudents: 32,
    ),
    AttendanceHistoryModel(
      id: '4',
      subjectName: 'Sistem Operasi',
      className: 'XI RPL 2',
      date: DateTime(2023, 10, 20),
      startTime: '10:15',
      endTime: '12:45',
      presentCount: 32,
      totalStudents: 32,
    ),
    AttendanceHistoryModel(
      id: '5',
      subjectName: 'Jaringan Komputer',
      className: 'XII RPL 1',
      date: DateTime(2023, 10, 23),
      startTime: '08:00',
      endTime: '10:30',
      presentCount: 29,
      totalStudents: 32,
    ),
  ];

  List<AttendanceHistoryModel> get _filteredHistory {
    // TODO: Implement actual filtering logic
    return _historyList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat Presensi',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: textDark),
            onPressed: () {
              // TODO: Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur pencarian akan segera hadir'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Row(
              children: [
                // Class Filter
                Expanded(
                  child: _buildFilterDropdown(
                    value: _selectedClass,
                    items: [
                      'Semua Kelas',
                      'XI RPL 1',
                      'XI RPL 2',
                      'XII RPL 1',
                      'XII RPL 3',
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedClass = value!;
                      });
                      // TODO: Implement filter by class
                    },
                  ),
                ),
                const SizedBox(width: 16),
                
                // Month Filter
                Expanded(
                  child: _buildFilterDropdown(
                    value: _selectedMonth,
                    items: [
                      'September 2023',
                      'Oktober 2023',
                      'November 2023',
                      'Desember 2023',
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedMonth = value!;
                      });
                      // TODO: Implement filter by month
                    },
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _filteredHistory.isEmpty
                ? _buildEmptyState()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Summary Card
                        AttendanceSummaryCard(summary: _summary),
                        const SizedBox(height: 24),

                        // History List
                        ..._filteredHistory.map((history) {
                          return AttendanceHistoryCard(
                            history: history,
                            onTap: () {
                              // TODO: Navigate to attendance detail screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Detail presensi: ${history.subjectName}',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: textGrey, size: 20),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Riwayat Presensi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Riwayat presensi akan muncul di sini',
            style: TextStyle(
              fontSize: 14,
              color: textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
