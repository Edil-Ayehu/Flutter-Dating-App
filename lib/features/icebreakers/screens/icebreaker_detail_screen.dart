import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../models/icebreaker.dart';
import '../providers/icebreaker_provider.dart';

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
                // Question card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: AppColors.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.icebreaker.category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: List.generate(
                                widget.icebreaker.difficulty,
                                (index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.icebreaker.question,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: widget.icebreaker.tags.map((tag) {
                            return Chip(
                              label: Text(
                                '#$tag',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.white.withOpacity(0.2),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Answer section
                Text(
                  hasAnswered ? 'Your Answer' : 'Your Answer',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                
                // Answer text field
                TextField(
                  controller: _answerController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Type your answer here...',
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    border: theme.inputDecorationTheme.border,
                    enabledBorder: theme.inputDecorationTheme.enabledBorder,
                    focusedBorder: theme.inputDecorationTheme.focusedBorder,
                  ),
                  style: theme.textTheme.bodyLarge,
                ),
                
                const SizedBox(height: 16),
                
                // Privacy toggle
                Row(
                  children: [
                    Switch(
                      value: _isPublic,
                      onChanged: (value) {
                        setState(() {
                          _isPublic = value;
                        });
                      },
                      activeColor: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Make answer visible to matches',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () => _submitAnswer(context, provider),
                    style: theme.elevatedButtonTheme.style,
                    child: _isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.onPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            hasAnswered ? 'Update Answer' : 'Save Answer',
                          ),
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
