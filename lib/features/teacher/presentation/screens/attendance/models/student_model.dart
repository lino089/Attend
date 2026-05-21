class Student {
  final String id;
  final String name;
  final String nis;
  final int absenceNumber; // Nomor absen siswa
  final String? photoUrl;
  String status; // 'none', 'H', 'S', 'I', 'A'

  Student({
    required this.id,
    required this.name,
    required this.nis,
    required this.absenceNumber,
    this.photoUrl,
    this.status = 'none',
  });

  // Convert to JSON for database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nis': nis,
      'absenceNumber': absenceNumber,
      'photoUrl': photoUrl,
      'status': status,
    };
  }

  // Create from JSON from database
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      name: json['name'] as String,
      nis: json['nis'] as String,
      absenceNumber: json['absenceNumber'] as int,
      photoUrl: json['photoUrl'] as String?,
      status: json['status'] as String? ?? 'none',
    );
  }

  // Copy with method for state updates
  Student copyWith({
    String? id,
    String? name,
    String? nis,
    int? absenceNumber,
    String? photoUrl,
    String? status,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      nis: nis ?? this.nis,
      absenceNumber: absenceNumber ?? this.absenceNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
    );
  }
}
