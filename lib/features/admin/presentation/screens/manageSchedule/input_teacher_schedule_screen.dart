import 'package:flutter/material.dart';
import 'package:attend/core/theme/app_colors.dart';

class InputTeacherScheduleScreen extends StatefulWidget {
  final String teacherName;
  final String teacherNip;
  
  const InputTeacherScheduleScreen({
    super.key, 
    required this.teacherName, 
    required this.teacherNip,
  });

  @override
  State<InputTeacherScheduleScreen> createState() => _InputTeacherScheduleScreenState();
}

class _InputTeacherScheduleScreenState extends State<InputTeacherScheduleScreen> {
  final List<String> _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
  String _selectedDay = 'Senin';

  List<Map<String, String>> _schedules = [
    {
      'time': '07:30\n09:00',
      'subject': 'Fisika',
      'class': 'XI RPL 2',
    },
    {
      'time': '09:15\n10:45',
      'subject': 'Matematika Peminatan',
      'class': 'XII TKJ 1',
    },
    {
      'time': '11:00\n12:30',
      'subject': 'Fisika Terapan',
      'class': 'XI RPL 1',
    },
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
          'Input Jadwal Guru',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.bgLightGrey,
              child: const Icon(Icons.person, color: Colors.grey, size: 20),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E6FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.account_circle_outlined, color: AppColors.primaryBlue, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.teacherName,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIP: ${widget.teacherNip}',
                        style: const TextStyle(
                          color: AppColors.textGreyLabel,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Day Selector
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _days.length,
              itemBuilder: (context, index) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryBlue : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(16),
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
          
          const SizedBox(height: 16),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: const [
                Icon(Icons.schedule, size: 16, color: AppColors.textGreyLabel),
                SizedBox(width: 8),
                Text(
                  'Jadwal Hari Ini',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _schedules.length,
              itemBuilder: (context, index) {
                final schedule = _schedules[index];
                return _ScheduleCard(
                  time: schedule['time']!,
                  subject: schedule['subject']!,
                  className: schedule['class']!,
                  onEdit: () => _showScheduleBottomSheet(existingSchedule: schedule, index: index),
                  onDelete: () => _showDeleteDialog(schedule, index),
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

  void _showScheduleBottomSheet({Map<String, String>? existingSchedule, int? index}) {
    String selectedSubject = existingSchedule?['subject'] ?? 'Pilih Mapel...';
    String selectedClass = existingSchedule?['class'] ?? 'Pilih Kelas...';
    
    String startTime = '07:30';
    String endTime = '09:00';
    
    if (existingSchedule != null) {
      final parts = existingSchedule['time']!.split('\n');
      if (parts.length == 2) {
        startTime = parts[0];
        endTime = parts[1];
      }
    }

    final subjects = ['Pilih Mapel...', 'Fisika', 'Matematika Peminatan', 'Fisika Terapan', 'Kimia', 'Biologi'];
    final classes = ['Pilih Kelas...', 'XI RPL 1', 'XI RPL 2', 'XII TKJ 1', 'XII MM 1'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                    const SizedBox(height: 24),
                    
                    const Text('MATA PELAJARAN', style: TextStyle(color: AppColors.textGreyLabel, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.bgLightGrey, borderRadius: BorderRadius.circular(12)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: subjects.contains(selectedSubject) ? selectedSubject : 'Pilih Mapel...',
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGreyHint),
                          items: subjects.map((String value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value, style: TextStyle(fontSize: 14, color: value == 'Pilih Mapel...' ? AppColors.textGreyHint : AppColors.textDark)));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setModalState(() => selectedSubject = val);
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    const Text('KELAS', style: TextStyle(color: AppColors.textGreyLabel, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.bgLightGrey, borderRadius: BorderRadius.circular(12)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: classes.contains(selectedClass) ? selectedClass : 'Pilih Kelas...',
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGreyHint),
                          items: classes.map((String value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value, style: TextStyle(fontSize: 14, color: value == 'Pilih Kelas...' ? AppColors.textGreyHint : AppColors.textDark)));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setModalState(() => selectedClass = val);
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    const Text('WAKTU MENGAJAR', style: TextStyle(color: AppColors.textGreyLabel, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: int.tryParse(startTime.split(':')[0]) ?? 7,
                                  minute: int.tryParse(startTime.split(':')[1]) ?? 30,
                                ),
                              );
                              if (time != null) {
                                setModalState(() {
                                  startTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2E6FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.schedule, color: AppColors.primaryBlue, size: 16),
                                  const SizedBox(width: 8),
                                  Text(startTime, style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Icon(Icons.arrow_forward, color: Colors.grey, size: 16),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: int.tryParse(endTime.split(':')[0]) ?? 9,
                                  minute: int.tryParse(endTime.split(':')[1]) ?? 0,
                                ),
                              );
                              if (time != null) {
                                setModalState(() {
                                  endTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2E6FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.schedule, color: AppColors.primaryBlue, size: 16),
                                  const SizedBox(width: 8),
                                  Text(endTime, style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedSubject != 'Pilih Mapel...' && selectedClass != 'Pilih Kelas...') {
                            final newSchedule = {
                              'time': '$startTime\n$endTime',
                              'subject': selectedSubject,
                              'class': selectedClass,
                            };
                            
                            setState(() {
                              if (existingSchedule != null && index != null) {
                                _schedules[index] = newSchedule;
                              } else {
                                _schedules.add(newSchedule);
                              }
                            });
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text(existingSchedule == null ? 'Simpan Jadwal' : 'Simpan Perubahan', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
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

  void _showDeleteDialog(Map<String, String> schedule, int index) {
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
                      TextSpan(text: schedule['subject'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      const TextSpan(text: ' kelas '),
                      TextSpan(text: schedule['class'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
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
}

class _ScheduleCard extends StatelessWidget {
  final String time;
  final String subject;
  final String className;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ScheduleCard({
    required this.time,
    required this.subject,
    required this.className,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time
          Text(
            time,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1.5,
            ),
          ),
          
          const SizedBox(width: 24),
          
          // Divider
          Container(
            width: 2,
            height: 40,
            color: const Color(0xFFF3F4F6),
          ),
          
          const SizedBox(width: 24),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    className,
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
          
          // Actions
          IconButton(
            onPressed: () {
              if (onEdit != null) onEdit!();
            },
            icon: const Icon(Icons.edit_outlined, color: AppColors.textGreyHint, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              if (onDelete != null) onDelete!();
            },
            icon: const Icon(Icons.delete_outline, color: Color(0xFFFCA5A5), size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
