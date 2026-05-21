import 'package:flutter/material.dart';
import 'package:attend/core/theme/app_colors.dart';
import 'package:attend/features/admin/presentation/screens/manageSchedule/rolling_teacher_schedule_detail_screen.dart';

class TeacherScheduleDummy {
  final String name;
  final String nip;
  final String totalHours;
  
  TeacherScheduleDummy({
    required this.name,
    required this.nip,
    required this.totalHours,
  });
}

class RollingTeacherScheduleListScreen extends StatefulWidget {
  final List<String> patternNames;

  const RollingTeacherScheduleListScreen({
    super.key,
    required this.patternNames,
  });

  @override
  State<RollingTeacherScheduleListScreen> createState() =>
      _RollingTeacherScheduleListScreenState();
}

class _RollingTeacherScheduleListScreenState
    extends State<RollingTeacherScheduleListScreen> {
  late String _selectedPattern;
  final TextEditingController _searchController = TextEditingController();

  final List<TeacherScheduleDummy> teachers = [
    TeacherScheduleDummy(
        name: "Drs. Bambang Sudjatmiko",
        nip: "198203102009031002",
        totalHours: "24"),
    TeacherScheduleDummy(
        name: "Siti Aminah, M.Pd.",
        nip: "198512122010042001",
        totalHours: "18"),
    TeacherScheduleDummy(
        name: "Andi Wijaya, S.Kom.",
        nip: "199001052015031005",
        totalHours: "32"),
    TeacherScheduleDummy(
        name: "Rina Kartika, S.Pd.",
        nip: "197805202005012010",
        totalHours: "20"),
  ];

  @override
  void initState() {
    super.initState();
    _selectedPattern = widget.patternNames.isNotEmpty
        ? widget.patternNames[0]
        : 'Pola 1';
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
          'Kelola Jadwal Guru',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: AppColors.textGreyLabel),
            onPressed: () {
              // TODO: Open settings/config bottom sheet again
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari nama guru...',
                      hintStyle: const TextStyle(
                        color: AppColors.textGreyHint,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textGreyHint,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Pattern Toggle Tabs
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: widget.patternNames.length <= 3
                      ? Row(
                          children: widget.patternNames.map((pattern) {
                            final isSelected = pattern == _selectedPattern;
                            return Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedPattern = pattern;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.05),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    pattern,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textGreyLabel,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.patternNames.map((pattern) {
                              final isSelected = pattern == _selectedPattern;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedPattern = pattern;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.05),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    pattern,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textGreyLabel,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ),

                const SizedBox(height: 16),

                // Status Chips
                Row(
                  children: [
                    _StatusChip(
                        label: 'Jadwal Lengkap: 18',
                        dotColor: const Color(0xFF10B981)),
                    const SizedBox(width: 12),
                    _StatusChip(
                        label: 'Belum Lengkap: 4',
                        dotColor: const Color(0xFFF59E0B)),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                final teacher = teachers[index];
                return _TeacherCard(
                  teacher: teacher,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RollingTeacherScheduleDetailScreen(
                          teacherName: teacher.name,
                          teacherNip: teacher.nip,
                          patternName: _selectedPattern,
                        ),
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

class _StatusChip extends StatelessWidget {
  final String label;
  final Color dotColor;

  const _StatusChip({required this.label, required this.dotColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGreyLabel,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeacherCard extends StatelessWidget {
  final TeacherScheduleDummy teacher;
  final VoidCallback onTap;

  const _TeacherCard({required this.teacher, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
            const CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.bgLightGrey,
              child: Icon(Icons.person, color: Colors.grey, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher.name,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIP: ${teacher.nip}',
                    style: const TextStyle(
                      color: AppColors.textGreyLabel,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Total: ${teacher.totalHours} Jam/Minggu',
                      style: const TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
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
