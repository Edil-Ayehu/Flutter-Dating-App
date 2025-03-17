import 'package:flutter/material.dart';
import 'package:flutter_dating_app/features/profile/prodivers/profile_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/widgets/custom_button.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _isLoading = false;
  int _selectedPlanIndex = 1; // Default to the middle plan

  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'Monthly',
      'price': 14.99,
      'period': 'month',
      'savings': '0%',
      'popular': false,
    },
    {
      'name': '6 Months',
      'price': 9.99,
      'period': 'month',
      'savings': '33%',
      'popular': true,
    },
    {
      'name': 'Yearly',
      'price': 7.99,
      'period': 'month',
      'savings': '47%',
      'popular': false,
    },
  ];

  Future<void> _upgradeToPremium() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await provider.upgradeToPremium();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully upgraded to Premium!'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final provider = Provider.of<ProfileProvider>(context);
    final isPremium = provider.isPremium;
    
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Premium',
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Premium icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.diamond,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Title
                  Center(
                    child: Text(
                      isPremium ? 'You are a Premium Member' : 'Upgrade to Premium',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Subtitle
                  Center(
                    child: Text(
                      isPremium 
                          ? 'Enjoy all premium features' 
                          : 'Unlock all features and get more matches',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Features list
                  if (!isPremium) ...[
                    _buildFeatureItem(
                      icon: Icons.visibility,
                      title: 'See who likes you',
                      description: 'Know who\'s interested before you swipe',
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      icon: Icons.location_on,
                      title: 'Global Dating',
                      description: 'Match with people from around the world',
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      icon: Icons.star,
                      title: 'Unlimited Likes',
                      description: 'No daily limit on likes',
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      icon: Icons.undo,
                      title: 'Rewind Feature',
                      description: 'Go back to profiles you accidentally passed',
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      icon: Icons.visibility_off,
                      title: 'Incognito Mode',
                      description: 'Browse profiles without being seen',
                      isDarkMode: isDarkMode,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Subscription plans
                    Text(
                      'Choose a Plan',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Plan cards
                    Row(
                      children: List.generate(_plans.length, (index) {
                        final plan = _plans[index];
                        final isSelected = _selectedPlanIndex == index;
                        
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPlanIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: index < _plans.length - 1 ? 8 : 0,
                                left: index > 0 ? 8 : 0,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withOpacity(isDarkMode ? 0.2 : 0.1)
                                    : isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  if (plan['popular'] == true)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'POPULAR',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  Text(
                                    plan['name'],
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '\$${plan['price']}',
                                          style: TextStyle(
                                            color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '/${plan['period']}',
                                          style: TextStyle(
                                            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (plan['savings'] != '0%') ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Save ${plan['savings']}',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Subscribe button
                    CustomButton(
                      text: 'Subscribe Now',
                      onPressed: _isLoading ? null : _upgradeToPremium,
                      isLoading: _isLoading,
                      type: ButtonType.primary,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Terms text
                    Center(
                      child: Text(
                        'By subscribing, you agree to our Terms of Service and Privacy Policy',
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ] else ...[
                    // Already premium content
                    CustomButton(
                      text: 'Manage Subscription',
                      onPressed: () {
                        // Navigate to subscription management
                      },
                      type: ButtonType.secondary,
                    ),
                  ],
                ],
              ),
            ),
    );
  }
  
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
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
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
