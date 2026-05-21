import 'dart:io';
import 'package:excel/excel.dart';

class ExcelExportHelper {
  static Future<String?> exportGrades({
    required String examName,
    required String className,
    required int targetKKM,
    required List<Map<String, dynamic>> studentsData,
  }) async {
    try {
      var excel = Excel.createExcel();
      
      // Default sheet is Sheet1, let's rename it
      excel.rename('Sheet1', 'Rekap Nilai');
      Sheet sheetObject = excel['Rekap Nilai'];
      
      // Style definition
      CellStyle titleStyle = CellStyle(
        bold: true,
        fontSize: 14,
        fontFamily: getFontFamily(FontFamily.Calibri),
      );

      CellStyle headerStyle = CellStyle(
        bold: true,
        fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
        backgroundColorHex: ExcelColor.fromHexString('#335CFA'), // Primary Blue
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        fontFamily: getFontFamily(FontFamily.Calibri),
      );

      CellStyle centerStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        fontFamily: getFontFamily(FontFamily.Calibri),
      );

      CellStyle leftStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Left,
        fontFamily: getFontFamily(FontFamily.Calibri),
      );

      CellStyle passStyle = CellStyle(
        fontColorHex: ExcelColor.fromHexString('#10B981'), // Green
        bold: true,
        horizontalAlign: HorizontalAlign.Center,
        fontFamily: getFontFamily(FontFamily.Calibri),
      );

      CellStyle failStyle = CellStyle(
        fontColorHex: ExcelColor.fromHexString('#EF4444'), // Red
        bold: true,
        horizontalAlign: HorizontalAlign.Center,
        fontFamily: getFontFamily(FontFamily.Calibri),
      );

      // Title & Metadata
      sheetObject.appendRow([TextCellValue('LAPORAN REKAPITULASI NILAI UJIAN')]);
      sheetObject.appendRow([TextCellValue('Nama Ujian: $examName')]);
      sheetObject.appendRow([TextCellValue('Kelas: $className')]);
      sheetObject.appendRow([TextCellValue('KKM: $targetKKM')]);
      sheetObject.appendRow([TextCellValue('')]); // Spacer

      // Apply title styling
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).cellStyle = titleStyle;

      // Table Headers
      sheetObject.appendRow([
        TextCellValue('No'),
        TextCellValue('NISN'),
        TextCellValue('Nama Siswa'),
        TextCellValue('Nilai PG'),
        TextCellValue('Nilai Esai'),
        TextCellValue('Nilai Akhir'),
        TextCellValue('Status Kelulusan')
      ]);

      // Style headers
      for (int col = 0; col < 7; col++) {
        var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 5));
        cell.cellStyle = headerStyle;
      }

      // Add Data Rows
      for (int i = 0; i < studentsData.length; i++) {
        final student = studentsData[i];
        final pgScore = student['pgScore'] as int;
        final essayScore = student['essayScore'] as int;
        final finalScore = student['finalScore'] as int;
        final bool isPass = finalScore >= targetKKM;
        final statusText = isPass ? 'LULUS' : 'REMEDIAL';

        sheetObject.appendRow([
          IntCellValue(i + 1),
          TextCellValue(student['nisn']?.toString() ?? ''),
          TextCellValue(student['name']?.toString() ?? ''),
          IntCellValue(pgScore),
          IntCellValue(essayScore),
          IntCellValue(finalScore),
          TextCellValue(statusText)
        ]);

        int rowIndex = 6 + i;

        // Apply Styles
        sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).cellStyle = centerStyle;
        sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex)).cellStyle = centerStyle;
        sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex)).cellStyle = leftStyle;
        sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex)).cellStyle = centerStyle;
        sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex)).cellStyle = centerStyle;
        sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex)).cellStyle = centerStyle;
        sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex)).cellStyle = isPass ? passStyle : failStyle;
      }

      // Determine Downloads path on Windows
      String? userProfile = Platform.environment['USERPROFILE'];
      if (userProfile == null) return null;

      final downloadPath = '$userProfile\\Downloads';
      final cleanExam = examName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      final cleanClass = className.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      final fileFullName = 'Attend_Rekap_${cleanExam}_${cleanClass}.xlsx';
      final filePath = '$downloadPath\\$fileFullName';

      // Ensure directory exists
      final dir = Directory(downloadPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final file = File(filePath);
      final fileBytes = excel.encode();
      if (fileBytes != null) {
        await file.writeAsBytes(fileBytes);
        return filePath;
      }
    } catch (e) {
      print('ExcelExportHelper Error: $e');
    }
    return null;
  }
}
