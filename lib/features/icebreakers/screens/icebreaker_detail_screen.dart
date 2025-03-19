import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/icebreaker.dart';
import '../providers/icebreaker_provider.dart';
import 'dart:ui';


class IcebreakerDetailScreen extends StatefulWidget {
  final Icebreaker icebreaker;
  
  const IcebreakerDetailScreen({
    Key? key,
    required this.icebreaker,
  }) : super(key: key);

  @override
  State<IcebreakerDetailScreen> createState() => _IcebreakerDetailScreenState();
}

class _IcebreakerDetailScreenState extends State<IcebreakerDetailScreen> {
  final TextEditingController _answerController = TextEditingController();
  bool _isPublic = true;
  bool _isSubmitting = false;
  
  @override
  void initState() {
    super.initState();
    
    // Pre-fill with existing answer if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<IcebreakerProvider>(context, listen: false);
      final answers = provider.userAnswers[widget.icebreaker.id] ?? [];
      
      if (answers.isNotEmpty) {
        _answerController.text = answers.first.answer;
        setState(() {
          _isPublic = answers.first.isPublic;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icebreaker'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
      ),
      body: Consumer<IcebreakerProvider>(
        builder: (context, provider, child) {
          final answers = provider.userAnswers[widget.icebreaker.id] ?? [];
          final hasAnswered = answers.isNotEmpty;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question card with solid color
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category and difficulty
                          Row(
                            children: [
                              // Category pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onPrimary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: theme.colorScheme.onPrimary.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  widget.icebreaker.category.toUpperCase(),
                                  style: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              // Difficulty stars
                              Row(
                                children: List.generate(
                                  5, // Total possible stars
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Icon(
                                      index < widget.icebreaker.difficulty
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      color: index < widget.icebreaker.difficulty
                                          ? Colors.amber
                                          : theme.colorScheme.onPrimary.withOpacity(0.3),
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Question text
                          Text(
                            widget.icebreaker.question,
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Tags
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.icebreaker.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onPrimary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onPrimary,
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
                ),
                
                const SizedBox(height: 32),
                
                // Answer section with subtle animation
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Your Answer',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Answer text field with enhanced styling
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode 
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _answerController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Type your answer here...',
                            filled: true,
                            fillColor: isDarkMode 
                                ? Colors.grey.shade900 
                                : Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: isDarkMode 
                                    ? Colors.grey.shade800 
                                    : Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: theme.colorScheme.primary,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(20),
                          ),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Privacy toggle with improved styling
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDarkMode 
                              ? Colors.grey.shade800.withOpacity(0.5) 
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isPublic ? Icons.visibility : Icons.visibility_off,
                              color: _isPublic 
                                  ? theme.colorScheme.primary 
                                  : theme.colorScheme.onBackground.withOpacity(0.5),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Make answer visible to matches',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Switch(
                              value: _isPublic,
                              onChanged: (value) {
                                setState(() {
                                  _isPublic = value;
                                });
                              },
                              activeColor: theme.colorScheme.primary,
                              activeTrackColor: theme.colorScheme.primary.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Submit button with animation
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isSubmitting
                              ? null
                              : () => _submitAnswer(context, provider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isSubmitting
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: theme.colorScheme.onPrimary,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      hasAnswered ? Icons.update : Icons.check_circle,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      hasAnswered ? 'Update Answer' : 'Save Answer',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Future<void> _submitAnswer(BuildContext context, IcebreakerProvider provider) async {
    if (_answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an answer')),
      );
      return;
    }
    
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      await provider.saveAnswer(
        widget.icebreaker.id,
        _answerController.text.trim(),
        isPublic: _isPublic,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Answer saved successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
