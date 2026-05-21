import 'package:flutter/material.dart';

enum ScheduleStructure { none, fixed, rolling }

class ScheduleConfigService extends ChangeNotifier {
  // Singleton Pattern
  static final ScheduleConfigService _instance = ScheduleConfigService._internal();
  factory ScheduleConfigService() => _instance;
  ScheduleConfigService._internal();

  ScheduleStructure _structure = ScheduleStructure.none;
  List<String> _patternNames = ['Minggu Jurusan', 'Minggu Normada'];
  String _rotationDuration = 'Setiap 2 Minggu';
  DateTime _startDate = DateTime.now();

  // Getters
  ScheduleStructure get structure => _structure;
  List<String> get patternNames => _patternNames;
  String get rotationDuration => _rotationDuration;
  DateTime get startDate => _startDate;

  bool get isConfigured => _structure != ScheduleStructure.none;
  bool get isRolling => _structure == ScheduleStructure.rolling;
  bool get isFixed => _structure == ScheduleStructure.fixed;

  // Setters & Actions
  void setStructure(ScheduleStructure newStructure) {
    if (_structure != newStructure) {
      _structure = newStructure;
      notifyListeners();
    }
  }

  void configureRolling({
    required List<String> patternNames,
    required String rotationDuration,
    required DateTime startDate,
  }) {
    _structure = ScheduleStructure.rolling;
    _patternNames = List.from(patternNames);
    _rotationDuration = rotationDuration;
    _startDate = startDate;
    notifyListeners();
  }

  void resetConfig() {
    _structure = ScheduleStructure.none;
    _patternNames = ['Minggu Jurusan', 'Minggu Normada'];
    _rotationDuration = 'Setiap 2 Minggu';
    _startDate = DateTime.now();
    notifyListeners();
  }
}
