import 'package:flutter/material.dart';
import 'package:flutter_dating_app/features/auth/screens/login_screen.dart';
import 'package:flutter_dating_app/features/splash/screens/splash_screen.dart';
import 'route_names.dart';
import '../features/onboarding/screens/welcome_screen.dart';
import '../features/onboarding/screens/profile_setup_screen.dart';
import '../features/onboarding/screens/photo_upload_screen.dart';
import '../features/onboarding/screens/interests_screen.dart';
import '../features/onboarding/screens/location_permission_screen.dart';

class AppRouter {
  static String get initialRoute => RouteNames.splash;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteNames.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case RouteNames.onboarding:
        return MaterialPageRoute(builder: (_) => const ProfileSetupScreen());
      
      case RouteNames.photoUpload:
        return MaterialPageRoute(builder: (_) => const PhotoUploadScreen());
      
      case RouteNames.interests:
        return MaterialPageRoute(builder: (_) => const InterestsScreen());
      
      case RouteNames.locationPermission:
        return MaterialPageRoute(builder: (_) => const LocationPermissionScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
