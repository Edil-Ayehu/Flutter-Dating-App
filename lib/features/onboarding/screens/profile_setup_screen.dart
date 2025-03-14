import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/string_constants.dart';
import '../../../core/constants/text_styles.dart';
import '../../../routes/route_names.dart';
import '../providers/onboarding_provider.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.createProfile),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us about yourself',
              style: AppTextStyles.h2Light,
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                labelText: AppStrings.name,
              ),
              onChanged: provider.updateName,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: AppStrings.bio,
              ),
              maxLines: 3,
              onChanged: provider.updateBio,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: AppStrings.gender,
              ),
              items: [
                AppStrings.male,
                AppStrings.female,
                AppStrings.other,
              ].map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender),
              )).toList(),
              onChanged: (value) => provider.updateGender(value ?? ''),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                RouteNames.photoUpload,
              ),
              child: Text(AppStrings.next),
            ),
          ],
        ),
      ),
    );
  }
}
