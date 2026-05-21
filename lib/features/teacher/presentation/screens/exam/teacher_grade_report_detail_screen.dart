import 'package:flutter/material.dart';
import 'helpers/excel_export_helper.dart';

class TeacherGradeReportDetailScreen extends StatefulWidget {
  final Map<String, dynamic> examData;

  const TeacherGradeReportDetailScreen({
    super.key,
    required this.examData,
  });

  @override
  State<TeacherGradeReportDetailScreen> createState() =>
      _TeacherGradeReportDetailScreenState();
}

class _TeacherGradeReportDetailScreenState
    extends State<TeacherGradeReportDetailScreen> {
  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color greenStatus = Color(0xFF10B981);
  static const Color redStatus = Color(0xFFEF4444);
  static const Color bgGrey = Color(0xFFF8F9FA);

  String _searchQuery = '';
  bool _isExporting = false;

  // Dummy students grading data
  late List<Map<String, dynamic>> _students;

  @override
  void initState() {
    super.initState();
    _generateDummyStudentGrades();
  }

  void _generateDummyStudentGrades() {
    _students = [
      {
        'nisn': '0087126341',
        'name': 'Aditya Pratama',
        'pgScore': 50,
        'essayScore': 35,
        'finalScore': 85,
      },
      {
        'nisn': '0089123847',
        'name': 'Ahmad Fauzi',
        'pgScore': 45,
        'essayScore': 35,
        'finalScore': 80,
      },
      {
        'nisn': '0092384712',
        'name': 'Anisa Rahmawati',
        'pgScore': 50,
        'essayScore': 45,
        'finalScore': 95,
      },
      {
        'nisn': '0081273948',
        'name': 'Budi Cahyono',
        'pgScore': 35,
        'essayScore': 25,
        'finalScore': 60, // Below KKM
      },
      {
        'nisn': '0084592837',
        'name': 'Citra Lestari',
        'pgScore': 48,
        'essayScore': 40,
        'finalScore': 88,
      },
      {
        'nisn': '0091827364',
        'name': 'Dedi Dermawan',
        'pgScore': 38,
        'essayScore': 30,
        'finalScore': 68, // Below KKM
      },
      {
        'nisn': '0083746281',
        'name': 'Eka Saputra',
        'pgScore': 42,
        'essayScore': 35,
        'finalScore': 77,
      },
      {
        'nisn': '0092837465',
        'name': 'Fani Rahayu',
        'pgScore': 50,
        'essayScore': 40,
        'finalScore': 90,
      },
      {
        'nisn': '0082736495',
        'name': 'Guntur Wibowo',
        'pgScore': 30,
        'essayScore': 20,
        'finalScore': 50, // Below KKM
      },
      {
        'nisn': '0093847562',
        'name': 'Indah Permata',
        'pgScore': 46,
        'essayScore': 38,
        'finalScore': 84,
      },
    ];
  }

  List<Map<String, dynamic>> get _filteredStudents {
    if (_searchQuery.trim().isEmpty) return _students;
    return _students.where((student) {
      return student['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student['nisn'].contains(_searchQuery);
    }).toList();
  }

  Future<void> _exportToExcel() async {
    setState(() {
      _isExporting = true;
    });

    final kkm = widget.examData['targetKKM'] ?? 75;
    
    // Call the helper to export
    final String? path = await ExcelExportHelper.exportGrades(
      examName: widget.examData['name'],
      className: widget.examData['className'],
      targetKKM: kkm,
      studentsData: _students,
    );

    setState(() {
      _isExporting = false;
    });

    if (mounted) {
      if (path != null) {
        _showSuccessDialog(path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengekspor laporan Excel.'),
            backgroundColor: redStatus,
          ),
        );
      }
    }
  }

  void _showSuccessDialog(String path) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: greenStatus, size: 28),
            SizedBox(width: 8),
            Text('Ekspor Berhasil'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laporan rekap nilai ujian berhasil disimpan ke folder Downloads Anda.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                path,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                  color: textDark,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kkm = widget.examData['targetKKM'] ?? 75;
    final isGraded = widget.examData['status'] == 'Selesai Dinilai';

    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Rekap Nilai',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (isGraded)
            _isExporting
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryBlue,
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.download_rounded, color: greenStatus),
                    tooltip: 'Ekspor Excel',
                    onPressed: _exportToExcel,
                  ),
        ],
      ),
      body: Column(
        children: [
          // Header Card Info
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.examData['className'],
                      style: const TextStyle(
                        color: primaryBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.examData['date'],
                      style: const TextStyle(
                        color: textGrey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.examData['name'],
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.examData['subject'],
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                const SizedBox(height: 16),
                
                // KKM Info Banner
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryBlue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.grade_outlined, color: primaryBlue, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'KKM Ujian',
                              style: TextStyle(color: textGrey, fontSize: 11),
                            ),
                            Text(
                              '$kkm',
                              style: const TextStyle(
                                color: textDark,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (isGraded)
                      ElevatedButton.icon(
                        onPressed: _isExporting ? null : _exportToExcel,
                        icon: const Icon(Icons.description_outlined, size: 18),
                        label: const Text('Ekspor Excel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenStatus,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.hourglass_empty_rounded, color: Color(0xFFD97706), size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Belum Dinilai',
                              style: TextStyle(
                                color: Color(0xFFD97706),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Search Table Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari NISN atau nama siswa...',
                hintStyle: const TextStyle(color: textGrey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: textGrey, size: 18),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Table Section
          Expanded(
            child: !isGraded
                ? _buildNotGradedState()
                : _filteredStudents.isEmpty
                    ? _buildEmptyTableState()
                    : Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
                                dataRowHeight: 56,
                                columnSpacing: 24,
                                columns: const [
                                  DataColumn(label: Text('No', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Nama Siswa', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('NISN', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('PG', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Esai', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Akhir', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                                ],
                                rows: List.generate(_filteredStudents.length, (index) {
                                  final student = _filteredStudents[index];
                                  final finalScore = student['finalScore'] as int;
                                  final bool isPass = finalScore >= kkm;

                                  return DataRow(
                                    color: WidgetStateProperty.resolveWith<Color?>((states) {
                                      // Highlight failing scores in red pastel
                                      if (!isPass) {
                                        return redStatus.withOpacity(0.04);
                                      }
                                      return null;
                                    }),
                                    cells: [
                                      DataCell(Text('${index + 1}')),
                                      DataCell(
                                        Text(
                                          student['name'],
                                          style: const TextStyle(fontWeight: FontWeight.w600, color: textDark),
                                        ),
                                      ),
                                      DataCell(Text(student['nisn'])),
                                      DataCell(Text('${student['pgScore']}')),
                                      DataCell(Text('${student['essayScore']}')),
                                      DataCell(
                                        Text(
                                          '$finalScore',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isPass ? greenStatus : redStatus,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: isPass
                                                ? greenStatus.withOpacity(0.1)
                                                : redStatus.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            isPass ? 'LULUS' : 'REMEDIAL',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: isPass ? greenStatus : redStatus,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotGradedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_empty_rounded,
                size: 48,
                color: Color(0xFFD97706),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ujian Belum Dinilai Sepenuhnya',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Untuk melihat tabel rekap nilai, Anda harus mengoreksi seluruh jawaban esai siswa terlebih dahulu melalui menu Penilaian.',
              style: TextStyle(
                fontSize: 14,
                color: textGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTableState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_outlined, size: 48, color: textGrey),
          SizedBox(height: 12),
          Text(
            'Siswa tidak ditemukan',
            style: TextStyle(fontSize: 14, color: textGrey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
