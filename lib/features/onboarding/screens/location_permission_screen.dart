import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/constants/color_constants.dart';
import '../../../routes/route_names.dart';
import '../providers/onboarding_provider.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Enable Location',
                style: AppTextStyles.h2Light,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We use your location to show you potential matches in your area',
                style: AppTextStyles.bodyMediumLight,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () async {
                  // TODO: Implement actual location permission request
                  provider.setLocationPermission(true);
                  await provider.saveOnboardingData();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteNames.home,
                    (route) => false,
                  );
                },
                child: const Text('Allow Location Access'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  provider.setLocationPermission(false);
                  await provider.saveOnboardingData();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteNames.home,
                    (route) => false,
                  );
                },
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
