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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryLight;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.interests,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.white,
          ),
        ),
        backgroundColor: isDarkMode ? AppColors.cardDark : AppColors.primary,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode 
                ? [AppColors.cardDark, AppColors.backgroundDark]
                : [Colors.white, Colors.grey.shade50],
            stops: const [0.0, 0.3],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What are you into?',
                      style: AppTextStyles.h2Light.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select at least 3 interests',
                      style: AppTextStyles.bodyMediumLight.copyWith(
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Counter showing selected interests
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDarkMode 
                            ? AppColors.primary.withOpacity(0.15)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${provider.interests.length} selected',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Expanded(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _availableInterests.map((interest) {
                          final isSelected = provider.interests.contains(interest);
                          return AnimatedScale(
                            scale: isSelected ? 1.05 : 1.0,
                            duration: const Duration(milliseconds: 150),
                            child: FilterChip(
                              label: Text(interest),
                              selected: isSelected,
                              onSelected: (_) => provider.toggleInterest(interest),
                              backgroundColor: isDarkMode 
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                              selectedColor: isDarkMode
                                  ? AppColors.primary.withOpacity(0.3)
                                  : AppColors.primaryLight,
                              checkmarkColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: isSelected 
                                    ? AppColors.primary
                                    : isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: isSelected 
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              elevation: isSelected ? 2 : 0,
                              pressElevation: 0,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: provider.interests.length >= 3
                    ? () => Navigator.pushNamed(context, RouteNames.locationPermission)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: isDarkMode 
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  disabledForegroundColor: isDarkMode
                      ? Colors.grey.shade600
                      : Colors.grey.shade500,
                ),
                child: Text(
                  AppStrings.next,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
