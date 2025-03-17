class ProfilePhoto {
  final String id;
  final String url;
  final bool isPrimary;
  final DateTime uploadDate;

  ProfilePhoto({
    required this.id,
    required this.url,
    this.isPrimary = false,
    required this.uploadDate,
  });

  factory ProfilePhoto.fromMap(Map<String, dynamic> map) {
    return ProfilePhoto(
      id: map['id'] ?? '',
      url: map['url'] ?? '',
      isPrimary: map['isPrimary'] ?? false,
      uploadDate: DateTime.parse(map['uploadDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'isPrimary': isPrimary,
      'uploadDate': uploadDate.toIso8601String(),
    };
  }

  ProfilePhoto copyWith({
    String? id,
    String? url,
    bool? isPrimary,
    DateTime? uploadDate,
  }) {
    return ProfilePhoto(
      id: id ?? this.id,
      url: url ?? this.url,
      isPrimary: isPrimary ?? this.isPrimary,
      uploadDate: uploadDate ?? this.uploadDate,
    );
  }
}
