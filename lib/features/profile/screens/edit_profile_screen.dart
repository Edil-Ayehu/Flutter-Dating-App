import 'package:flutter/material.dart';
import 'package:flutter_dating_app/features/profile/prodivers/profile_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/widgets/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _occupationController;
  late TextEditingController _educationController;
  late TextEditingController _locationController;
  late int _age;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final profile = provider.profile;
    
    _nameController = TextEditingController(text: profile?.name ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
    _occupationController = TextEditingController(text: profile?.occupation ?? '');
    _educationController = TextEditingController(text: profile?.education ?? '');
    _locationController = TextEditingController(text: profile?.location ?? '');
    _age = profile?.age ?? 25;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _occupationController.dispose();
    _educationController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final provider = Provider.of<ProfileProvider>(context, listen: false);
      final currentProfile = provider.profile;

      if (currentProfile != null) {
        final updatedProfile = currentProfile.copyWith(
          name: _nameController.text,
          age: _age,
          bio: _bioController.text,
          occupation: _occupationController.text,
          education: _educationController.text,
          location: _locationController.text,
        );

        await provider.updateProfile(updatedProfile);
        
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? AppColors.backgroundDark : Colors.grey.shade50;
    final cardColor = isDarkMode ? Colors.grey.shade900 : Colors.white;
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimaryLight;
    final hintColor = isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: cardColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.grey.shade800,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header with avatar placeholder
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar with edit button
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: cardColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Edit Your Profile',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Form fields in cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Info Section
                    _buildSectionHeader('Basic Information', isDarkMode),
                    
                    // Name field
                    _buildCard(
                      child: _buildTextField(
                        controller: _nameController,
                        labelText: 'Name',
                        icon: Icons.person_outline,
                        isDarkMode: isDarkMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      isDarkMode: isDarkMode,
                      cardColor: cardColor,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Age slider in card
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.cake_outlined,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Age',
                                style: TextStyle(
                                  color: hintColor,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '$_age years',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4,
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                              thumbColor: AppColors.primary,
                              overlayColor: AppColors.primary.withOpacity(0.2),
                              valueIndicatorColor: AppColors.primary,
                              valueIndicatorTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Slider(
                              value: _age.toDouble(),
                              min: 18,
                              max: 80,
                              divisions: 62,
                              label: _age.toString(),
                              onChanged: (value) {
                                setState(() {
                                  _age = value.round();
                                });
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '18',
                                style: TextStyle(
                                  color: hintColor,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '80',
                                style: TextStyle(
                                  color: hintColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      isDarkMode: isDarkMode,
                      cardColor: cardColor,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // About Section
                    _buildSectionHeader('About You', isDarkMode),
                    
                    // Bio field
                    _buildCard(
                      child: _buildTextField(
                        controller: _bioController,
                        labelText: 'Bio',
                        icon: Icons.edit_note_outlined,
                        isDarkMode: isDarkMode,
                        maxLines: 4,
                        hintText: 'Tell others about yourself...',
                      ),
                      isDarkMode: isDarkMode,
                      cardColor: cardColor,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Location & Work Section
                    _buildSectionHeader('Location & Work', isDarkMode),
                    
                    // Location field
                    _buildCard(
                      child: _buildTextField(
                        controller: _locationController,
                        labelText: 'Location',
                        icon: Icons.location_on_outlined,
                        isDarkMode: isDarkMode,
                        hintText: 'City, Country',
                      ),
                      isDarkMode: isDarkMode,
                      cardColor: cardColor,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Occupation field
                    _buildCard(
                      child: _buildTextField(
                        controller: _occupationController,
                        labelText: 'Occupation',
                        icon: Icons.work_outline,
                        isDarkMode: isDarkMode,
                      ),
                      isDarkMode: isDarkMode,
                      cardColor: cardColor,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Education field
                    _buildCard(
                      child: _buildTextField(
                        controller: _educationController,
                        labelText: 'Education',
                        icon: Icons.school_outlined,
                        isDarkMode: isDarkMode,
                      ),
                      isDarkMode: isDarkMode,
                      cardColor: cardColor,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Save button
                    CustomButton(
                      text: 'Save Changes',
                      onPressed: _isLoading ? null : _saveProfile,
                      isLoading: _isLoading,
                      type: ButtonType.primary,
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildCard({
    required Widget child,
    required bool isDarkMode,
    required Color cardColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required bool isDarkMode,
    String? hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final hintColor = isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              labelText,
              style: TextStyle(
                color: hintColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400,
              fontSize: 16,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: isDarkMode ? Colors.grey.shade800.withOpacity(0.3) : Colors.grey.shade50,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
