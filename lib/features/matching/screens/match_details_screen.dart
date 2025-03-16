import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../models/match_result.dart';

class MatchDetailsScreen extends StatelessWidget {
  final MatchResult match;
  
  const MatchDetailsScreen({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with profile image
          SliverAppBar(
            expandedHeight: size.height * 0.5,
            pinned: true,
            backgroundColor: isDarkMode ? AppColors.backgroundDark : Colors.white,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode 
                    ? Colors.black.withOpacity(0.3) 
                    : Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'profile-${match.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Profile image
                    Image.network(
                      match.image,
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
                    // Gradient overlay for better text visibility
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
                    // Name and basic info at bottom
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
                                '${match.name}, ${match.age}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (match.isOnline)
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
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
                                match.distance,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
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
            ),
          ),
          
          // Profile details
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bio section
                  Text(
                    'About',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    match.bio,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Interests section
                  Text(
                    'Interests',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: match.interests.map((interest) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDarkMode 
                              ? AppColors.primary.withOpacity(0.2) 
                              : AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          interest,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Basic info section
                  if (match.occupation.isNotEmpty || match.education.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Basic Info',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                            fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (match.occupation.isNotEmpty)
                          _buildInfoItem(
                            icon: Icons.work_outline,
                            label: match.occupation,
                            isDarkMode: isDarkMode,
                          ),
                        if (match.education.isNotEmpty)
                          _buildInfoItem(
                            icon: Icons.school_outlined,
                            label: match.education,
                            isDarkMode: isDarkMode,
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.close_rounded,
                        color: Colors.red,
                        label: 'Pass',
                        onPressed: () {
                          Navigator.pop(context, 'dislike');
                        },
                        isDarkMode: isDarkMode,
                      ),
                      _buildActionButton(
                        icon: Icons.favorite_rounded,
                        color: AppColors.primary,
                        label: 'Like',
                        onPressed: () {
                          Navigator.pop(context, 'like');
                        },
                        isDarkMode: isDarkMode,
                        isLarge: true,
                      ),
                      _buildActionButton(
                        icon: Icons.star_rounded,
                        color: Colors.amber,
                        label: 'Super Like',
                        onPressed: () {
                          Navigator.pop(context, 'superlike');
                        },
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
    required bool isDarkMode,
    bool isLarge = false,
  }) {
    final size = isLarge ? 64.0 : 56.0;
    
    return Column(
      children: [
        Container(
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
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
