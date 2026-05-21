import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeacherGradingDetailScreen extends StatefulWidget {
  final List<Map<String, dynamic>> studentsList;
  final int initialIndex;

  const TeacherGradingDetailScreen({
    super.key,
    required this.studentsList,
    required this.initialIndex,
  });

  @override
  State<TeacherGradingDetailScreen> createState() => _TeacherGradingDetailScreenState();
}

class _TeacherGradingDetailScreenState extends State<TeacherGradingDetailScreen> {
  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color lightBlueBadge = Color(0xFFE8EEFF);

  late int _currentIndex;
  late Map<String, dynamic> _currentStudent;

  // Dummy essay questions (these would normally be fetched based on the exam and student's answers)
  final List<Map<String, dynamic>> _essayAnswers = [
    {
      'id': 'q1',
      'question': 'Jelaskan konsep MVC (Model-View-Controller) pada pengembangan aplikasi web!',
      'answer': 'MVC adalah sebuah pola arsitektur perangkat lunak yang memisahkan aplikasi menjadi tiga komponen utama:\n\n1. Model: Mengelola data, logika bisnis, dan aturan aplikasi. Ini berhubungan langsung dengan database.\n2. View: Bagian antarmuka pengguna (UI) yang menampilkan data ke pengguna akhir.\n3. Controller: Penghubung antara Model dan View. Menerima input dari pengguna (View), memprosesnya (bisa melalui Model), dan mengembalikan hasilnya ke View.',
      'maxScore': 20,
      'score': 0, // Assigned score
    },
    {
      'id': 'q2',
      'question': 'Apa perbedaan utama antara metode HTTP GET dan POST?',
      'answer': 'GET digunakan untuk mengambil data dari server, datanya terlihat di URL sehingga kurang aman untuk data sensitif. POST digunakan untuk mengirim data ke server, datanya disembunyikan di dalam body request HTTP sehingga lebih aman.',
      'maxScore': 15,
      'score': 0,
    },
    {
      'id': 'q3',
      'question': 'Jelaskan kegunaan Session dalam PHP!',
      'answer': 'Session digunakan untuk menyimpan data sementara di server yang dapat diakses di berbagai halaman web selama kunjungan pengguna. Hal ini berguna untuk fitur login, keranjang belanja, dll.',
      'maxScore': 15,
      'score': 0,
    },
  ];

  // Controllers for grading inputs
  final Map<String, TextEditingController> _scoreControllers = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _currentStudent = widget.studentsList[_currentIndex];
    _initControllers();
  }

  void _initControllers() {
    // Clear and initialize controllers based on dummy essays
    _scoreControllers.clear();
    for (var essay in _essayAnswers) {
      // Reset dummy score for the new student
      essay['score'] = 0; 
      
      final controller = TextEditingController(text: '');
      controller.addListener(() => _updateTotalScore());
      _scoreControllers[essay['id']] = controller;
    }
  }

  void _updateTotalScore() {
    // Only recalculate UI
    setState(() {});
  }

  int _calculateTotalEssayScore() {
    int total = 0;
    for (var essay in _essayAnswers) {
      final text = _scoreControllers[essay['id']]?.text ?? '0';
      total += int.tryParse(text) ?? 0;
    }
    return total;
  }

  @override
  void dispose() {
    for (var controller in _scoreControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleSimpanDanLanjut() {
    // 1. Simpan nilai ke database (Dummy: update local state)
    _currentStudent['status'] = 'graded';
    
    // 2. Cek apakah masih ada siswa berikutnya
    if (_currentIndex < widget.studentsList.length - 1) {
      // Pindah ke siswa berikutnya (Magic UX - Seamless transition)
      setState(() {
        _currentIndex++;
        _currentStudent = widget.studentsList[_currentIndex];
        
        // Reset/re-init controllers and answers for the new student
        for (var essay in _essayAnswers) {
          essay['score'] = 0;
          _scoreControllers[essay['id']]?.text = '';
        }
      });
      
      // Scroll back to top if using a scroll controller (optional, but good UX)
      // Since we rebuild completely, it might naturally jump, but let's assume it's fine for now.
    } else {
      // Jika sudah siswa terakhir
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua lembar jawaban telah selesai dikoreksi! 🎉'),
          backgroundColor: Color(0xFF10B981), // greenStatus
        ),
      );
      Navigator.pop(context, true); // true indicates data changed
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalScore = _calculateTotalEssayScore();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lembar Jawaban',
              style: TextStyle(
                color: textGrey,
                fontSize: 12,
              ),
            ),
            Text(
              _currentStudent['name'],
              style: const TextStyle(
                color: textDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'PG: ${_currentStudent['pgScore']}/100',
                style: const TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Indicator Progress
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Siswa ${_currentIndex + 1} dari ${widget.studentsList.length}',
                  style: const TextStyle(color: textGrey, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Sisa: ${widget.studentsList.length - _currentIndex - 1}',
                  style: const TextStyle(color: textGrey, fontSize: 13),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _essayAnswers.length,
              itemBuilder: (context, index) {
                final essay = _essayAnswers[index];
                return _buildEssayCard(essay, index);
              },
            ),
          ),
          
          // Sticky Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Esai',
                        style: TextStyle(color: textGrey, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalScore pts',
                        style: const TextStyle(color: textDark, fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleSimpanDanLanjut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentIndex < widget.studentsList.length - 1 
                                ? 'Simpan & Lanjut' 
                                : 'Selesai',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_currentIndex < widget.studentsList.length - 1) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                          ],
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

  Widget _buildEssayCard(Map<String, dynamic> essay, int index) {
    final controller = _scoreControllers[essay['id']]!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Esai No. ${index + 1}',
                        style: const TextStyle(color: textDark, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  essay['question'],
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
          // Student Answer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA), // Latar abu-abu sangat terang
              border: Border.symmetric(
                horizontal: BorderSide(color: Color(0xFFF1F5F9)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'JAWABAN SISWA',
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  essay['answer'],
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          
          // Grading Area
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: lightBlueBadge, // Latar sedikit kebiruan
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BERIKAN NILAI',
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Batas Nilai: 0 - ${essay['maxScore']}',
                      style: TextStyle(
                        color: primaryBlue.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 80,
                  height: 48,
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: primaryBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '0',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryBlue.withOpacity(0.2), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryBlue, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      // Auto-correct logic
                      if (value.isNotEmpty) {
                        int? parsedValue = int.tryParse(value);
                        if (parsedValue != null && parsedValue > essay['maxScore']) {
                          // Correct to max score
                          controller.text = essay['maxScore'].toString();
                          // Move cursor to end
                          controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: controller.text.length),
                          );
                          
                          // Show tiny snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Nilai maksimum untuk soal ini adalah ${essay['maxScore']}'),
                              backgroundColor: Colors.orange.shade700,
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.only(bottom: 120, left: 24, right: 24),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
