import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:attend/core/theme/app_colors.dart';
import 'package:attend/features/admin/presentation/screens/manageTeacherAttendance/models/attendance_config_model.dart';
import 'package:attend/features/admin/presentation/screens/manageTeacherAttendance/utils/qr_pdf_generator.dart';

class QrSetupTab extends StatefulWidget {
  final AttendanceConfig config;
  final ValueChanged<AttendanceConfig> onConfigChanged;

  const QrSetupTab({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  State<QrSetupTab> createState() => _QrSetupTabState();
}

class _QrSetupTabState extends State<QrSetupTab> {
  late TextEditingController _schoolNameController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  late TextEditingController _checkInController;
  late TextEditingController _checkOutController;
  late double _radius;
  late AttendanceConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.config;
    _schoolNameController = TextEditingController(text: _config.schoolName);
    _latController = TextEditingController(text: _config.latitude.toString());
    _lngController = TextEditingController(text: _config.longitude.toString());
    _checkInController = TextEditingController(text: _config.checkInTime);
    _checkOutController = TextEditingController(text: _config.checkOutTime);
    _radius = _config.radiusMeters;
  }

  @override
  void dispose() {
    _schoolNameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _checkInController.dispose();
    _checkOutController.dispose();
    super.dispose();
  }

  void _updateConfig() {
    _config = _config.copyWith(
      schoolName: _schoolNameController.text,
      latitude: double.tryParse(_latController.text) ?? _config.latitude,
      longitude: double.tryParse(_lngController.text) ?? _config.longitude,
      radiusMeters: _radius,
      checkInTime: _checkInController.text,
      checkOutTime: _checkOutController.text,
    );
    widget.onConfigChanged(_config);
  }

  void _generateQrCode() {
    final token = const Uuid().v4();
    setState(() {
      _config = _config.copyWith(
        qrToken: token,
        generatedAt: DateTime.now(),
        isConfigured: true,
      );
    });
    widget.onConfigChanged(_config);
  }

  void _resetQrCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset QR Code?'),
        content: const Text(
          'QR Code lama akan tidak berlaku lagi. Semua guru harus scan QR Code baru. Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _generateQrCode();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final parts = controller.text.split(':');
    final initialTime = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 7,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      _updateConfig();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section A: Lokasi Sekolah
          _buildSectionTitle('📍 Lokasi Sekolah', 'Atur titik koordinat dan radius geofencing'),
          const SizedBox(height: 16),
          _buildLocationCard(),

          const SizedBox(height: 28),

          // Section B: Pengaturan Jam
          _buildSectionTitle('⏰ Pengaturan Jam', 'Atur jam masuk dan pulang guru'),
          const SizedBox(height: 16),
          _buildTimeSettingsCard(),

          const SizedBox(height: 28),

          // Section C: QR Code
          _buildSectionTitle('📱 QR Code Presensi', 'Generate dan cetak QR Code untuk presensi'),
          const SizedBox(height: 16),
          _buildQrCodeCard(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textGreyHint,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // School Name
          _buildInputField(
            label: 'Nama Sekolah',
            controller: _schoolNameController,
            icon: Icons.school_outlined,
            hint: 'Contoh: SMKN 1 Bantul',
            onChanged: (_) => _updateConfig(),
          ),
          const SizedBox(height: 16),

          // Coordinate Visualization
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue.withOpacity(0.05),
                  AppColors.primaryBlue.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Grid lines
                ..._buildGridLines(),

                // Radius circle
                Container(
                  width: _radius * 1.2,
                  height: _radius * 1.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.4),
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),

                // Center pin
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_radius.toInt()}m',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.location_on,
                      color: AppColors.primaryBlue,
                      size: 36,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Latitude & Longitude inputs
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'Latitude',
                  controller: _latController,
                  icon: Icons.north,
                  hint: '-7.7956',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  onChanged: (_) => _updateConfig(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: 'Longitude',
                  controller: _lngController,
                  icon: Icons.east,
                  hint: '110.3695',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  onChanged: (_) => _updateConfig(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Radius Slider
          Row(
            children: [
              const Icon(Icons.radar, color: AppColors.primaryBlue, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Radius Geofencing',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_radius.toInt()} meter',
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primaryBlue,
              inactiveTrackColor: AppColors.primaryBlue.withOpacity(0.15),
              thumbColor: AppColors.primaryBlue,
              overlayColor: AppColors.primaryBlue.withOpacity(0.1),
              trackHeight: 6,
            ),
            child: Slider(
              value: _radius,
              min: 25,
              max: 200,
              divisions: 35,
              onChanged: (value) {
                setState(() => _radius = value);
                _updateConfig();
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('25m', style: TextStyle(fontSize: 11, color: AppColors.textGreyHint)),
              Text('200m', style: TextStyle(fontSize: 11, color: AppColors.textGreyHint)),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGridLines() {
    return [
      // Horizontal lines
      for (int i = 0; i < 5; i++)
        Positioned(
          top: i * 40.0,
          left: 0,
          right: 0,
          child: Container(height: 0.5, color: AppColors.primaryBlue.withOpacity(0.1)),
        ),
      // Vertical lines
      for (int i = 0; i < 8; i++)
        Positioned(
          left: i * 50.0,
          top: 0,
          bottom: 0,
          child: Container(width: 0.5, color: AppColors.primaryBlue.withOpacity(0.1)),
        ),
    ];
  }

  Widget _buildTimeSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Jam Masuk
              Expanded(
                child: InkWell(
                  onTap: () => _pickTime(_checkInController),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.login_rounded, color: Color(0xFF10B981), size: 28),
                        const SizedBox(height: 8),
                        const Text(
                          'Jam Masuk',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF059669),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _checkInController.text,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF047857),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'WIB',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF059669),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Arrow
              const Icon(Icons.arrow_forward_rounded, color: AppColors.textGreyHint),
              const SizedBox(width: 16),

              // Jam Pulang
              Expanded(
                child: InkWell(
                  onTap: () => _pickTime(_checkOutController),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.logout_rounded, color: Color(0xFFF59E0B), size: 28),
                        const SizedBox(height: 8),
                        const Text(
                          'Jam Pulang',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD97706),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _checkOutController.text,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB45309),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'WIB',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFD97706),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Guru yang scan setelah jam masuk akan ditandai "Terlambat". Tap jam untuk mengubah.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryBlue,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodeCard() {
    final hasQr = _config.qrToken.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!hasQr) ...[
            // No QR yet — Show Generate button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.qr_code_2_rounded,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada QR Code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Generate QR Code untuk memulai presensi guru',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textGreyHint,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _schoolNameController.text.isEmpty
                    ? null
                    : _generateQrCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  disabledBackgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.qr_code_rounded, size: 24),
                label: const Text(
                  'Buat QR Code Presensi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (_schoolNameController.text.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Isi nama sekolah terlebih dahulu',
                  style: TextStyle(fontSize: 12, color: Colors.red.shade400),
                ),
              ),
          ] else ...[
            // QR Code exists — Show preview
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: _config.qrToken,
                      version: QrVersions.auto,
                      size: 200,
                      gapless: true,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: AppColors.primaryBlue,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _config.schoolName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dibuat: ${_formatDate(_config.generatedAt)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGreyHint,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => QrPdfGenerator.generateAndPrint(
                  context: context,
                  qrData: _config.qrToken,
                  schoolName: _config.schoolName,
                  generatedAt: _config.generatedAt,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 22),
                label: const Text(
                  'Cetak / Unduh PDF (A4)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _resetQrCode,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text(
                  'Reset QR Code',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textGreyLabel,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 20),
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.textGreyHint, fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} WIB';
  }
}
