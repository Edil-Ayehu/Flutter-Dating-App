import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/text_styles.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../routes/route_names.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Dummy user data
    final Map<String, dynamic> user = {
      'name': 'Alex Johnson',
      'age': 27,
      'location': 'New York, NY',
      'bio': 'Adventure seeker and coffee enthusiast. Love hiking, photography, and trying new restaurants.',
      'images': [
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d',
        'https://images.unsplash.com/photo-1534030347209-467a5b0ad3e6',
      ],
      'interests': ['Hiking', 'Photography', 'Travel', 'Coffee', 'Cooking', 'Music'],
      'occupation': 'Software Developer',
      'education': 'Stanford University',
    };
    
    return MainLayout(
      currentIndex: 2,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: isDarkMode ? AppColors.backgroundDark : Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Profile image
                    Image.network(
                      user['images'][0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.7, 1.0],
                        ),
                      ),
                    ),
                    // Profile info at bottom
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user['name']}, ${user['age']}',
                            style: AppTextStyles.h1Light.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                user['location'],
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.settings);
                  },
                ),
              ],
            ),
            
            // Profile content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Edit profile button
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.editProfile);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // About section
                    Text(
                      'About',
                      style: AppTextStyles.h3Light.copyWith(
                        color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user['bio'],
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Interests section
                    Text(
                      'Interests',
                      style: AppTextStyles.h3Light.copyWith(
                        color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (user['interests'] as List<String>).map((interest) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.primary.withOpacity(0.2)
                                : AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                                                        interest,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Basic info section
                    Text(
                      'Basic Info',
                      style: AppTextStyles.h3Light.copyWith(
                        color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _infoItem(
                      icon: Icons.work_outline,
                      label: 'Occupation',
                      value: user['occupation'],
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 8),
                    _infoItem(
                      icon: Icons.school_outlined,
                      label: 'Education',
                      value: user['education'],
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 8),
                    _infoItem(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      value: user['location'],
                      isDarkMode: isDarkMode,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Settings button
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.settings);
                      },
                      icon: const Icon(Icons.settings_outlined),
                      label: const Text('Settings'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                        side: BorderSide(
                          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                    
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _infoItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}
