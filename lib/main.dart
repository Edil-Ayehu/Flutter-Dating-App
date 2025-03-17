import 'package:flutter/material.dart';
import 'package:flutter_dating_app/features/chat/providers/chat_provider.dart';
import 'package:flutter_dating_app/features/chat/repositories/chat_repository.dart';
import 'package:flutter_dating_app/features/matching/providers/matching_provider.dart';
import 'package:flutter_dating_app/features/matching/repositories/matching_repository.dart';
import 'package:flutter_dating_app/features/notifications/providers/notification_provider.dart';
import 'package:flutter_dating_app/features/notifications/repositories/notification_repository.dart';
import 'package:flutter_dating_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter_dating_app/features/onboarding/repositories/onboarding_repository.dart';
import 'package:flutter_dating_app/features/profile/prodivers/profile_provider.dart';
import 'package:flutter_dating_app/features/profile/repositories/profile_repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/providers/theme_provider.dart';

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
  final chatRepository = ChatRepository();
  final profileRepository = ProfileRepository();
  final notificationRepository = NotificationRepository();
  
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
        ChangeNotifierProvider(
          create: (_) => ChatProvider(
            repository: chatRepository,
          ),
        ),
         ChangeNotifierProvider(
          create: (_) => ProfileProvider(
            repository: profileRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(
            repository: notificationRepository,
          ),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const App(),
    ),
  );
}
