import 'package:flutter/material.dart';
import 'package:attend/core/theme/app_colors.dart';

// Using the same ScheduleItem model from fixed_student_schedule_screen.dart conceptually,
// but defined here or imported. Since it's defined in the other file, it's better to 
// create a shared model later. For now, we redefine it here or import it.
// Actually, let's just redefine it here to keep things simple and self-contained for this step.
class RollingScheduleItem {
  final String id;
  final String type; // 'subject' or 'break'
  final String startTime;
  final String endTime;
  final String title;
  final String? subtitle;
  final String? room;

  RollingScheduleItem({
    required this.id,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.title,
    this.subtitle,
    this.room,
  });
}

class RollingStudentScheduleDetailScreen extends StatefulWidget {
  final String className;
  final String patternName;

  const RollingStudentScheduleDetailScreen({
    super.key,
    required this.className,
    required this.patternName,
  });

  @override
  State<RollingStudentScheduleDetailScreen> createState() => _RollingStudentScheduleDetailScreenState();
}

class _RollingStudentScheduleDetailScreenState extends State<RollingStudentScheduleDetailScreen> {
  final List<String> _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
  String _selectedDay = 'Senin';

  List<RollingScheduleItem> _schedules = [
    RollingScheduleItem(
      id: '1',
      type: 'subject',
      startTime: '07:00',
      endTime: '08:30',
      title: 'Pemrograman Web',
      subtitle: 'Bp. Hendra Wijaya',
      room: 'Lab RPL 1',
    ),
    RollingScheduleItem(
      id: '2',
      type: 'subject',
      startTime: '08:30',
      endTime: '10:00',
      title: 'Basis Data',
      subtitle: 'Ibu Maria Ulfa',
      room: 'Lab RPL 2',
    ),
    RollingScheduleItem(
      id: '3',
      type: 'break',
      startTime: '10:00',
      endTime: '10:15',
      title: 'Istirahat - 15 Menit',
    ),
    RollingScheduleItem(
      id: '4',
      type: 'subject',
      startTime: '10:15',
      endTime: '11:45',
      title: 'PKK',
      subtitle: 'Bp. Ahmad Subagjo',
    ),
  ];

  int _calculateDuration(String start, String end) {
    try {
      final startParts = start.split(':');
      final endParts = end.split(':');
      final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
      final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
      int diff = endMinutes - startMinutes;
      if (diff < 0) diff += 24 * 60;
      return diff;
    } catch (e) {
      return 0;
    }
  }

  void _showDeleteDialog(RollingScheduleItem schedule, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(color: Color(0xFFFDE8E8), shape: BoxShape.circle),
                  child: const Icon(Icons.delete_outline, color: Color(0xFFE02424), size: 32),
                ),
                const SizedBox(height: 24),
                const Text('Hapus Jadwal?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 12),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: AppColors.textGreyLabel, height: 1.5),
                    children: [
                      const TextSpan(text: 'Apakah Anda yakin ingin menghapus jadwal '),
                      TextSpan(text: schedule.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      const TextSpan(text: '?'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFFF3F4F6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Batal', style: TextStyle(color: AppColors.textGreyLabel, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _schedules.removeAt(index);
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFFE02424),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showScheduleBottomSheet({RollingScheduleItem? existingSchedule, int? index}) {
    bool isSubjectTab = existingSchedule == null || existingSchedule.type == 'subject';
    
    // Mata Pelajaran state
    String selectedSubject = existingSchedule?.type == 'subject' ? existingSchedule!.title : 'Cari mapel...';
    String selectedTeacher = existingSchedule?.type == 'subject' && existingSchedule!.subtitle != null ? existingSchedule!.subtitle! : 'Pilih guru...';
    String room = existingSchedule?.room ?? '';
    
    // Istirahat state
    String selectedBreakType = existingSchedule?.type == 'break' ? existingSchedule!.title : 'Sholat & Makan Siang';

    // Shared state
    String startTime = existingSchedule?.startTime ?? '07:00';
    String endTime = existingSchedule?.endTime ?? '08:30';

    final subjects = ['Cari mapel...', 'Pemrograman Web', 'Basis Data', 'PKK', 'Matematika'];
    final teachers = ['Pilih guru...', 'Bp. Hendra Wijaya', 'Ibu Maria Ulfa', 'Bp. Ahmad Subagjo', 'Ibu Susi Simanjuntak'];
    final breakTypes = ['Sholat & Makan Siang', 'Istirahat Ke-1', 'Istirahat Ke-2'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final duration = _calculateDuration(startTime, endTime);

            return Container(
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 12, left: 24, right: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(existingSchedule == null ? 'Tambah Jadwal' : 'Edit Jadwal', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Toggle Tabs
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setModalState(() => isSubjectTab = true),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSubjectTab ? AppColors.primaryBlue : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Mata Pelajaran',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSubjectTab ? Colors.white : AppColors.textGreyLabel,
                                    fontWeight: isSubjectTab ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => setModalState(() => isSubjectTab = false),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !isSubjectTab ? AppColors.primaryBlue : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Istirahat',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: !isSubjectTab ? Colors.white : AppColors.textGreyLabel,
                                    fontWeight: !isSubjectTab ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    if (isSubjectTab) ...[
                      const Text('MATA PELAJARAN', style: TextStyle(color: AppColors.textGreyLabel, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.bgLightGrey, borderRadius: BorderRadius.circular(12)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: subjects.contains(selectedSubject) ? selectedSubject : 'Cari mapel...',
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGreyHint),
                            items: subjects.map((String value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value, style: TextStyle(fontSize: 14, color: value == 'Cari mapel...' ? AppColors.textGreyHint : AppColors.textDark)));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedSubject = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('GURU PENGAJAR', style: TextStyle(color: AppColors.textGreyLabel, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.bgLightGrey, borderRadius: BorderRadius.circular(12)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: teachers.contains(selectedTeacher) ? selectedTeacher : 'Pilih guru...',
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGreyHint),
                            items: teachers.map((String value) {
                              return DropdownMenuItem<String>(value: value, child: Row(
                                children: [
                                  if (value == 'Pilih guru...') const Icon(Icons.person_search_outlined, color: AppColors.textGreyHint, size: 20) else const Icon(Icons.person_outline, color: AppColors.textGreyLabel, size: 20),
                                  const SizedBox(width: 8),
                                  Text(value, style: TextStyle(fontSize: 14, color: value == 'Pilih guru...' ? AppColors.textGreyHint : AppColors.textDark)),
                                ],
                              ));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedTeacher = val);
                            },
                          ),
                        ),
                      ),
                    ] else ...[
                      const Text('KETERANGAN ISTIRAHAT', style: TextStyle(color: AppColors.textGreyLabel, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.bgLightGrey, borderRadius: BorderRadius.circular(12)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: breakTypes.contains(selectedBreakType) ? selectedBreakType : breakTypes[0],
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGreyHint),
                            items: breakTypes.map((String value) {
                              return DropdownMenuItem<String>(value: value, child: Row(
                                children: [
                                  const Icon(Icons.coffee_outlined, color: AppColors.primaryBlue, size: 20),
                                  const SizedBox(width: 8),
                                  Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.bold)),
                                ],
                              ));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedBreakType = val);
                            },
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(isSubjectTab ? 'JAM MULAI' : 'DURASI WAKTU\nJAM MULAI', style: const TextStyle(color: AppColors.textGreyLabel, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () async {
                                  final TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: int.tryParse(startTime.split(':')[0]) ?? 7, minute: int.tryParse(startTime.split(':')[1]) ?? 0),
                                  );
                                  if (time != null) setModalState(() => startTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.schedule, color: AppColors.textGreyLabel, size: 16),
                                      const SizedBox(width: 8),
                                      Text(startTime, style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(isSubjectTab ? 'JAM SELESAI' : '\nJAM SELESAI', style: const TextStyle(color: AppColors.textGreyLabel, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () async {
                                  final TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: int.tryParse(endTime.split(':')[0]) ?? 8, minute: int.tryParse(endTime.split(':')[1]) ?? 30),
                                  );
                                  if (time != null) setModalState(() => endTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.schedule, color: AppColors.textGreyLabel, size: 16),
                                      const SizedBox(width: 8),
                                      Text(endTime, style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    if (!isSubjectTab) ...[
                      const SizedBox(height: 12),
                      Text('Durasi: $duration Menit', style: const TextStyle(color: AppColors.primaryBlue, fontSize: 12, fontWeight: FontWeight.w500)),
                    ],

                    if (isSubjectTab) ...[
                      const SizedBox(height: 16),
                      const Text('RUANGAN (OPSIONAL)', style: TextStyle(color: AppColors.textGreyLabel, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(color: AppColors.bgLightGrey, borderRadius: BorderRadius.circular(12)),
                        child: TextFormField(
                          initialValue: room,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.location_on_outlined, color: AppColors.primaryBlue, size: 20),
                            hintText: 'e.g., Lab RPL 1',
                            hintStyle: TextStyle(color: AppColors.textGreyHint, fontSize: 14),
                            border: InputBorder.none,
                          ),
                          onChanged: (val) => room = val,
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 32),
                    
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(16)),
                            child: const Icon(Icons.close, color: AppColors.textDark),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (isSubjectTab && (selectedSubject == 'Cari mapel...' || selectedTeacher == 'Pilih guru...')) return;
                              
                              final newSchedule = RollingScheduleItem(
                                id: existingSchedule?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                                type: isSubjectTab ? 'subject' : 'break',
                                startTime: startTime,
                                endTime: endTime,
                                title: isSubjectTab ? selectedSubject : selectedBreakType,
                                subtitle: isSubjectTab ? selectedTeacher : null,
                                room: isSubjectTab ? room : null,
                              );
                              
                              setState(() {
                                if (existingSchedule != null && index != null) {
                                  _schedules[index] = newSchedule;
                                } else {
                                  _schedules.add(newSchedule);
                                  // Sort schedules by time
                                  _schedules.sort((a, b) => a.startTime.compareTo(b.startTime));
                                }
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add, color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Text(existingSchedule == null ? 'Simpan Jadwal' : 'Simpan Perubahan', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
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
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Jadwal Siswa',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header Card with Class Name and Pattern Badge
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E6FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.school_outlined,
                        color: AppColors.primaryBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.className,
                            style: const TextStyle(
                              color: AppColors.textDark,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Jadwal Bergulir',
                            style: TextStyle(
                              color: AppColors.textGreyLabel,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Pattern Name Badge
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.autorenew,
                        color: AppColors.primaryBlue,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.patternName,
                        style: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Day Selector
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  _days.length,
                  (index) {
                    final day = _days[index];
                    final isSelected = day == _selectedDay;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDay = day;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryBlue : const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          day,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textGreyLabel,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 80),
              itemCount: _schedules.length,
              itemBuilder: (context, index) {
                final schedule = _schedules[index];
                final isLast = index == _schedules.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Timeline
                      SizedBox(
                        width: 32,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 24),
                              width: 14, height: 14,
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2), width: 3),
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Card content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: schedule.type == 'subject'
                              ? Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${schedule.startTime} - ${schedule.endTime}', style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.0)),
                                            const SizedBox(height: 8),
                                            Text(schedule.title, style: const TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.w900)),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                const Icon(Icons.person_outline, size: 14, color: AppColors.textGreyLabel),
                                                const SizedBox(width: 4),
                                                Text(schedule.subtitle ?? '', style: const TextStyle(color: AppColors.textGreyLabel, fontSize: 12)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => _showScheduleBottomSheet(existingSchedule: schedule, index: index),
                                        icon: const Icon(Icons.edit_outlined, color: AppColors.textGreyHint, size: 20),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 16),
                                      IconButton(
                                        onPressed: () => _showDeleteDialog(schedule, index),
                                        icon: const Icon(Icons.delete_outline, color: AppColors.textGreyHint, size: 20),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: () => _showScheduleBottomSheet(existingSchedule: schedule, index: index),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        schedule.title.toUpperCase(),
                                        style: const TextStyle(
                                          color: AppColors.textGreyLabel,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showScheduleBottomSheet(),
        backgroundColor: AppColors.primaryBlue,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
