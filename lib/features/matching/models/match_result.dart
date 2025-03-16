class MatchResult {
  final String id;
  final String name;
  final int age;
  final String distance;
  final String image;
  final String bio;
  final List<String> interests;
  final bool isOnline;
  final String occupation;
  final String education;

  MatchResult({
    required this.id,
    required this.name,
    required this.age,
    required this.distance,
    required this.image,
    required this.bio,
    this.interests = const [],
    this.isOnline = false,
    this.occupation = '',
    this.education = '',
  });

  MatchResult copyWith({
    String? id,
    String? name,
    int? age,
    String? distance,
    String? image,
    String? bio,
    List<String>? interests,
    bool? isOnline,
    String? occupation,
    String? education,
  }) {
    return MatchResult(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      distance: distance ?? this.distance,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      isOnline: isOnline ?? this.isOnline,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'distance': distance,
      'image': image,
      'bio': bio,
      'interests': interests,
      'isOnline': isOnline,
      'occupation': occupation,
      'education': education,
    };
  }

  factory MatchResult.fromMap(Map<String, dynamic> map) {
    return MatchResult(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      distance: map['distance'] ?? '',
      image: map['image'] ?? '',
      bio: map['bio'] ?? '',
      interests: List<String>.from(map['interests'] ?? []),
      isOnline: map['isOnline'] ?? false,
      occupation: map['occupation'] ?? '',
      education: map['education'] ?? '',
    );
  }
}
