import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/enums/message_type.dart';
import '../providers/chat_provider.dart';
import '../widgets/caption_dialog.dart';

class MediaHandler {
  final ImagePicker _picker = ImagePicker();
  final BuildContext context;
  final String chatRoomId;

  MediaHandler({
    required this.context,
    required this.chatRoomId,
  });

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        // Show caption dialog
        final String? caption = await showCaptionDialog(context);

        // Send image message
        Provider.of<ChatProvider>(context, listen: false).sendMediaMessage(
          chatRoomId,
          pickedFile.path,
          MessageType.image,
          caption: caption ?? '',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> pickVideo() async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 30),
      );

      if (pickedFile != null) {
        await processVideoFile(pickedFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking video: $e')),
      );
    }
  }

  Future<void> captureVideo() async {
    try {
      final XFile? capturedFile = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 30),
      );

      if (capturedFile != null) {
        await processVideoFile(capturedFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing video: $e')),
      );
    }
  }

  Future<void> processVideoFile(XFile videoFile) async {
    // Check video size (limit to 10MB for example)
    final File file = File(videoFile.path);
    final int fileSizeInBytes = await file.length();
    final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    if (fileSizeInMB > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video size should be less than 10MB')),
      );
      return;
    }

    // Show caption dialog
    final String? caption = await showCaptionDialog(context);

    // Send video message
    Provider.of<ChatProvider>(context, listen: false).sendMediaMessage(
      chatRoomId,
      videoFile.path,
      MessageType.video,
      caption: caption ?? '',
    );
  }
}
