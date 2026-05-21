import 'package:flutter/material.dart';
import 'package:attend/features/teacher/presentation/screens/exam/models/question.dart';
import 'package:attend/features/teacher/presentation/screens/exam/models/exam.dart';

class CreateExamStep3Screen extends StatelessWidget {
  final Map<String, dynamic> examInfo;
  final List<Question> questions;

  const CreateExamStep3Screen({
    super.key,
    required this.examInfo,
    required this.questions,
  });

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color greenCheck = Color(0xFF10B981);
  static const Color lightGreen = Color(0xFFD1FAE5);

  int get _multipleChoiceCount =>
      questions.where((q) => q.type == QuestionType.multipleChoice).length;

  int get _essayCount =>
      questions.where((q) => q.type == QuestionType.essay).length;

  int get _totalWeight => questions.fold(0, (sum, q) => sum + q.weight);

  void _handleSave(BuildContext context) {
    // Create Exam object
    final exam = Exam(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: examInfo['name'] ?? '',
      subject: examInfo['subject'] ?? '',
      targetKKM: examInfo['targetKKM'] ?? 0,
      duration: examInfo['duration'] ?? 0,
      instructions: examInfo['instructions'] ?? '',
      questions: questions,
      createdAt: DateTime.now(),
    );

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ujian berhasil disimpan!'),
        backgroundColor: greenCheck,
        duration: Duration(seconds: 2),
      ),
    );

    // Pop back to exam list with exam data
    // Step 3 → Step 2
    Navigator.of(context).pop();
    // Step 2 → Step 1
    Navigator.of(context).pop();
    // Step 1 → Exam List with exam data
    Navigator.of(context).pop(exam);
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
          'New Exam',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Stepper
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: _buildStepper(),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Success Icon
                  _buildSuccessIcon(),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Ujian Siap Disimpan!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Summary Card
                  _buildSummaryCard(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Bottom Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _handleSave(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Simpan Ujian',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.save, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(1, 'DETAIL', false, isComplete: true),
        _buildStepConnector(true),
        _buildStep(2, 'SUSUN SOAL', false, isComplete: true),
        _buildStepConnector(true),
        _buildStep(3, 'SELESAI', true),
      ],
    );
  }

  Widget _buildStep(int number, String label, bool isActive,
      {bool isComplete = false}) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isComplete
                ? greenCheck
                : isActive
                    ? primaryBlue
                    : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isComplete
                ? const Icon(Icons.check, color: Colors.white, size: 24)
                : Text(
                    number.toString(),
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? primaryBlue : textGrey,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 28),
      color: isActive ? greenCheck : Colors.grey.shade300,
    );
  }

  Widget _buildSuccessIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: lightGreen,
            shape: BoxShape.circle,
          ),
        ),
        // Main circle
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: greenCheck,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 48,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.description, color: primaryBlue, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Ringkasan Ujian',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Divider
          Container(
            height: 2,
            color: primaryBlue,
          ),
          const SizedBox(height: 20),

          // Nama Ujian
          _buildInfoRow('Nama Ujian', examInfo['name'] ?? '-'),
          const SizedBox(height: 16),

          // Mata Pelajaran
          _buildInfoRow('Mata Pelajaran', examInfo['subject'] ?? '-'),
          const SizedBox(height: 16),

          // KKM & Durasi
          _buildInfoRow(
            'KKM & Durasi',
            '${examInfo['targetKKM'] ?? 0} | ${examInfo['duration'] ?? 0} Menit',
          ),
          const SizedBox(height: 20),

          // Statistik Soal
          _buildInfoRow('Statistik Soal', '${questions.length} Soal'),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              '$_multipleChoiceCount Pilihan Ganda, $_essayCount Essay',
              style: TextStyle(
                fontSize: 13,
                color: textGrey,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Total Bobot
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Bobot',
                  style: TextStyle(
                    fontSize: 14,
                    color: textGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$_totalWeight/100',
                  style: const TextStyle(
                    fontSize: 24,
                    color: greenCheck,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: textGrey,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: textDark,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
