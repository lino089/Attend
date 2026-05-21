import 'package:flutter/material.dart';
import 'package:attend/features/teacher/presentation/screens/attendance/models/student_model.dart';
import 'package:attend/features/teacher/presentation/screens/attendance/models/attendance_data_model.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  final String classId;
  final String className;
  final String subject;

  const TeacherAttendanceScreen({
    super.key,
    required this.classId,
    required this.className,
    required this.subject,
  });

  @override
  State<TeacherAttendanceScreen> createState() => _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  bool _isLoading = true;
  
  // Lists untuk manage students
  final List<Student> _activeStudents = []; // Siswa yang masih tampil
  final List<Student> _attendedStudents = []; // Siswa yang sudah hadir (hidden)
  
  int _totalStudents = 0;
  double _progressPercentage = 0.0;
  int _processedCount = 0;

  // Counts untuk summary
  int _hadirCount = 0;
  int _sakitCount = 0;
  int _izinCount = 0;
  int _alpaCount = 0;

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color greenStatus = Color(0xFF10B981);
  static const Color orangeStatus = Color(0xFFF59E0B);
  static const Color blueStatus = Color(0xFF3B82F6);
  static const Color redStatus = Color(0xFFEF4444);
  static const Color greyInactive = Color(0xFFE5E7EB);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    // TODO: Fetch from database
    // Simulasi data untuk demo
    await Future.delayed(const Duration(milliseconds: 500));
    
    // final students = await DatabaseService.getStudentsByClass(widget.classId);
    
    // Demo data
    final demoStudents = [
      Student(
        id: '1',
        name: 'ADITYA PRATAMA',
        nis: '17792',
        absenceNumber: 1,
        photoUrl: null,
      ),
      Student(
        id: '2',
        name: 'AHMAD ZHARIFUDIN',
        nis: '17793',
        absenceNumber: 2,
        photoUrl: null,
      ),
      Student(
        id: '3',
        name: 'ANANDA RIZKY',
        nis: '17794',
        absenceNumber: 5,
        photoUrl: null,
      ),
      Student(
        id: '4',
        name: 'BUDI SANTOSO',
        nis: '17795',
        absenceNumber: 8,
        photoUrl: null,
      ),
      Student(
        id: '5',
        name: 'CITRA DEWI',
        nis: '17796',
        absenceNumber: 10,
        photoUrl: null,
      ),
      Student(
        id: '6',
        name: 'DIMAS PRASETYO',
        nis: '17797',
        absenceNumber: 15,
        photoUrl: null,
      ),
    ];

    if (mounted) {
      setState(() {
        _activeStudents.addAll(demoStudents);
        _totalStudents = demoStudents.length;
        _isLoading = false;
      });
    }
  }

  void _handleStatusTap(Student student, String status) {
    setState(() {
      if (status == 'H') {
        // Hadir: Pindahkan ke attended list (card hilang)
        student.status = 'H';
        _attendedStudents.add(student);
        _activeStudents.remove(student);
      } else {
        // S, I, A: Update status, tetap di list
        student.status = status;
      }
      _updateProgress();
    });
  }

  void _updateProgress() {
    // Hitung progress
    int processed = _attendedStudents.length + 
                    _activeStudents.where((s) => s.status != 'none').length;
    
    double percentage = _totalStudents > 0 
        ? (processed / _totalStudents) * 100 
        : 0.0;

    // Hitung counts
    int hadir = _attendedStudents.length;
    int sakit = _activeStudents.where((s) => s.status == 'S').length;
    int izin = _activeStudents.where((s) => s.status == 'I').length;
    int alpa = _activeStudents.where((s) => s.status == 'A').length;

    setState(() {
      _progressPercentage = percentage;
      _processedCount = processed;
      _hadirCount = hadir;
      _sakitCount = sakit;
      _izinCount = izin;
      _alpaCount = alpa;
    });
  }

  List<StudentAttendance> _getDataToSend() {
    // Hanya kirim siswa dengan status S, I, A
    return _activeStudents
        .where((s) => s.status == 'S' || s.status == 'I' || s.status == 'A')
        .map((s) => StudentAttendance(
              studentId: s.id,
              status: s.status,
            ))
        .toList();
  }

  void _showRestoreDialog() {
    if (_attendedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada siswa yang perlu dikembalikan'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Track selected students untuk restore - HARUS di luar builder
    final Set<String> selectedStudentIds = {};

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Kembalikan Siswa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      Text(
                        '${_attendedStudents.length} siswa',
                        style: const TextStyle(
                          fontSize: 14,
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pilih siswa yang ingin dikembalikan ke daftar',
                    style: TextStyle(
                      fontSize: 14,
                      color: textGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _attendedStudents.length,
                      itemBuilder: (context, index) {
                        final student = _attendedStudents[index];
                        final isSelected = selectedStudentIds.contains(student.id);
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? primaryBlue.withOpacity(0.05)
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(color: primaryBlue, width: 2)
                                : null,
                          ),
                          child: CheckboxListTile(
                            value: isSelected,
                            onChanged: (bool? value) {
                              setModalState(() {
                                if (value == true) {
                                  selectedStudentIds.add(student.id);
                                } else {
                                  selectedStudentIds.remove(student.id);
                                }
                              });
                            },
                            activeColor: primaryBlue,
                            secondary: CircleAvatar(
                              backgroundColor: primaryBlue.withOpacity(0.1),
                              child: Text(
                                student.name[0],
                                style: const TextStyle(
                                  color: primaryBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              student.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              'NIS: ${student.nis} • No. Absen: ${student.absenceNumber}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: primaryBlue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Tutup',
                            style: TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedStudentIds.isEmpty
                              ? null
                              : () {
                                  // Restore selected students
                                  final studentsToRestore = _attendedStudents
                                      .where((s) => selectedStudentIds.contains(s.id))
                                      .toList();
                                  
                                  for (var student in studentsToRestore) {
                                    _restoreStudent(student);
                                  }
                                  
                                  // Clear selection
                                  selectedStudentIds.clear();
                                  
                                  // Close dialog if no more students
                                  if (_attendedStudents.isEmpty) {
                                    Navigator.pop(context);
                                  } else {
                                    // Update modal state
                                    setModalState(() {});
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            disabledBackgroundColor: greyInactive,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            selectedStudentIds.isEmpty
                                ? 'Pilih Siswa'
                                : 'Kembalikan (${selectedStudentIds.length})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _restoreStudent(Student student) {
    setState(() {
      student.status = 'none';
      _attendedStudents.remove(student);
      _activeStudents.insert(0, student); // Insert di awal list
      _updateProgress();
    });
  }

  void _showStudentDetailDialog(Student student) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Informasi Siswa',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: textDark),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Avatar with shadow effect
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.2),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: primaryBlue.withOpacity(0.1),
                  backgroundImage: student.photoUrl != null 
                      ? NetworkImage(student.photoUrl!) 
                      : null,
                  child: student.photoUrl == null
                      ? Text(
                          student.name[0],
                          style: const TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 32),
              
              // Info Cards
              _buildInfoCard(
                Icons.person,
                'NAMA LENGKAP',
                student.name,
              ),
              const SizedBox(height: 12),
              
              _buildInfoCard(
                Icons.format_list_numbered,
                'NO. PRESENSI',
                student.absenceNumber.toString().padLeft(2, '0'),
              ),
              const SizedBox(height: 12),
              
              _buildInfoCard(
                Icons.badge,
                'NIS',
                student.nis,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Icon with circular background
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Label and Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: textGrey,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitAttendance() async {
    final dataToSend = _getDataToSend();
    
    if (_processedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Belum ada siswa yang diproses'),
          backgroundColor: redStatus,
        ),
      );
      return;
    }

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Kirim Presensi?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total siswa: $_totalStudents'),
              Text('Hadir: $_hadirCount'),
              Text('Sakit: $_sakitCount'),
              Text('Izin: $_izinCount'),
              Text('Alpa: $_alpaCount'),
              const SizedBox(height: 12),
              Text(
                'Data yang akan dikirim: ${dataToSend.length} siswa (S, I, A)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    // TODO: Send to database
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: primaryBlue),
      ),
    );

    // Simulasi kirim data
    await Future.delayed(const Duration(seconds: 1));

    // final attendanceData = AttendanceData(
    //   classId: widget.classId,
    //   className: widget.className,
    //   subject: widget.subject,
    //   date: DateTime.now(),
    //   absences: dataToSend,
    // );
    // await DatabaseService.submitAttendance(attendanceData);

    if (mounted) {
      Navigator.pop(context); // Close loading
      
      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Presensi berhasil dikirim!'),
          backgroundColor: greenStatus,
        ),
      );

      // Navigate back
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: primaryBlue),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.className,
              style: const TextStyle(
                color: textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.subject,
              style: const TextStyle(
                color: textGrey,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: primaryBlue),
            onPressed: _showRestoreDialog,
            tooltip: 'Kembalikan siswa hadir',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progres Presensi: ${_progressPercentage.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    Text(
                      '$_processedCount/$_totalStudents Siswa',
                      style: const TextStyle(
                        fontSize: 14,
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _progressPercentage / 100,
                    backgroundColor: greyInactive,
                    valueColor: const AlwaysStoppedAnimation<Color>(primaryBlue),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          // Student List
          Expanded(
            child: _activeStudents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 64,
                          color: greenStatus.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Semua siswa sudah hadir!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Klik tombol "Kirim Presensi" untuk mengirim data',
                          style: TextStyle(
                            fontSize: 14,
                            color: textGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _activeStudents.length,
                    itemBuilder: (context, index) {
                      final student = _activeStudents[index];
                      return _buildStudentCard(student);
                    },
                  ),
          ),

          // Bottom Summary and Submit
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Summary Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryButton(
                          '$_hadirCount Hadir',
                          greenStatus,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryButton(
                          '$_sakitCount Sakit',
                          orangeStatus,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryButton(
                          '$_izinCount Izin',
                          blueStatus,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryButton(
                          '$_alpaCount Alpa',
                          redStatus,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _submitAttendance,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Kirim Presensi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' (${_sakitCount + _izinCount + _alpaCount})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.send, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Student student) {
    return GestureDetector(
      onTap: () => _showStudentDetailDialog(student),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
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
            // Absence Number
            Container(
              width: 28,
              alignment: Alignment.center,
              child: Text(
                student.absenceNumber.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: textGrey,
                ),
              ),
            ),
            const SizedBox(width: 10),
            
            // Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: primaryBlue.withOpacity(0.1),
              backgroundImage: student.photoUrl != null 
                  ? NetworkImage(student.photoUrl!) 
                  : null,
              child: student.photoUrl == null
                  ? Text(
                      student.name[0],
                      style: const TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            
            // Student Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'NIS: ${student.nis}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            
            // Status Buttons - Wrap dengan GestureDetector untuk prevent parent tap
            Row(
              children: [
                GestureDetector(
                  onTap: () => _handleStatusTap(student, 'H'),
                  child: _buildStatusButton('H', greyInactive, student),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _handleStatusTap(student, 'S'),
                  child: _buildStatusButton('S', greyInactive, student),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _handleStatusTap(student, 'I'),
                  child: _buildStatusButton('I', greyInactive, student),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _handleStatusTap(student, 'A'),
                  child: _buildStatusButton('A', greyInactive, student),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String label, Color color, Student student) {
    final isSelected = student.status == label;
    final buttonColor = isSelected 
        ? (label == 'H' ? primaryBlue : 
           label == 'S' ? orangeStatus :
           label == 'I' ? blueStatus : redStatus)
        : color;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isSelected ? buttonColor : color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : textGrey,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryButton(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
