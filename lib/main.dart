import 'package:flutter/material.dart';
import 'package:flutter_dating_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter_dating_app/features/onboarding/repositories/onboarding_repository.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final onboardingRepository = OnboardingRepository();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OnboardingProvider(
            repository: onboardingRepository,
          ),
        ),
      ],
      child: const App(),
    ),
  );
}
