import 'package:flutter/material.dart';
import 'package:flutter_dating_app/features/profile/prodivers/profile_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../routes/route_names.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final provider = Provider.of<ProfileProvider>(context);
    final preferences = provider.profile?.preferences ?? {};

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.grey.shade800,
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Account settings section
                _buildSectionHeader('Account Settings', isDarkMode),
                const SizedBox(height: 8),
                _buildSettingItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  subtitle: 'Update your profile information',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.editProfile);
                  },
                ),
                _buildDivider(isDarkMode),
                _buildSettingItem(
                  context,
                  icon: Icons.photo_library_outlined,
                  title: 'Manage Photos',
                  subtitle: 'Add, remove or reorder your photos',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.photoUpload);
                  },
                ),
                _buildDivider(isDarkMode),
                _buildSettingItem(
                  context,
                  icon: Icons.interests_outlined,
                  title: 'Edit Interests',
                  subtitle: 'Update your interests and hobbies',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.interests);
                  },
                ),
                _buildDivider(isDarkMode),
                _buildSettingItem(
                  context,
                  icon: Icons.diamond_outlined,
                  title: 'Premium Membership',
                  subtitle: provider.isPremium ? 'You are a premium member' : 'Upgrade to premium for more features',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.premium);
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Privacy settings section
                _buildSectionHeader('Privacy Settings', isDarkMode),
                const SizedBox(height: 8),
                _buildSwitchItem(
                  icon: Icons.location_on_outlined,
                  title: 'Show Location',
                  value: preferences['showLocation'] ?? true,
                  onChanged: (value) {
                    final newPreferences = Map<String, bool>.from(preferences);
                    newPreferences['showLocation'] = value;
                    provider.updatePreferences(newPreferences);
                  },
                  isDarkMode: isDarkMode,
                ),
                _buildDivider(isDarkMode),
                _buildSwitchItem(
                  icon: Icons.calendar_today_outlined,
                  title: 'Show Age',
                  value: preferences['showAge'] ?? true,
                  onChanged: (value) {
                    final newPreferences = Map<String, bool>.from(preferences);
                    newPreferences['showAge'] = value;
                    provider.updatePreferences(newPreferences);
                  },
                  isDarkMode: isDarkMode,
                ),
                
                const SizedBox(height: 24),
                
                // Notification settings section
                _buildSectionHeader('Notification Settings', isDarkMode),
                const SizedBox(height: 8),
                _buildSwitchItem(
                  icon: Icons.notifications_outlined,
                  title: 'Push Notifications',
                  value: preferences['notifications'] ?? true,
                  onChanged: (value) {
                    final newPreferences = Map<String, bool>.from(preferences);
                    newPreferences['notifications'] = value;
                    provider.updatePreferences(newPreferences);
                  },
                  isDarkMode: isDarkMode,
                ),
                _buildDivider(isDarkMode),
                _buildSwitchItem(
                  icon: Icons.favorite_border,
                  title: 'Match Alerts',
                  value: preferences['matchAlerts'] ?? true,
                  onChanged: (value) {
                    final newPreferences = Map<String, bool>.from(preferences);
                    newPreferences['matchAlerts'] = value;
                    provider.updatePreferences(newPreferences);
                  },
                  isDarkMode: isDarkMode,
                ),
                _buildDivider(isDarkMode),
                _buildSwitchItem(
                  icon: Icons.message_outlined,
                  title: 'Message Notifications',
                  value: preferences['messageAlerts'] ?? true,
                  onChanged: (value) {
                    final newPreferences = Map<String, bool>.from(preferences);
                    newPreferences['messageAlerts'] = value;
                    provider.updatePreferences(newPreferences);
                  },
                  isDarkMode: isDarkMode,
                ),
                
                const SizedBox(height: 24),
                
                // App settings section
                _buildSectionHeader('App Settings', isDarkMode),
                const SizedBox(height: 8),
                _buildSwitchItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  value: preferences['darkMode'] ?? false,
                  onChanged: (value) {
                    final newPreferences = Map<String, bool>.from(preferences);
                    newPreferences['darkMode'] = value;
                    provider.updatePreferences(newPreferences);
                    // Note: This doesn't actually change the theme, just updates the preference
                  },
                  isDarkMode: isDarkMode,
                ),
                
                const SizedBox(height: 24),
                
                // Account actions section
                _buildSectionHeader('Account Actions', isDarkMode),
                const SizedBox(height: 8),
                _buildSettingItem(
                  context,
                  icon: Icons.logout,
                  title: 'Log Out',
                  subtitle: 'Sign out of your account',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Log Out'),
                        content: const Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteNames.login,
                                (route) => false,
                              );
                            },
                            child: const Text('Log Out'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                _buildDivider(isDarkMode),
                _buildSettingItem(
                  context,
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account and data',
                  isDarkMode: isDarkMode,
                  isDestructive: true,
                  onTap: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Account'),
                        content: const Text(
                            'This action cannot be undone. All your data will be permanently deleted. Are you sure?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Account deletion requested'),
                                ),
                              );
                              // Navigate to login
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteNames.login,
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? AppColors.primary : AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isDestructive
                  ? Colors.red
                  : (isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDestructive
                          ? Colors.red
                          : (isDarkMode ? Colors.white : AppColors.textPrimaryLight),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                fontSize: 16,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
      height: 1,
    );
  }
}
