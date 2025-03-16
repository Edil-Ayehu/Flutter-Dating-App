import 'package:flutter/material.dart';
import 'package:flutter_dating_app/features/matching/providers/matching_provider.dart';
import 'package:flutter_dating_app/features/matching/repositories/matching_repository.dart';
import 'package:flutter_dating_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter_dating_app/features/onboarding/repositories/onboarding_repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

void main() async {
  // Ensure Flutter is initialized before accessing platform channels
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences early
  try {
    final prefs = await SharedPreferences.getInstance();
    final hasWelcomeKey = prefs.containsKey('has_seen_welcome');
    final welcomeValue = prefs.getBool('has_seen_welcome');
    debugPrint('🚀 SharedPreferences initialized successfully');
    debugPrint('🔑 has_seen_welcome key exists: $hasWelcomeKey, value: $welcomeValue');
  } catch (e) {
    debugPrint('❌ SharedPreferences initialization error: $e');
  }

  final onboardingRepository = OnboardingRepository();
  final matchingRepository = MatchingRepository();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OnboardingProvider(
            repository: onboardingRepository,
          ),
        ),
         ChangeNotifierProvider(
          create: (_) => MatchingProvider(
            repository: matchingRepository,
          ),
        ),
      ],
      child: const App(),
    ),
  );
}
