import 'package:flutter/material.dart';

class TeacherPresenceResultScreen extends StatefulWidget {
  final bool isCheckOut;
  final String teacherName;
  final DateTime time;
  final String status; // "Tepat Waktu" / "Terlambat" / "Pulang Awal"
  final bool isValidLocation;
  final double distance;

  const TeacherPresenceResultScreen({
    super.key,
    required this.isCheckOut,
    required this.teacherName,
    required this.time,
    required this.status,
    required this.isValidLocation,
    required this.distance,
  });

  @override
  State<TeacherPresenceResultScreen> createState() =>
      _TeacherPresenceResultScreenState();
}

class _TeacherPresenceResultScreenState
    extends State<TeacherPresenceResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _checkAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color greenStatus = Color(0xFF10B981);
  static const Color orangeStatus = Color(0xFFF59E0B);
  static const Color redStatus = Color(0xFFEF4444);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    // Sequence animations
    _checkController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _fadeController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} WIB';
  }

  bool get _isOnTime => widget.status == 'Tepat Waktu';
  bool get _isSuccess => widget.isValidLocation;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Animated Checkmark/Cross Circle
                ScaleTransition(
                  scale: _checkAnimation,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: _isSuccess
                            ? [greenStatus, greenStatus.withOpacity(0.8)]
                            : [redStatus, redStatus.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _isSuccess
                              ? greenStatus.withOpacity(0.3)
                              : redStatus.withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isSuccess ? Icons.check_rounded : Icons.close_rounded,
                      color: Colors.white,
                      size: 72,
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // Main Text
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        _isSuccess
                            ? (widget.isCheckOut
                                ? 'Presensi Pulang\nBerhasil!'
                                : 'Presensi Masuk\nBerhasil!')
                            : 'Presensi\nGagal!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isSuccess
                            ? (widget.isCheckOut
                                ? 'Terima kasih, sampai jumpa besok!'
                                : 'Selamat bekerja hari ini!')
                            : 'Anda berada di luar radius sekolah.',
                        style: const TextStyle(
                          fontSize: 15,
                          color: textGrey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // Detail Card
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Teacher Name
                        _buildDetailRow(
                          icon: Icons.person_rounded,
                          iconColor: primaryBlue,
                          label: 'Nama',
                          value: widget.teacherName,
                        ),
                        const SizedBox(height: 16),
                        Divider(color: Colors.grey.shade100),
                        const SizedBox(height: 16),

                        // Time
                        _buildDetailRow(
                          icon: Icons.access_time_filled_rounded,
                          iconColor: primaryBlue,
                          label: widget.isCheckOut ? 'Jam Pulang' : 'Jam Masuk',
                          value: _formatTime(widget.time),
                        ),
                        const SizedBox(height: 16),
                        Divider(color: Colors.grey.shade100),
                        const SizedBox(height: 16),

                        // Location
                        _buildDetailRow(
                          icon: Icons.location_on_rounded,
                          iconColor: _isSuccess ? greenStatus : redStatus,
                          label: 'Lokasi',
                          value: _isSuccess
                              ? 'Sesuai ✓'
                              : 'Di Luar Area (${widget.distance.toStringAsFixed(0)}m)',
                        ),
                        const SizedBox(height: 20),

                        // Status Badge
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _isSuccess
                                ? (_isOnTime
                                    ? greenStatus.withOpacity(0.1)
                                    : orangeStatus.withOpacity(0.1))
                                : redStatus.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isSuccess
                                  ? (_isOnTime
                                      ? greenStatus.withOpacity(0.3)
                                      : orangeStatus.withOpacity(0.3))
                                  : redStatus.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isSuccess
                                    ? (_isOnTime
                                        ? Icons.check_circle_rounded
                                        : Icons.schedule_rounded)
                                    : Icons.cancel_rounded,
                                color: _isSuccess
                                    ? (_isOnTime ? greenStatus : orangeStatus)
                                    : redStatus,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isSuccess ? widget.status.toUpperCase() : 'GAGAL PRESENSI',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _isSuccess
                                      ? (_isOnTime ? greenStatus : orangeStatus)
                                      : redStatus,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Back Button
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.home_rounded, size: 22),
                      label: const Text(
                        'Kembali ke Beranda',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
