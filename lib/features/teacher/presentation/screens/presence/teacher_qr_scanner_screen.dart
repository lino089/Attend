import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:attend/features/teacher/presentation/screens/presence/teacher_presence_result_screen.dart';

class TeacherQrScannerScreen extends StatefulWidget {
  final bool isCheckOut;

  const TeacherQrScannerScreen({
    super.key,
    this.isCheckOut = false,
  });

  @override
  State<TeacherQrScannerScreen> createState() => _TeacherQrScannerScreenState();
}

enum LocationStatus { loading, valid, invalid }

class _TeacherQrScannerScreenState extends State<TeacherQrScannerScreen>
    with TickerProviderStateMixin {
  MobileScannerController? _scannerController;
  bool _isProcessing = false;
  String _processingMessage = 'Memverifikasi Lokasi...';

  // TODO: Fetch from database (attendance config)
  final double _schoolLat = -7.7956;
  final double _schoolLng = 110.3695;
  final double _radiusMeters = 50.0;
  final String _expectedToken = ''; // Empty = accept any QR for demo
  final String _checkInTime = '07:00';
  final String _checkOutTime = '15:00';

  // Animation
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnimation;

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color greenStatus = Color(0xFF10B981);
  static const Color yellowStatus = Color(0xFFF59E0B);
  static const Color redStatus = Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut),
    );

    _initScanner();
  }

  void _initScanner() {
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  Future<void> _processScanResult(String scannedData) async {
    setState(() {
      _isProcessing = true;
      _processingMessage = 'Mengecek Lokasi...';
    });
    _scannerController?.stop();

    // Validate QR token (if expected token is set)
    if (_expectedToken.isNotEmpty && scannedData != _expectedToken) {
      _showInvalidQrSnackbar();
      setState(() => _isProcessing = false);
      _scannerController?.start();
      return;
    }

    bool isValidLocation = false;
    double calculatedDistance = 0.0;
    String statusMessage = '';

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          statusMessage = 'Izin lokasi ditolak';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        statusMessage = 'Izin lokasi ditolak permanen';
      }

      if (statusMessage.isEmpty) {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );

        calculatedDistance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          _schoolLat,
          _schoolLng,
        );

        isValidLocation = calculatedDistance <= _radiusMeters;
      }
    } catch (e) {
      // Demo fallback if GPS fails
      isValidLocation = true;
      calculatedDistance = 15.0; // dummy distance
    }

    // Calculate status time
    final now = DateTime.now();
    String timeStatus;

    if (!widget.isCheckOut) {
      final checkInParts = _checkInTime.split(':');
      final checkInLimit = DateTime(
        now.year, now.month, now.day,
        int.parse(checkInParts[0]),
        int.parse(checkInParts[1]),
      );
      timeStatus = now.isAfter(checkInLimit) ? 'Terlambat' : 'Tepat Waktu';
    } else {
      final checkOutParts = _checkOutTime.split(':');
      final checkOutLimit = DateTime(
        now.year, now.month, now.day,
        int.parse(checkOutParts[0]),
        int.parse(checkOutParts[1]),
      );
      timeStatus = now.isBefore(checkOutLimit) ? 'Pulang Awal' : 'Tepat Waktu';
    }

    if (!mounted) return;

    // Navigate to result
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherPresenceResultScreen(
          isCheckOut: widget.isCheckOut,
          teacherName: 'Budi Santoso', // TODO: from auth
          time: now,
          status: timeStatus,
          isValidLocation: isValidLocation,
          distance: calculatedDistance,
        ),
      ),
    );
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final scannedData = barcode.rawValue!;
    _processScanResult(scannedData);
  }

  void _showInvalidQrSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR Code tidak valid! Gunakan QR Code resmi sekolah.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    _pulseController.dispose();
    _scanLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera View
          MobileScanner(
            controller: _scannerController!,
            onDetect: _onBarcodeDetected,
          ),

          // Overlay
          _buildOverlay(),

          // Top section (AppBar)
          _buildTopSection(),

          // Bottom instruction
          _buildBottomInstruction(),

          // Loading overlay when processing
          if (_isProcessing) _buildProcessingOverlay(),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.isCheckOut
                  ? 'Scan QR Presensi Pulang'
                  : 'Scan QR Presensi Masuk',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scanAreaSize = constraints.maxWidth * 0.65;
        final topOffset = (constraints.maxHeight - scanAreaSize) / 2 - 30;
        final leftOffset = (constraints.maxWidth - scanAreaSize) / 2;

        return Stack(
          children: [
            // Dark overlay with transparent hole
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Positioned(
                    top: topOffset,
                    left: leftOffset,
                    child: Container(
                      width: scanAreaSize,
                      height: scanAreaSize,
                      decoration: BoxDecoration(
                        color: Colors.red, // Any color, will be cut out
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scan area border
            Positioned(
              top: topOffset,
              left: leftOffset,
              child: Container(
                width: scanAreaSize,
                height: scanAreaSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.6),
                    width: 2.5,
                  ),
                ),
                child: Stack(
                  children: [
                    // Corner indicators
                    ..._buildCornerIndicators(scanAreaSize),

                    // Scanning line animation
                    AnimatedBuilder(
                      animation: _scanLineAnimation,
                      builder: (context, child) {
                        return Positioned(
                          top: _scanLineAnimation.value * (scanAreaSize - 4),
                          left: 16,
                          right: 16,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primaryBlue.withOpacity(0),
                                  primaryBlue,
                                  primaryBlue.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildCornerIndicators(double size) {
    const cornerLength = 30.0;
    const cornerWidth = 4.0;
    const color = primaryBlue;

    return [
      // Top-left
      Positioned(top: -1, left: -1, child: _cornerPiece(color, cornerLength, cornerWidth, topLeft: true)),
      // Top-right
      Positioned(top: -1, right: -1, child: _cornerPiece(color, cornerLength, cornerWidth, topRight: true)),
      // Bottom-left
      Positioned(bottom: -1, left: -1, child: _cornerPiece(color, cornerLength, cornerWidth, bottomLeft: true)),
      // Bottom-right
      Positioned(bottom: -1, right: -1, child: _cornerPiece(color, cornerLength, cornerWidth, bottomRight: true)),
    ];
  }

  Widget _cornerPiece(Color color, double length, double width, {
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return Container(
      width: length,
      height: length,
      decoration: BoxDecoration(
        border: Border(
          top: (topLeft || topRight) ? BorderSide(color: color, width: width) : BorderSide.none,
          bottom: (bottomLeft || bottomRight) ? BorderSide(color: color, width: width) : BorderSide.none,
          left: (topLeft || bottomLeft) ? BorderSide(color: color, width: width) : BorderSide.none,
          right: (topRight || bottomRight) ? BorderSide(color: color, width: width) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: topLeft ? const Radius.circular(24) : Radius.zero,
          topRight: topRight ? const Radius.circular(24) : Radius.zero,
          bottomLeft: bottomLeft ? const Radius.circular(24) : Radius.zero,
          bottomRight: bottomRight ? const Radius.circular(24) : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildBottomInstruction() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.white.withOpacity(0.8),
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Arahkan kamera ke QR Code\nyang tersedia di Ruang Piket',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                color: primaryBlue,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _processingMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Menghitung jarak ke sekolah...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
