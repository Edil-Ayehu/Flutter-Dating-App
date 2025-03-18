import 'package:flutter/material.dart';
import 'package:flutter_dating_app/features/profile/prodivers/profile_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../routes/route_names.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Track loading state for individual settings
  final Map<String, bool> _loadingStates = {};

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final provider = Provider.of<ProfileProvider>(context);
    final preferences = provider.profile?.preferences ?? {};
    
    // Define colors based on theme
    final backgroundColor = isDarkMode ? AppColors.backgroundDark : Colors.grey.shade50;
    final cardColor = isDarkMode ? Colors.grey.shade900 : Colors.white;
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryLight;
    final subtitleColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: cardColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.grey.shade800,
        ),
      ),
      body: provider.isLoading && _loadingStates.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                // Account settings section
                _buildSectionCard(
                  context,
                  icon: Icons.person_outlined,
                  title: 'Account Settings',
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  children: [
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
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Privacy settings section
                _buildSectionCard(
                  context,
                  icon: Icons.shield_outlined,
                  title: 'Privacy Settings',
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  children: [
                    _buildSwitchItem(
                      key: 'showLocation',
                      icon: Icons.location_on_outlined,
                      title: 'Show Location',
                      subtitle: 'Allow others to see your location',
                      value: preferences['showLocation'] ?? true,
                      isLoading: _loadingStates['showLocation'] ?? false,
                      onChanged: (value) async {
                        await _updatePreference(provider, preferences, 'showLocation', value);
                      },
                      isDarkMode: isDarkMode,
                    ),
                    _buildDivider(isDarkMode),
                    _buildSwitchItem(
                      key: 'showAge',
                      icon: Icons.calendar_today_outlined,
                      title: 'Show Age',
                      subtitle: 'Display your age on your profile',
                      value: preferences['showAge'] ?? true,
                      isLoading: _loadingStates['showAge'] ?? false,
                      onChanged: (value) async {
                        await _updatePreference(provider, preferences, 'showAge', value);
                      },
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Notification settings section
                _buildSectionCard(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Notification Settings',
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  children: [
                    _buildSwitchItem(
                      key: 'notifications',
                      icon: Icons.notifications_outlined,
                      title: 'Push Notifications',
                      subtitle: 'Receive notifications on your device',
                      value: preferences['notifications'] ?? true,
                      isLoading: _loadingStates['notifications'] ?? false,
                      onChanged: (value) async {
                        await _updatePreference(provider, preferences, 'notifications', value);
                      },
                      isDarkMode: isDarkMode,
                    ),
                    _buildDivider(isDarkMode),
                    _buildSwitchItem(
                      key: 'matchAlerts',
                      icon: Icons.favorite_border,
                      title: 'Match Alerts',
                      subtitle: 'Get notified when you match with someone',
                      value: preferences['matchAlerts'] ?? true,
                      isLoading: _loadingStates['matchAlerts'] ?? false,
                      onChanged: (value) async {
                        await _updatePreference(provider, preferences, 'matchAlerts', value);
                      },
                      isDarkMode: isDarkMode,
                    ),
                    _buildDivider(isDarkMode),
                    _buildSwitchItem(
                      key: 'messageAlerts',
                      icon: Icons.message_outlined,
                      title: 'Message Notifications',
                      subtitle: 'Get notified when you receive messages',
                      value: preferences['messageAlerts'] ?? true,
                      isLoading: _loadingStates['messageAlerts'] ?? false,
                      onChanged: (value) async {
                        await _updatePreference(provider, preferences, 'messageAlerts', value);
                      },
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // App settings section
                _buildSectionCard(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'App Settings',
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  children: [
                    _buildSwitchItem(
                      key: 'darkMode',
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      subtitle: 'Toggle between light and dark theme',
                      value: Provider.of<ThemeProvider>(context).isDarkMode,
                      isLoading: _loadingStates['darkMode'] ?? false,
                      onChanged: (value) async {
                        Provider.of<ThemeProvider>(context, listen: false).setDarkMode(value);
                        
                        await _updatePreference(provider, preferences, 'darkMode', value);
                      },
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Account actions section
                _buildSectionCard(
                  context,
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Account Actions',
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  children: [
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: cardColor,
                            titleTextStyle: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            contentTextStyle: TextStyle(
                              color: subtitleColor,
                              fontSize: 16,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                                  ),
                                ),
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
                                child: const Text(
                                  'Log Out',
                                  style: TextStyle(color: AppColors.primary),
                                ),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: cardColor,
                            titleTextStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            contentTextStyle: TextStyle(
                              color: subtitleColor,
                              fontSize: 16,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Account deletion requested'),
                                      backgroundColor: Colors.red.shade800,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.all(16),
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
                  ],
                ),
                
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isDarkMode,
    required Color cardColor,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.zero,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Section content
            ...children,
          ],
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
      borderRadius: BorderRadius.circular(12),
      splashColor: AppColors.primary.withOpacity(0.1),
      highlightColor: AppColors.primary.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive
                    ? Colors.red
                    : AppColors.primary,
              ),
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
              color: isDestructive
                  ? Colors.red.withOpacity(0.7)
                  : (isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required String key,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required bool isDarkMode,
    required bool isLoading,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
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
          Switch(
            value: value,
            onChanged: (value) async {
              setState(() {
                _loadingStates[key] = true;
              });
              await onChanged(value);
              setState(() {
                _loadingStates[key] = false;
              });
            },
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withOpacity(0.3),
            inactiveThumbColor: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade300,
            inactiveTrackColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      color: isDarkMode ? Colors.grey.shade800.withOpacity(0.5) : Colors.grey.shade200,
      height: 1,
      thickness: 0.5,
      indent: 56,
    );
  }

  Future<void> _updatePreference(ProfileProvider provider, Map<String, dynamic> preferences, String key, bool value) async {
    // Create a new Map<String, bool> with only boolean values
    final Map<String, bool> boolPreferences = {};
    
    // Copy existing boolean preferences
    preferences.forEach((k, v) {
      if (v is bool) {
        boolPreferences[k] = v;
      }
    });
    
    // Add or update the new preference
    boolPreferences[key] = value;
    
    // Update preferences
    await provider.updatePreferences(boolPreferences);
  }
}
