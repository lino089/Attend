import 'package:flutter/material.dart';
import 'package:attend/core/theme/app_colors.dart';
import 'package:attend/features/admin/presentation/screens/manageSchedule/fixed_student_schedule_screen.dart';
import 'package:attend/core/services/schedule_conflict_detector.dart';

class StudentClassDummy {
  final String className;
  final String homeroomTeacher;
  final bool hasAlert;

  StudentClassDummy({
    required this.className,
    required this.homeroomTeacher,
    this.hasAlert = false,
  });
}

class StudentScheduleListScreen extends StatefulWidget {
  const StudentScheduleListScreen({super.key});

  @override
  State<StudentScheduleListScreen> createState() => _StudentScheduleListScreenState();
}

class _StudentScheduleListScreenState extends State<StudentScheduleListScreen> {
  final List<StudentClassDummy> classes = [
    StudentClassDummy(className: "X RPL 1", homeroomTeacher: "Ibu Susi Simanjuntak"),
    StudentClassDummy(className: "X RPL 2", homeroomTeacher: "Bp. Ahmad Subagjo"),
    StudentClassDummy(className: "XI DKV 3", homeroomTeacher: "Ibu Retno Wulandari"),
    StudentClassDummy(className: "XII TKJ 1", homeroomTeacher: "Bp. Hendra Wijaya", hasAlert: true),
    StudentClassDummy(className: "XII RPL 1", homeroomTeacher: "Ibu Maria Ulfa"),
    StudentClassDummy(className: "X TKJ 2", homeroomTeacher: "Bp. Syarifuddin"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kelola Jadwal Siswa',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 10.0),
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(16)),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari kelas...',
                  hintStyle: const TextStyle(color: AppColors.textGreyHint, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textGreyHint),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'DAFTAR KELAS (12)',
                  style: TextStyle(
                    color: AppColors.textGreyLabel,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: const [
                      Icon(Icons.filter_list, size: 16, color: AppColors.primaryBlue),
                      SizedBox(width: 4),
                      Text('Filter', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: classes.length,
              itemBuilder: (context, index) {
                final studentClass = classes[index];
                final hasConflict = ScheduleConflictDetector().hasConflictForClass(studentClass.className);
                return _ClassCard(
                  studentClass: studentClass,
                  hasConflict: hasConflict,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FixedStudentScheduleScreen(className: studentClass.className),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  final StudentClassDummy studentClass;
  final bool hasConflict;
  final VoidCallback onTap;

  const _ClassCard({required this.studentClass, required this.hasConflict, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        studentClass.className,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (hasConflict) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Wali Kelas:\n${studentClass.homeroomTeacher}',
                    style: const TextStyle(
                      color: AppColors.textGreyLabel,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
