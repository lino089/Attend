class StudentProfileModel {
  final String name;
  final String className; // Kelas (XII RPL 2)
  final String? photoUrl; // URL foto profil (nullable)

  StudentProfileModel({
    required this.name,
    required this.className,
    this.photoUrl,
  });

  // TODO: Add toJson method for database integration
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'className': className,
      'photoUrl': photoUrl,
    };
  }

  // TODO: Add fromJson method for database integration
  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      name: json['name'] as String,
      className: json['className'] as String,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  StudentProfileModel copyWith({
    String? name,
    String? className,
    String? photoUrl,
  }) {
    return StudentProfileModel(
      name: name ?? this.name,
      className: className ?? this.className,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
