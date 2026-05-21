import 'package:flutter/material.dart';
import 'dart:async';
import 'package:attend/features/student/presentation/screens/exam/student_post_exam_screen.dart';

class StudentExamActiveScreen extends StatefulWidget {
  final Map<String, dynamic> examData;

  const StudentExamActiveScreen({
    super.key,
    required this.examData,
  });

  @override
  State<StudentExamActiveScreen> createState() => _StudentExamActiveScreenState();
}

class _StudentExamActiveScreenState extends State<StudentExamActiveScreen> {
  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color greenStatus = Color(0xFF10B981);
  static const Color bgGrey = Color(0xFFF8F9FA);

  // Exam state
  late int _durationSeconds;
  Timer? _timer;
  int _currentIndex = 0;
  
  // Dummy Question list mapping
  late List<Map<String, dynamic>> _questions;
  // Track answers (question id -> answer value)
  final Map<String, dynamic> _answers = {};

  final TextEditingController _essayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _durationSeconds = widget.examData['duration'] * 60;
    _generateDummyQuestions();
    _startTimer();
  }

  void _generateDummyQuestions() {
    _questions = [];
    final int pgCount = widget.examData['pgCount'] ?? 0;
    final int essayCount = widget.examData['essayCount'] ?? 0;

    for (int i = 0; i < pgCount; i++) {
      _questions.add({
        'id': 'pg_$i',
        'type': 'pg',
        'question': 'Berikut ini manakah yang merupakan konsep dasar dari arsitektur perangkat lunak yang baik? (Soal Pilihan Ganda No. ${i + 1})',
        'options': [
          'A. Semuanya dalam satu file',
          'B. Pemisahan tanggung jawab (Separation of Concerns)',
          'C. Menghindari penggunaan fungsi',
          'D. Tidak membutuhkan dokumentasi'
        ]
      });
    }

    for (int i = 0; i < essayCount; i++) {
      _questions.add({
        'id': 'essay_$i',
        'type': 'essay',
        'question': 'Jelaskan mengapa performa aplikasi web sangat bergantung pada optimalisasi database dan caching! Berikan contoh nyata. (Soal Esai No. ${i + 1})',
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_durationSeconds > 0) {
        setState(() {
          _durationSeconds--;
        });
      } else {
        _timer?.cancel();
        _forceSubmit();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _essayController.dispose();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    int h = totalSeconds ~/ 3600;
    int m = (totalSeconds % 3600) ~/ 60;
    int s = totalSeconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _forceSubmit() {
    _submitExam();
  }

  void _submitExam() {
    // Navigate to post exam (replacing current screen so user can't go back)
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StudentPostExamScreen(
          examData: widget.examData,
          totalScore: 85, // Dummy calculated score
          hasEssay: (widget.examData['essayCount'] ?? 0) > 0,
        ),
      ),
    );
  }

  void _confirmStopExam() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hentikan Ujian?'),
        content: const Text('Jawaban yang tersimpan tidak dapat dikumpulkan. Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: textGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to dashboard/exam list
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmSubmit() {
    // Check if there are unanswered questions
    int unanswered = _questions.length - _answers.length;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Kumpulkan Jawaban?'),
        content: Text(
          unanswered > 0 
              ? 'Anda masih memiliki $unanswered soal yang BELUM dijawab. Apakah Anda yakin ingin mengumpulkan ujian sekarang?'
              : 'Pastikan semua jawaban sudah benar. Apakah Anda yakin ingin mengumpulkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Periksa Lagi', style: TextStyle(color: textGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitExam();
            },
            style: ElevatedButton.styleFrom(backgroundColor: greenStatus),
            child: const Text('Kumpulkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _saveEssayAnswer() {
    final qId = _questions[_currentIndex]['id'];
    if (_essayController.text.trim().isNotEmpty) {
      _answers[qId] = _essayController.text;
    } else {
      _answers.remove(qId);
    }
  }

  void _loadEssayAnswer() {
    final qId = _questions[_currentIndex]['id'];
    _essayController.text = _answers[qId] ?? '';
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      if (_questions[_currentIndex]['type'] == 'essay') {
        _saveEssayAnswer();
      }
      setState(() {
        _currentIndex--;
        if (_questions[_currentIndex]['type'] == 'essay') {
          _loadEssayAnswer();
        }
      });
    }
  }

  void _goToNext() {
    if (_currentIndex < _questions.length - 1) {
      if (_questions[_currentIndex]['type'] == 'essay') {
        _saveEssayAnswer();
      }
      setState(() {
        _currentIndex++;
        if (_questions[_currentIndex]['type'] == 'essay') {
          _loadEssayAnswer();
        }
      });
    } else {
      // Is Last question, trigger submit
      if (_questions[_currentIndex]['type'] == 'essay') {
        _saveEssayAnswer();
      }
      _confirmSubmit();
    }
  }

  void _showAllQuestionsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Semua Soal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  final qId = _questions[index]['id'];
                  final bool isAnswered = _answers.containsKey(qId);
                  final bool isCurrent = index == _currentIndex;
                  
                  Color bgColor = Colors.white;
                  Color textColor = textGrey;
                  Color borderColor = Colors.grey.shade300;
                  
                  if (isCurrent) {
                    bgColor = primaryBlue;
                    textColor = Colors.white;
                    borderColor = primaryBlue;
                  } else if (isAnswered) {
                    bgColor = greenStatus;
                    textColor = Colors.white;
                    borderColor = greenStatus;
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      if (_questions[_currentIndex]['type'] == 'essay') {
                        _saveEssayAnswer();
                      }
                      setState(() {
                        _currentIndex = index;
                        if (_questions[_currentIndex]['type'] == 'essay') {
                          _loadEssayAnswer();
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor, width: 1.5),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (_questions[_currentIndex]['type'] == 'essay') {
                      _saveEssayAnswer();
                    }
                    _confirmSubmit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenStatus,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Kumpulkan Jawaban',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isTimeCritical = _durationSeconds <= 300; // < 5 minutes
    final currentQuestion = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: bgGrey,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Stop Button
                  IconButton(
                    onPressed: _confirmStopExam,
                    icon: const Icon(Icons.close, color: Colors.red),
                    tooltip: 'Hentikan Ujian',
                  ),
                  
                  // Question Indicator
                  Text(
                    'Soal ${_currentIndex + 1} dari ${_questions.length}',
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  // Timer
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isTimeCritical ? Colors.red.withOpacity(0.1) : primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer_outlined, 
                          size: 16, 
                          color: isTimeCritical ? Colors.red : primaryBlue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatDuration(_durationSeconds),
                          style: TextStyle(
                            color: isTimeCritical ? Colors.red : primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Divider
            Divider(height: 1, color: Colors.grey.shade200),
            
            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question text
                    Text(
                      currentQuestion['question'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Options or Essay
                    if (currentQuestion['type'] == 'pg') 
                      _buildPgOptions(currentQuestion)
                    else 
                      _buildEssayInput(),
                  ],
                ),
              ),
            ),
            
            // Bottom Navigation
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous button
                    GestureDetector(
                      onTap: _currentIndex > 0 ? _goToPrevious : null,
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: 16,
                            color: _currentIndex > 0 ? textGrey : Colors.grey.shade300,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'SOAL\n${(_currentIndex).toString().padLeft(2, '0')}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _currentIndex > 0 ? textGrey : Colors.grey.shade300,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // All questions button
                    GestureDetector(
                      onTap: _showAllQuestionsModal,
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.grid_view, color: primaryBlue, size: 24),
                          SizedBox(height: 4),
                          Text(
                            'SEMUA SOAL',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Next button or Submit
                    GestureDetector(
                      onTap: _currentIndex < _questions.length - 1
                          ? _goToNext
                          : () {
                              if (_questions[_currentIndex]['type'] == 'essay') {
                                _saveEssayAnswer();
                              }
                              _confirmSubmit();
                            },
                      child: _currentIndex < _questions.length - 1
                          ? Row(
                              children: [
                                Text(
                                  'SOAL\n${(_currentIndex + 2).toString().padLeft(2, '0')}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: textGrey,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: textGrey,
                                ),
                              ],
                            )
                          : const Row(
                              children: [
                                Text(
                                  'KUMPULKAN\nJAWABAN',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: greenStatus,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.check_circle,
                                  size: 18,
                                  color: greenStatus,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPgOptions(Map<String, dynamic> currentQuestion) {
    final List<String> options = currentQuestion['options'];
    final qId = currentQuestion['id'];
    final selectedOption = _answers[qId];

    return Column(
      children: options.map((option) {
        final bool isSelected = option == selectedOption;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _answers[qId] = option;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected ? primaryBlue.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? primaryBlue : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? primaryBlue : Colors.grey.shade400,
                      width: 2,
                    ),
                    color: isSelected ? primaryBlue : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.circle, color: Colors.white, size: 12)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? primaryBlue : textDark,
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEssayInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _essayController,
          maxLines: 8,
          onChanged: (text) {
            setState(() {}); // to update char count
          },
          decoration: InputDecoration(
            hintText: 'Ketik jawaban Anda di sini...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primaryBlue, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${_essayController.text.length} Karakter',
            style: const TextStyle(
              color: textGrey,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
