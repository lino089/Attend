import 'package:flutter/material.dart';

class StudentPostExamScreen extends StatelessWidget {
  final Map<String, dynamic> examData;
  final int totalScore;
  final bool hasEssay;

  const StudentPostExamScreen({
    super.key,
    required this.examData,
    required this.totalScore,
    required this.hasEssay,
  });

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color greenStatus = Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Success Illustration
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: greenStatus.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 80,
                  color: greenStatus,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Appreciation Text
              const Text(
                'Kerja Bagus!',
                style: TextStyle(
                  color: textDark,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              
              // Confirmation Text
              Text(
                'Jawaban Anda untuk\n"${examData['title']}"\ntelah berhasil disimpan dalam sistem.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: textGrey,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Score Summary Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    if (!hasEssay) ...[
                      const Text(
                        'Nilai Akhir Anda',
                        style: TextStyle(color: textGrey, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$totalScore/100',
                        style: const TextStyle(
                          color: primaryBlue,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'Nilai Pilihan Ganda',
                        style: TextStyle(color: textGrey, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$totalScore/100',
                        style: const TextStyle(
                          color: primaryBlue,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, size: 18, color: Colors.orange),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Nilai Esai sedang menunggu koreksi dari guru.',
                              style: TextStyle(
                                color: textDark,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to student dashboard. Using popUntil to remove all exam routes.
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_outlined, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Kembali ke Beranda',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
