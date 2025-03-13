import 'package:flutter/material.dart';
import 'route_names.dart';

class AppRouter {
  static String get initialRoute => RouteNames.splash;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth Routes
      // case RouteNames.splash:
      //   return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      // case RouteNames.onboarding:
      //   return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      
      // case RouteNames.login:
      //   return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      // case RouteNames.register:
      //   return MaterialPageRoute(builder: (_) => const RegisterScreen());
      
      // case RouteNames.forgotPassword:
      //   return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      
      // case RouteNames.verification:
      //   return MaterialPageRoute(builder: (_) => const VerificationScreen());
      
      // // Profile Routes
      // case RouteNames.profile:
      //   return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
      // case RouteNames.editProfile:
      //   return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      
      // case RouteNames.settings:
      //   return MaterialPageRoute(builder: (_) => const SettingsScreen());
      
      // // Main App Routes
      // case RouteNames.discover:
      //   return MaterialPageRoute(builder: (_) => const DiscoverScreen());
      
      // case RouteNames.chat:
      //   return MaterialPageRoute(builder: (_) => const ChatListScreen());
      
      // case RouteNames.chatDetail:
      //   final args = settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //     builder: (_) => ChatScreen(
      //       chatId: args['chatId'] as String,
      //       otherUser: args['otherUser'],
      //     ),
      //   );

      // Default Route (404)
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