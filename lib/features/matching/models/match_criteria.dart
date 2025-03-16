class MatchCriteria {
  final int minAge;
  final int maxAge;
  final double maxDistance;
  final List<String> interests;
  final String gender;
  final bool onlineOnly;

  MatchCriteria({
    this.minAge = 18,
    this.maxAge = 50,
    this.maxDistance = 50.0,
    this.interests = const [],
    this.gender = 'All',
    this.onlineOnly = false,
  });

  MatchCriteria copyWith({
    int? minAge,
    int? maxAge,
    double? maxDistance,
    List<String>? interests,
    String? gender,
    bool? onlineOnly,
  }) {
    return MatchCriteria(
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      maxDistance: maxDistance ?? this.maxDistance,
      interests: interests ?? this.interests,
      gender: gender ?? this.gender,
      onlineOnly: onlineOnly ?? this.onlineOnly,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'minAge': minAge,
      'maxAge': maxAge,
      'maxDistance': maxDistance,
      'interests': interests,
      'gender': gender,
      'onlineOnly': onlineOnly,
    };
  }

  factory MatchCriteria.fromMap(Map<String, dynamic> map) {
    return MatchCriteria(
      minAge: map['minAge'] ?? 18,
      maxAge: map['maxAge'] ?? 50,
      maxDistance: map['maxDistance'] ?? 50.0,
      interests: List<String>.from(map['interests'] ?? []),
      gender: map['gender'] ?? 'All',
      onlineOnly: map['onlineOnly'] ?? false,
    );
  }
}
