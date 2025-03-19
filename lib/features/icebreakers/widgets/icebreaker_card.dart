import 'package:flutter/material.dart';
import '../models/icebreaker.dart';

class IcebreakerCard extends StatelessWidget {
  final Icebreaker icebreaker;
  final String? answer;
  final VoidCallback? onTap;
  final bool isCompact;
  
  const IcebreakerCard({
    Key? key,
    required this.icebreaker,
    this.answer,
    this.onTap,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(icebreaker.category).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      icebreaker.category,
                      style: TextStyle(
                        color: _getCategoryColor(icebreaker.category),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: List.generate(
                      icebreaker.difficulty,
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                icebreaker.question,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: isCompact ? 2 : null,
                overflow: isCompact ? TextOverflow.ellipsis : null,
              ),
              if (answer != null && (!isCompact || answer!.length < 50)) ...[
                const SizedBox(height: 16),
                Divider(
                  color: Colors.grey.shade300
                ),
                const SizedBox(height: 8),
                Text(
                  'Your Answer:',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  answer!,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                  maxLines: isCompact ? 2 : null,
                  overflow: isCompact ? TextOverflow.ellipsis : null,
                ),
              ],
              if (!isCompact) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: icebreaker.tags.map((tag) {
                    return Chip(
                      side: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                      label: Text(
                        '#$tag',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      backgroundColor: isDarkMode 
                          ? Colors.grey.shade700 
                          : Colors.grey.shade200,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ] else if (icebreaker.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '#${icebreaker.tags.first}${icebreaker.tags.length > 1 ? ' +${icebreaker.tags.length - 1} more' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'personal':
        return Colors.purple;
      case 'travel':
        return Colors.blue;
      case 'lifestyle':
        return Colors.green;
      case 'entertainment':
        return Colors.orange;
      case 'hypothetical':
        return Colors.red;
      default:
        return Colors.teal;
    }
  }
}
