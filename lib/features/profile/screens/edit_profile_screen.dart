import 'package:flutter/material.dart';
import 'package:flutter_dating_app/features/profile/prodivers/profile_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/widgets/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

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
    
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50,
                ),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Age slider
              Text(
                'Age: $_age',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '18',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _age.toDouble(),
                      min: 18,
                      max: 80,
                      divisions: 62,
                      activeColor: AppColors.primary,
                      inactiveColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                      label: _age.toString(),
                      onChanged: (value) {
                        setState(() {
                          _age = value.round();
                        });
                      },
                    ),
                  ),
                  Text(
                    '80',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Bio field
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50,
                ),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              // Location field
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50,
                ),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              // Occupation field
              TextFormField(
                controller: _occupationController,
                decoration: InputDecoration(
                  labelText: 'Occupation',
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50,
                ),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              // Education field
              TextFormField(
                controller: _educationController,
                decoration: InputDecoration(
                  labelText: 'Education',
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50,
                ),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 32),

              // Save button
              CustomButton(
                text: 'Save Changes',
                onPressed: _isLoading ? null : _saveProfile,
                isLoading: _isLoading,
                type: ButtonType.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
