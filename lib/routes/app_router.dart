import 'package:flutter/material.dart';
import 'package:flutter_dating_app/features/auth/screens/forgot_password_screen.dart';
import 'package:flutter_dating_app/features/auth/screens/login_screen.dart';
import 'package:flutter_dating_app/features/auth/screens/registeration_screen.dart';
import 'package:flutter_dating_app/features/auth/screens/verification_screen.dart';
import 'package:flutter_dating_app/features/chat/screens/chat_list_screens.dart';
import 'package:flutter_dating_app/features/matching/models/match_result.dart';
import 'package:flutter_dating_app/features/splash/screens/splash_screen.dart';
import 'package:flutter_dating_app/features/matching/screens/discover_screen.dart';
import 'package:flutter_dating_app/features/profile/screens/profile_screen.dart';
import 'package:flutter_dating_app/features/notifications/screens/notifications_screen.dart';
import 'route_names.dart';
import '../features/onboarding/screens/welcome_screen.dart';
import '../features/onboarding/screens/profile_setup_screen.dart';
import '../features/onboarding/screens/photo_upload_screen.dart';
import '../features/onboarding/screens/interests_screen.dart';
import '../features/onboarding/screens/location_permission_screen.dart';
import '../features/matching/screens/filter_screen.dart';
import '../features/matching/screens/match_details_screen.dart';



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

            case RouteNames.signup:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
        
      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
        
      case RouteNames.verification:
        return MaterialPageRoute(builder: (_) => const VerificationScreen());
      
      case RouteNames.onboarding:
        return MaterialPageRoute(builder: (_) => const ProfileSetupScreen());
      
      case RouteNames.photoUpload:
        return MaterialPageRoute(builder: (_) => const PhotoUploadScreen());
      
      case RouteNames.interests:
        return MaterialPageRoute(builder: (_) => const InterestsScreen());
      
      case RouteNames.locationPermission:
        return MaterialPageRoute(builder: (_) => const LocationPermissionScreen());
      
      // Main app routes
      case RouteNames.discover:
        return MaterialPageRoute(builder: (_) => const DiscoverScreen());
        
      case RouteNames.chatList:
        return MaterialPageRoute(builder: (_) => const ChatListScreen());
        
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
        
      case RouteNames.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      
      case RouteNames.filter:
        return MaterialPageRoute(builder: (_) => const FilterScreen());
        
      case RouteNames.matchDetails:
        final MatchResult match = settings.arguments as MatchResult;
        return MaterialPageRoute(builder: (_) => MatchDetailsScreen(match: match));
      
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
