import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

class CaptionDialog extends StatefulWidget {
  const CaptionDialog({super.key});

  @override
  State<CaptionDialog> createState() => _CaptionDialogState();
}

class _CaptionDialogState extends State<CaptionDialog> {
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.photo_camera_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  'Add a caption',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(
                hintText: 'Write something about this...',
                hintStyle: TextStyle(
                  color: isDarkMode
                      ? Colors.grey.shade400
                      : Colors.grey.shade500,
                ),
                filled: true,
                fillColor:
                    isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 15,
              ),
              maxLines: 3,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context, _captionController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper method to show the dialog and return the caption
Future<String?> showCaptionDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (context) => const CaptionDialog(),
  );
}
