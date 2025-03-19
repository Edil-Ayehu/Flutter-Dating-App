import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/color_constants.dart';

class AttachmentOptions extends StatelessWidget {
  final Function(ImageSource) onImageSelected;
  final VoidCallback onVideoGallerySelected;
  final VoidCallback onVideoCameraSelected;
  final VoidCallback onEmojiSelected;
  final VoidCallback onLocationSelected;
  final VoidCallback onContactSelected;
  final VoidCallback onAudioSelected;

  const AttachmentOptions({
    Key? key,
    required this.onImageSelected,
    required this.onVideoGallerySelected,
    required this.onVideoCameraSelected,
    required this.onEmojiSelected,
    required this.onLocationSelected,
    required this.onContactSelected,
    required this.onAudioSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  context: context,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    onImageSelected(ImageSource.camera);
                  },
                ),
                _buildAttachmentOption(
                  context: context,
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    onImageSelected(ImageSource.gallery);
                  },
                ),
                _buildAttachmentOption(
                  context: context,
                  icon: Icons.videocam,
                  label: 'Video',
                  onTap: () {
                    Navigator.pop(context);
                    onVideoGallerySelected();
                  },
                ),
                _buildAttachmentOption(
                  context: context,
                  icon: Icons.emoji_emotions,
                  label: 'Emoji',
                  onTap: () {
                    Navigator.pop(context);
                    onEmojiSelected();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  context: context,
                  icon: Icons.location_on,
                  label: 'Location',
                  onTap: () {
                    Navigator.pop(context);
                    onLocationSelected();
                  },
                ),
                _buildAttachmentOption(
                  context: context,
                  icon: Icons.contact_phone,
                  label: 'Contact',
                  onTap: () {
                    Navigator.pop(context);
                    onContactSelected();
                  },
                ),
                _buildAttachmentOption(
                  context: context,
                  icon: Icons.mic,
                  label: 'Audio',
                  onTap: () {
                    Navigator.pop(context);
                    onAudioSelected();
                  },
                ),
                _buildAttachmentOption(
                  context: context,
                  icon: Icons.video_camera_back,
                  label: 'Record Video',
                  onTap: () {
                    Navigator.pop(context);
                    onVideoCameraSelected();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper function to show the attachment options
Future<void> showAttachmentOptions({
  required BuildContext context,
  required Function(ImageSource) onImageSelected,
  required VoidCallback onVideoGallerySelected,
  required VoidCallback onVideoCameraSelected,
  required VoidCallback onEmojiSelected,
  required VoidCallback onLocationSelected,
  required VoidCallback onContactSelected,
  required VoidCallback onAudioSelected,
}) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return showModalBottomSheet(
    context: context,
    backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => AttachmentOptions(
      onImageSelected: onImageSelected,
      onVideoGallerySelected: onVideoGallerySelected,
      onVideoCameraSelected: onVideoCameraSelected,
      onEmojiSelected: onEmojiSelected,
      onLocationSelected: onLocationSelected,
      onContactSelected: onContactSelected,
      onAudioSelected: onAudioSelected,
    ),
  );
}
