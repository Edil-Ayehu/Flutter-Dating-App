import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _hasSeenWelcomeKey = 'has_seen_welcome';


  // Check if user has seen the welcome screen
  static Future<bool> hasSeenWelcome() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = prefs.getBool(_hasSeenWelcomeKey) ?? false;
      debugPrint('🔍 hasSeenWelcome check: $result');
      return result;
    } catch (e) {
      debugPrint('❌ Error checking welcome screen status: $e');
      return false;
    }
  }

  // Mark welcome screen as seen
  static Future<void> setWelcomeSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hasSeenWelcomeKey, true);
      // Verify it was set correctly
      final wasSet = prefs.getBool(_hasSeenWelcomeKey) ?? false;
      debugPrint('✅ Welcome screen marked as seen: $wasSet');
    } catch (e) {
      debugPrint('❌ Error setting welcome screen as seen: $e');
    }
  }

  // Reset welcome screen (for testing)
  static Future<void> resetWelcomeSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hasSeenWelcomeKey, false);
      debugPrint('🔄 Welcome screen preference reset');
    } catch (e) {
      debugPrint('❌ Error resetting welcome screen status: $e');
    }
  }
}