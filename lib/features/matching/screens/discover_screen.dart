import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/text_styles.dart';
import '../../../shared/layouts/main_layout.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final List<Map<String, dynamic>> _dummyProfiles = [
    {
      'name': 'Jessica, 26',
      'distance': '3 miles away',
      'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      'bio': 'Love hiking and outdoor adventures. Looking for someone to explore with!',
      'interests': ['Hiking', 'Photography', 'Travel']
    },
    {
      'name': 'Michael, 28',
      'distance': '5 miles away',
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
      'bio': 'Coffee enthusiast and book lover. Let\'s chat about our favorite novels!',
      'interests': ['Reading', 'Coffee', 'Music']
    },
    {
      'name': 'Sophia, 24',
      'distance': '2 miles away',
      'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      'bio': 'Foodie and yoga instructor. Always looking for new restaurants to try!',
      'interests': ['Yoga', 'Cooking', 'Restaurants']
    },
  ];

  int _currentProfileIndex = 0;

  void _nextProfile() {
    setState(() {
      if (_currentProfileIndex < _dummyProfiles.length - 1) {
        _currentProfileIndex++;
      }
    });
  }

  void _previousProfile() {
    setState(() {
      if (_currentProfileIndex > 0) {
        _currentProfileIndex--;
      }
    });
  }

  void _likeProfile() {
    // Handle like logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You liked ${_dummyProfiles[_currentProfileIndex]['name']}!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
    _nextProfile();
  }

  void _dislikeProfile() {
    // Handle dislike logic
    _nextProfile();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final profile = _dummyProfiles[_currentProfileIndex];
    
    return MainLayout(
      currentIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Discover',
            style: TextStyle(
              color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // Navigate to filter screen
              },
            ),
          ],
          backgroundColor: isDarkMode ? AppColors.backgroundDark : Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // Profile image
                        Positioned.fill(
                          child: Image.network(
                            profile['image'],
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
                        ),
                        
                        // Gradient overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                                stops: const [0.6, 1.0],
                              ),
                            ),
                          ),
                        ),
                        
                        // Profile info
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile['name'],
                                  style: AppTextStyles.h2Light.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profile['distance'],
                                  style: AppTextStyles.bodyMediumLight.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  profile['bio'],
                                  style: AppTextStyles.bodyMediumLight.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: (profile['interests'] as List<String>).map((interest) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        interest,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(
                    icon: Icons.close,
                    color: Colors.red,
                    onPressed: _dislikeProfile,
                  ),
                  _actionButton(
                    icon: Icons.favorite,
                    color: AppColors.primary,
                    size: 64,
                    onPressed: _likeProfile,
                  ),
                  _actionButton(
                    icon: Icons.star,
                    color: Colors.amber,
                    onPressed: () {
                      // Super like
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    double size = 56,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
