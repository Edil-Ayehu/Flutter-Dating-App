import '../models/profile_details.dart';
import '../models/profile_photo.dart';

class ProfileRepository {
  // Mock data - would be replaced with API calls
  Future<ProfileDetails> getUserProfile(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock data
    return ProfileDetails(
      id: 'user123',
      name: 'Alex Johnson',
      age: 27,
      location: 'New York, NY',
      bio: 'Adventure seeker and coffee enthusiast. Love hiking, photography, and trying new restaurants.',
      interests: ['Hiking', 'Photography', 'Travel', 'Coffee', 'Cooking', 'Music'],
      occupation: 'Software Developer',
      education: 'Stanford University',
      isPremium: false,
      joinDate: DateTime(2022, 5, 15),
      preferences: {
        'showLocation': true,
        'showAge': true,
        'darkMode': true,
        'notifications': true,
        'matchAlerts': true,
        'messageAlerts': true,
      },
    );
  }

  Future<List<ProfilePhoto>> getUserPhotos(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Mock data
    return [
      ProfilePhoto(
        id: 'photo1',
        url: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        isPrimary: true,
        uploadDate: DateTime(2022, 6, 10),
      ),
      ProfilePhoto(
        id: 'photo2',
        url: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d',
        isPrimary: false,
        uploadDate: DateTime(2022, 6, 15),
      ),
      ProfilePhoto(
        id: 'photo3',
        url: 'https://images.unsplash.com/photo-1534030347209-467a5b0ad3e6',
        isPrimary: false,
        uploadDate: DateTime(2022, 7, 1),
      ),
    ];
  }

  Future<void> updateProfile(ProfileDetails profile) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    // Would update profile in backend
  }

  Future<void> updatePhotos(List<ProfilePhoto> photos) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));
    // Would update photos in backend
  }

  Future<void> updatePreferences(Map<String, bool> preferences) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // Would update preferences in backend
  }

  Future<void> upgradeToPremium() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));
    // Would upgrade user to premium in backend
  }
}
