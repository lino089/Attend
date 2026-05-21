class TeacherProfileModel {
  final String name;
  final String subject; // Mata pelajaran yang diajar
  final String? photoUrl; // URL foto profil (nullable)

  TeacherProfileModel({
    required this.name,
    required this.subject,
    this.photoUrl,
  });

  // TODO: Add toJson method for database integration
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subject': subject,
      'photoUrl': photoUrl,
    };
  }

  // TODO: Add fromJson method for database integration
  factory TeacherProfileModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileModel(
      name: json['name'] as String,
      subject: json['subject'] as String,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  TeacherProfileModel copyWith({
    String? name,
    String? subject,
    String? photoUrl,
  }) {
    return TeacherProfileModel(
      name: name ?? this.name,
      subject: subject ?? this.subject,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
