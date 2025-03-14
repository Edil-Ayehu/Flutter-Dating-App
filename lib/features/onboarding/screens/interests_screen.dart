import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/string_constants.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/constants/color_constants.dart';
import '../../../routes/route_names.dart';
import '../providers/onboarding_provider.dart';

class InterestsScreen extends StatelessWidget {
  const InterestsScreen({Key? key}) : super(key: key);

  static const List<String> _availableInterests = [
    'Travel', 'Music', 'Food', 'Sports', 'Art',
    'Reading', 'Gaming', 'Movies', 'Fitness', 'Photography',
    'Dancing', 'Cooking', 'Nature', 'Technology', 'Fashion'
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.interests),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What are you into?',
                    style: AppTextStyles.h2Light,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select at least 3 interests',
                    style: AppTextStyles.bodyMediumLight,
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableInterests.map((interest) {
                        final isSelected = provider.interests.contains(interest);
                        return FilterChip(
                          label: Text(interest),
                          selected: isSelected,
                          onSelected: (_) => provider.toggleInterest(interest),
                          backgroundColor: Colors.grey[200],
                          selectedColor: AppColors.primaryLight,
                          checkmarkColor: AppColors.primary,
                          labelStyle: AppTextStyles.bodyMediumLight.copyWith(
                            color: isSelected ? AppColors.primary : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: provider.interests.length >= 3
                  ? () => Navigator.pushNamed(context, RouteNames.locationPermission)
                  : null,
              child: Text(AppStrings.next),
            ),
          ),
        ],
      ),
    );
  }
}
