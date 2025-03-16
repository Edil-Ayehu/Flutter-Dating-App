import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/match_criteria.dart';
import '../models/match_result.dart';

class MatchingRepository {
  // This will be replaced with Firebase later
  Future<List<MatchResult>> getMatches(MatchCriteria criteria) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock data - will be replaced with Firebase query
    return [
      MatchResult(
        id: '1',
        name: 'Jessica',
        age: 26,
        distance: '3 miles away',
        image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
        bio: 'Love hiking and outdoor adventures. Looking for someone to explore with!',
        interests: ['Hiking', 'Photography', 'Travel'],
        isOnline: true,
        occupation: 'Photographer',
        education: 'Art Institute',
      ),
      MatchResult(
        id: '2',
        name: 'Michael',
        age: 28,
        distance: '5 miles away',
        image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        bio: 'Coffee enthusiast and book lover. Let\'s chat about our favorite novels!',
        interests: ['Reading', 'Coffee', 'Music'],
        isOnline: false,
        occupation: 'Writer',
        education: 'NYU',
      ),
      MatchResult(
        id: '3',
        name: 'Sophia',
        age: 24,
        distance: '2 miles away',
        image: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
        bio: 'Foodie and yoga instructor. Always looking for new restaurants to try!',
        interests: ['Yoga', 'Cooking', 'Restaurants'],
        isOnline: true,
        occupation: 'Yoga Instructor',
        education: 'UCLA',
      ),
    ].where((match) {
      // Apply filters
      bool ageMatch = match.age >= criteria.minAge && match.age <= criteria.maxAge;
      bool genderMatch = criteria.gender == 'All' || criteria.gender == 'Both'; // Simplified for now
      bool onlineMatch = !criteria.onlineOnly || match.isOnline;
      
      // Simple distance check (would be more complex in real app)
      bool distanceMatch = true; // Simplified
      
      // Interest match (at least one common interest)
      bool interestMatch = criteria.interests.isEmpty || 
          criteria.interests.any((interest) => match.interests.contains(interest));
      
      return ageMatch && genderMatch && onlineMatch && distanceMatch && interestMatch;
    }).toList();
  }

  Future<void> saveMatchCriteria(MatchCriteria criteria) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('match_criteria', jsonEncode(criteria.toMap()));
  }

  Future<MatchCriteria> getMatchCriteria() async {
    final prefs = await SharedPreferences.getInstance();
    final String? criteriaJson = prefs.getString('match_criteria');
    
    if (criteriaJson == null) {
      return MatchCriteria(); // Default criteria
    }
    
    try {
      return MatchCriteria.fromMap(jsonDecode(criteriaJson));
    } catch (e) {
      return MatchCriteria(); // Default on error
    }
  }

  Future<void> likeProfile(String profileId) async {
    // Will be implemented with Firebase
    await Future.delayed(const Duration(milliseconds: 300));
    // This is where you'd record the like in Firebase
  }

  Future<void> dislikeProfile(String profileId) async {
    // Will be implemented with Firebase
    await Future.delayed(const Duration(milliseconds: 300));
    // This is where you'd record the dislike in Firebase
  }

  Future<void> superLikeProfile(String profileId) async {
    // Will be implemented with Firebase
    await Future.delayed(const Duration(milliseconds: 300));
    // This is where you'd record the super like in Firebase
  }
}
