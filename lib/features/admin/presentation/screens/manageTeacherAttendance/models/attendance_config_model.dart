class AttendanceConfig {
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final String qrToken;
  final DateTime? generatedAt;
  final String schoolName;
  final String checkInTime;
  final String checkOutTime;
  final bool isConfigured;

  AttendanceConfig({
    this.latitude = -7.7956,
    this.longitude = 110.3695,
    this.radiusMeters = 50.0,
    this.qrToken = '',
    this.generatedAt,
    this.schoolName = '',
    this.checkInTime = '07:00',
    this.checkOutTime = '15:00',
    this.isConfigured = false,
  });

  AttendanceConfig copyWith({
    double? latitude,
    double? longitude,
    double? radiusMeters,
    String? qrToken,
    DateTime? generatedAt,
    String? schoolName,
    String? checkInTime,
    String? checkOutTime,
    bool? isConfigured,
  }) {
    return AttendanceConfig(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      qrToken: qrToken ?? this.qrToken,
      generatedAt: generatedAt ?? this.generatedAt,
      schoolName: schoolName ?? this.schoolName,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      isConfigured: isConfigured ?? this.isConfigured,
    );
  }
}
