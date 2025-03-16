import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/text_styles.dart';
import '../../../shared/layouts/main_layout.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _dummyProfiles = [
    {
      'name': 'Jessica',
      'age': 26,
      'distance': '3 miles away',
      'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      'bio': 'Love hiking and outdoor adventures. Looking for someone to explore with!',
      'interests': ['Hiking', 'Photography', 'Travel']
    },
    {
      'name': 'Michael',
      'age': 28,
      'distance': '5 miles away',
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
      'bio': 'Coffee enthusiast and book lover. Let\'s chat about our favorite novels!',
      'interests': ['Reading', 'Coffee', 'Music']
    },
    {
      'name': 'Sophia',
      'age': 24,
      'distance': '2 miles away',
      'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      'bio': 'Foodie and yoga instructor. Always looking for new restaurants to try!',
      'interests': ['Yoga', 'Cooking', 'Restaurants']
    },
  ];

  int _currentProfileIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuint),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextProfile() {
    if (_isAnimating) return;
    
    setState(() {
      _isAnimating = true;
    });
    
    _animationController.forward().then((_) {
      setState(() {
        if (_currentProfileIndex < _dummyProfiles.length - 1) {
          _currentProfileIndex++;
        }
        _isAnimating = false;
      });
      _animationController.reset();
    });
  }

  void _previousProfile() {
    if (_isAnimating) return;
    
    setState(() {
      _isAnimating = true;
    });
    
    _animationController.forward().then((_) {
      setState(() {
        if (_currentProfileIndex > 0) {
          _currentProfileIndex--;
        }
        _isAnimating = false;
      });
      _animationController.reset();
    });
  }

  void _likeProfile() {
    // Handle like logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You liked ${_dummyProfiles[_currentProfileIndex]['name']}!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
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
    final size = MediaQuery.of(context).size;
    
    return MainLayout(
      currentIndex: 0,
      child: Scaffold(
        backgroundColor: isDarkMode ? AppColors.backgroundDark : Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            'Discover',
            style: TextStyle(
              color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.filter_list_rounded,
                color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
              ),
              onPressed: () {
                // Navigate to filter screen
              },
            ),
          ],
          backgroundColor: isDarkMode ? AppColors.backgroundDark : Colors.grey.shade50,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Hero(
                    tag: 'profile-${profile['name']}',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
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
                                      Colors.black.withOpacity(0.8),
                                    ],
                                    stops: const [0.6, 1.0],
                                  ),
                                ),
                              ),
                            ),
                            
                            // Profile info
                            Positioned(
                              left: 20,
                              right: 20,
                              bottom: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${profile['name']}, ${profile['age']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
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
                                        profile['distance'],
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    profile['bio'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
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
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          interest,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Swipe indicators
                            Positioned.fill(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: _dislikeProfile,
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(
                                      width: size.width * 0.3,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: _likeProfile,
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(
                                      width: size.width * 0.3,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Action buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade900 : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(
                    icon: Icons.close_rounded,
                    color: Colors.red,
                    onPressed: _dislikeProfile,
                    isDarkMode: isDarkMode,
                  ),
                  _actionButton(
                    icon: Icons.favorite_rounded,
                    color: AppColors.primary,
                    size: 64,
                    onPressed: _likeProfile,
                    isDarkMode: isDarkMode,
                  ),
                  _actionButton(
                    icon: Icons.star_rounded,
                    color: Colors.amber,
                    onPressed: () {
                      // Super like
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You super liked ${profile['name']}!'),
                          backgroundColor: Colors.amber,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.all(10),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                      _nextProfile();
                    },
                    isDarkMode: isDarkMode,
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
    required bool isDarkMode,
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
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
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
