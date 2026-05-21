import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPdfGenerator {
  /// Generate a PDF with QR Code and print/share it
  static Future<void> generateAndPrint({
    required BuildContext context,
    required String qrData,
    required String schoolName,
    DateTime? generatedAt,
  }) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF335CFA)),
      ),
    );

    try {
      // Generate QR Code image as bytes
      final qrImage = await _generateQrImageBytes(qrData);

      if (context.mounted) {
        Navigator.pop(context); // Close loading
      }

      // Build and share PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          return _buildPdf(
            qrImageBytes: qrImage,
            schoolName: schoolName,
            generatedAt: generatedAt,
          );
        },
        name: 'QR_Presensi_$schoolName',
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuat PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Generate QR Code as PNG bytes
  static Future<Uint8List> _generateQrImageBytes(String data) async {
    final qrPainter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: true,
      color: const Color(0xFF1E293B),
      emptyColor: Colors.white,
    );

    final picData = await qrPainter.toImageData(600, format: ui.ImageByteFormat.png);
    return picData!.buffer.asUint8List();
  }

  /// Build the actual PDF document
  static Future<Uint8List> _buildPdf({
    required Uint8List qrImageBytes,
    required String schoolName,
    DateTime? generatedAt,
  }) async {
    final pdf = pw.Document();
    final qrImage = pw.MemoryImage(qrImageBytes);

    final dateStr = generatedAt != null
        ? '${generatedAt.day}/${generatedAt.month}/${generatedAt.year}'
        : '-';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                // Header
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColor.fromHex('#335CFA'),
                      width: 2,
                    ),
                    borderRadius: pw.BorderRadius.circular(12),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Icon(
                        const pw.IconData(0xe80e),
                        size: 40,
                        color: PdfColor.fromHex('#335CFA'),
                      ),
                      pw.SizedBox(height: 12),
                      pw.Text(
                        schoolName.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#1E293B'),
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'SISTEM PRESENSI GURU',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#335CFA'),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 40),

                // QR Code
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColor.fromHex('#E2E8F0'),
                      width: 2,
                    ),
                    borderRadius: pw.BorderRadius.circular(16),
                  ),
                  child: pw.Image(qrImage, width: 250, height: 250),
                ),

                pw.SizedBox(height: 30),

                // Instructions
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#F0F4FF'),
                    borderRadius: pw.BorderRadius.circular(12),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'SCAN QR CODE INI UNTUK PRESENSI',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#335CFA'),
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'Buka aplikasi presensi → Tap "Presensi Kehadiran" → Arahkan kamera ke QR Code ini',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 11,
                          color: PdfColor.fromHex('#64748B'),
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 40),

                // Footer
                pw.Divider(color: PdfColor.fromHex('#E2E8F0')),
                pw.SizedBox(height: 12),
                pw.Text(
                  'Tanggal Generate: $dateStr',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColor.fromHex('#94A3B8'),
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Tempel QR Code ini di Ruang Piket atau Mading Guru',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColor.fromHex('#94A3B8'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}
