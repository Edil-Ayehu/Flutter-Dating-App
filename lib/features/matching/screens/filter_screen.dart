import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../models/match_criteria.dart';
import '../providers/matching_provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late MatchCriteria _criteria;
  final List<String> _allInterests = [
    'Travel', 'Music', 'Food', 'Sports', 'Art', 'Reading', 
    'Movies', 'Photography', 'Fitness', 'Cooking', 'Dancing', 
    'Hiking', 'Gaming', 'Yoga', 'Fashion', 'Technology'
  ];

  @override
  void initState() {
    super.initState();
    _criteria = Provider.of<MatchingProvider>(context, listen: false).criteria;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Filter',
          style: TextStyle(
            color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? AppColors.backgroundDark : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDarkMode ? Colors.white : Colors.grey.shade800,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: Text(
              'Reset',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Age Range
            _buildSectionTitle('Age Range'),
            const SizedBox(height: 8),
            RangeSlider(
              values: RangeValues(_criteria.minAge.toDouble(), _criteria.maxAge.toDouble()),
              min: 18,
              max: 70,
              divisions: 52,
              activeColor: AppColors.primary,
              inactiveColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
              labels: RangeLabels(
                '${_criteria.minAge}',
                '${_criteria.maxAge}',
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _criteria = _criteria.copyWith(
                    minAge: values.start.round(),
                    maxAge: values.end.round(),
                  );
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_criteria.minAge} years',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    '${_criteria.maxAge} years',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Distance
            _buildSectionTitle('Maximum Distance'),
            const SizedBox(height: 8),
            Slider(
              value: _criteria.maxDistance,
              min: 1,
              max: 100,
              divisions: 99,
              activeColor: AppColors.primary,
              inactiveColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
              label: '${_criteria.maxDistance.round()} miles',
              onChanged: (value) {
                setState(() {
                  _criteria = _criteria.copyWith(maxDistance: value);
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1 mile',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    '${_criteria.maxDistance.round()} miles',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '100 miles',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Gender
            _buildSectionTitle('Gender'),
            const SizedBox(height: 12),
            _buildGenderSelector(isDarkMode),
            
            const SizedBox(height: 24),
            
            // Online Status
            _buildSectionTitle('Online Status'),
            const SizedBox(height: 12),
            SwitchListTile(
              title: Text(
                'Show only online users',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: _criteria.onlineOnly,
              activeColor: AppColors.primary,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              onChanged: (value) {
                setState(() {
                  _criteria = _criteria.copyWith(onlineOnly: value);
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Interests
            _buildSectionTitle('Interests'),
            const SizedBox(height: 12),
            _buildInterestsSelector(isDarkMode),
            
            const SizedBox(height: 40),
            
            // Apply button
            CustomButton(
              text: 'Apply Filters',
              onPressed: _applyFilters,
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Text(
      title,
      style: TextStyle(
        color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildGenderSelector(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: _buildGenderOption('Women', 'Women', isDarkMode),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGenderOption('Men', 'Men', isDarkMode),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGenderOption('All', 'All', isDarkMode),
        ),
      ],
    );
  }

  Widget _buildGenderOption(String value, String label, bool isDarkMode) {
    final isSelected = _criteria.gender == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _criteria = _criteria.copyWith(gender: value);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary.withOpacity(isDarkMode ? 0.2 : 0.1)
              : isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? AppColors.primary
                : (isDarkMode ? Colors.white : AppColors.textPrimaryLight),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildInterestsSelector(bool isDarkMode) {
    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: _allInterests.map((interest) {
        final isSelected = _criteria.interests.contains(interest);
        
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _criteria = _criteria.copyWith(
                  interests: List.from(_criteria.interests)..remove(interest),
                );
              } else {
                _criteria = _criteria.copyWith(
                  interests: List.from(_criteria.interests)..add(interest),
                );
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.primary.withOpacity(isDarkMode ? 0.2 : 0.1)
                  : isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              interest,
              style: TextStyle(
                color: isSelected 
                    ? AppColors.primary
                    : (isDarkMode ? Colors.white : AppColors.textPrimaryLight),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _resetFilters() {
    setState(() {
      _criteria = MatchCriteria();
    });
  }

  void _applyFilters() {
    final provider = Provider.of<MatchingProvider>(context, listen: false);
    provider.updateCriteria(_criteria);
    Navigator.pop(context);
  }
}
