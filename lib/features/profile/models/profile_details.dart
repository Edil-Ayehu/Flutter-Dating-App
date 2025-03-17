class ProfileDetails {
  final String id;
  final String name;
  final int age;
  final String location;
  final String bio;
  final List<String> interests;
  final String occupation;
  final String education;
  final bool isPremium;
  final DateTime joinDate;
  final Map<String, bool> preferences;

  ProfileDetails({
    required this.id,
    required this.name,
    required this.age,
    required this.location,
    required this.bio,
    required this.interests,
    required this.occupation,
    required this.education,
    this.isPremium = false,
    required this.joinDate,
    required this.preferences,
  });

  factory ProfileDetails.fromMap(Map<String, dynamic> map) {
    return ProfileDetails(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      location: map['location'] ?? '',
      bio: map['bio'] ?? '',
      interests: List<String>.from(map['interests'] ?? []),
      occupation: map['occupation'] ?? '',
      education: map['education'] ?? '',
      isPremium: map['isPremium'] ?? false,
      joinDate: DateTime.parse(map['joinDate'] ?? DateTime.now().toIso8601String()),
      preferences: Map<String, bool>.from(map['preferences'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'location': location,
      'bio': bio,
      'interests': interests,
      'occupation': occupation,
      'education': education,
      'isPremium': isPremium,
      'joinDate': joinDate.toIso8601String(),
      'preferences': preferences,
    };
  }

  ProfileDetails copyWith({
    String? id,
    String? name,
    int? age,
    String? location,
    String? bio,
    List<String>? interests,
    String? occupation,
    String? education,
    bool? isPremium,
    DateTime? joinDate,
    Map<String, bool>? preferences,
  }) {
    return ProfileDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      isPremium: isPremium ?? this.isPremium,
      joinDate: joinDate ?? this.joinDate,
      preferences: preferences ?? this.preferences,
    );
  }
}
