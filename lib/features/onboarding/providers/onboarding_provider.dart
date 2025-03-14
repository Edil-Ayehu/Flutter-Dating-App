import 'package:flutter/material.dart';
import '../repositories/onboarding_repository.dart';

class OnboardingProvider extends ChangeNotifier {
  final OnboardingRepository _repository;
  
  OnboardingProvider({
    required OnboardingRepository repository,
  }) : _repository = repository;

  // User data
  String _name = '';
  String _bio = '';
  DateTime? _birthDate;
  String _gender = '';
  List<String> _interests = [];
  List<String> _photos = [];
  bool _locationPermissionGranted = false;

  // Getters
  String get name => _name;
  String get bio => _bio;
  DateTime? get birthDate => _birthDate;
  String get gender => _gender;
  List<String> get interests => _interests;
  List<String> get photos => _photos;
  bool get locationPermissionGranted => _locationPermissionGranted;

  // Setters with notification
  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  void updateBio(String bio) {
    _bio = bio;
    notifyListeners();
  }

  void updateBirthDate(DateTime date) {
    _birthDate = date;
    notifyListeners();
  }

  void updateGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void toggleInterest(String interest) {
    if (_interests.contains(interest)) {
      _interests.remove(interest);
    } else {
      _interests.add(interest);
    }
    notifyListeners();
  }

  void addPhoto(String photoUrl) {
    _photos.add(photoUrl);
    notifyListeners();
  }

  void removePhoto(String photoUrl) {
    _photos.remove(photoUrl);
    notifyListeners();
  }

  void setLocationPermission(bool granted) {
    _locationPermissionGranted = granted;
    notifyListeners();
  }

  // Save all data
  Future<void> saveOnboardingData() async {
    await _repository.saveUserData({
      'name': _name,
      'bio': _bio,
      'birthDate': _birthDate?.toIso8601String(),
      'gender': _gender,
      'interests': _interests,
      'photos': _photos,
      'locationPermissionGranted': _locationPermissionGranted,
    });
  }
}
