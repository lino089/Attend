import 'package:flutter/material.dart';

class StudentModel {
  final String id;
  final String name;
  final String nis;
  final String avatarUrl;

  StudentModel({
    required this.id,
    required this.name,
    required this.nis,
    required this.avatarUrl,
  });
}

final List<StudentModel> dummyStudents = [
  StudentModel(
    id: "S01",
    name: "ADITYA PRATAMA",
    nis: "17792",
    avatarUrl: "https://i.pravatar.cc/150?img=11",
  ),
  StudentModel(
    id: "S02",
    name: "AHMAD ZHIDAN",
    nis: "17793",
    avatarUrl: "https://i.pravatar.cc/150?img=12",
  ),
  StudentModel(
    id: "S03",
    name: "ANANDA RIZKY",
    nis: "17794",
    avatarUrl: "https://i.pravatar.cc/150?img=13",
  ),
  StudentModel(
    id: "S04",
    name: "BUDI SANTOSO",
    nis: "17795",
    avatarUrl: "https://i.pravatar.cc/150?img=14",
  ),
  StudentModel(
    id: "S05",
    name: "CINDY AULIA",
    nis: "17796",
    avatarUrl: "https://i.pravatar.cc/150?img=5",
  ),
  StudentModel(
    id: "S06",
    name: "DIANA PUTRI",
    nis: "17797",
    avatarUrl: "https://i.pravatar.cc/150?img=9",
  ),
];

class AttendanceScreen extends StatefulWidget {
  final String className;
  final String subjectName;
  const AttendanceScreen({
    super.key,
    this.className = 'XI RPL 2',
    this.subjectName = 'Pemrogaman Perankat Bergerak ',
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreen();
}

class _AttendanceScreen extends State<AttendanceScreen> {
  late List<StudentModel> _allStudents;

  late List<StudentModel> _displayedStudent;

  final Map<String, String> _attaendaceRecord = {};

  bool _isSubmiting = false;

  @override
  void initState() {
    super.initState();
    _allStudents = List.from(dummyStudents);
    _displayedStudent = List.from(_allStudents);
  }

  void _markAttendance(StudentModel student, String status) {
    setState(() {
      _attaendaceRecord[student.id] = status;

      if (status == 'H') {
        _displayedStudent.removeWhere((s) => s.id == student.id);
      }
    });
  }

  Future<void> _submitAttandance() async {
    setState(() => _isSubmiting = true);

    final List<Map<String, String>> absenDataToSubmit = [];

    _attaendaceRecord.forEach((studentId, status) {
      if (status == 'S' || status == 'I' || status == 'A') {
        absenDataToSubmit.add({"id_siswa": studentId, "status": status});
      }
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() => _isSubmiting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Berhasil! ${absenDataToSubmit.length} data Absen terkirim',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalStudents = _allStudents.length;

    int processedCount = _attaendaceRecord.length;
    double progressPrecent = (totalStudents == 0)
        ? 0
        : (processedCount / totalStudents);

    int countH = _attaendaceRecord.values.where((s) => s == 'H').length;
    int countS = _attaendaceRecord.values.where((s) => s == 'S').length;
    int countI = _attaendaceRecord.values.where((s) => s == 'I').length;
    int countA = _attaendaceRecord.values.where((s) => s == 'A').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.className,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.subjectName,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progres Presensi: ${(progressPrecent * 100).toInt()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '$processedCount/$totalStudents Siswa',
                      style: const TextStyle(
                        color: Color(0xFF4A65E5),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: LinearProgressIndicator(
                    value: progressPrecent,
                    backgroundColor: Colors.grey.shade200,
                    color: const Color(0xFF4A65E5),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _displayedStudent.isEmpty
                ? const Center(
                    child: Text(
                      "Semua Siswa di layar sudah diproses!\nKlik Kirim Presensi untuk menyelesaikan.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _displayedStudent.length,
                    itemBuilder: (context, index) {
                      final student = _displayedStudent[index];

                      int indexNumber = _allStudents.indexOf(student) + 1;
                      String currentStatus =
                          _attaendaceRecord[student.id] ?? '';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
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
                            Text(
                              indexNumber.toString().padLeft(2, '0'),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(student.avatarUrl),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student.name.length > 12
                                        ? "${student.name.substring(0, 12)}..."
                                        : student.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'NIS : ${student.nis}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                _buildStatusBtn(
                                  'H',
                                  currentStatus,
                                  const Color(0xFF4A65E5),
                                  () => _markAttendance(student, 'H'),
                                ),
                                const SizedBox(width: 6),
                                _buildStatusBtn(
                                  'S',
                                  currentStatus,
                                  const Color(0xFFF59E0B),
                                  () => _markAttendance(student, 'S'),
                                ),
                                const SizedBox(width: 6),
                                _buildStatusBtn(
                                  'I',
                                  currentStatus,
                                  const Color(0xFF0EA5E9),
                                  () => _markAttendance(student, 'I'),
                                ),
                                const SizedBox(width: 6),
                                _buildStatusBtn(
                                  'A',
                                  currentStatus,
                                  const Color(0xFFEF4444),
                                  () => _markAttendance(student, 'A'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05), blurRadius: 20, offset:  const Offset(0, -5)
                )
              ]
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSumaryChip('$countH hadir', const Color(0xFF10B981)),
                      _buildSumaryChip('$countS Sakit', const Color(0xFFF59E0B)),
                      _buildSumaryChip('$countI Izin', const Color(0xFF0EA5E9)),
                      _buildSumaryChip('$countA Alpha', const Color(0xFFEF4444)),
                    ],
                  ),
                  const SizedBox(height:20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:_isSubmiting ? null : _submitAttandance, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xF4A65E5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0
                      ),
                      child: _isSubmiting
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Kirim Presensi ($processedCount)",
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.send_rounded, size: 16, color: Colors.white)
                          ],
                        )
                    ),
                  )
                ],
              ) 
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusBtn(
    String text,
    String currentStatus,
    Color activateColor,
    VoidCallback ontap,
  ) {
    bool isSelected = currentStatus == text;
    return GestureDetector(
      onTap: ontap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? activateColor : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? activateColor : Colors.grey.shade600,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activateColor.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade500,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSumaryChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
