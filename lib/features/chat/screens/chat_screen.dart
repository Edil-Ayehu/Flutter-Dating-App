import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dating_app/features/icebreakers/widgets/icebreaker_suggestion_widget.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/enums/message_type.dart';
import '../models/chat_message.dart';
import '../models/chat_room.dart';
import '../providers/chat_provider.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;
  
  const ChatScreen({
    Key? key,
    required this.chatRoom,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool _isComposing = false;
  bool _showIcebreakerSuggestion = false;
  Map<String, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    // Load messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false)
          .loadMessages(widget.chatRoom.id);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    // Dispose all video controllers
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      
      if (pickedFile != null) {
        // Show caption dialog
        final String? caption = await _showCaptionDialog();
        
        // Send image message
        Provider.of<ChatProvider>(context, listen: false).sendMediaMessage(
          widget.chatRoom.id,
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

  Future<void> _pickVideo() async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 30),
      );
      
      if (pickedFile != null) {
        // Check video size (limit to 10MB for example)
        final File file = File(pickedFile.path);
        final int fileSizeInBytes = await file.length();
        final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        
        if (fileSizeInMB > 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video size should be less than 10MB')),
          );
          return;
        }
        
        // Show caption dialog
        final String? caption = await _showCaptionDialog();
        
        // Send video message
        Provider.of<ChatProvider>(context, listen: false).sendMediaMessage(
          widget.chatRoom.id,
          pickedFile.path,
          MessageType.video,
          caption: caption ?? '',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking video: $e')),
      );
    }
  }

  Future<String?> _showCaptionDialog() {
    final TextEditingController captionController = TextEditingController();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
        title: Text(
          'Add a caption',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        content: TextField(
          controller: captionController,
          decoration: InputDecoration(
            hintText: 'Caption (optional)',
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              ),
            ),
          ),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, captionController.text),
            child: Text(
              'Send',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMediaOptions() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_rounded,
                  color: AppColors.primary,
                ),
                title: Text(
                  'Photo Library',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.primary,
                ),
                title: Text(
                  'Camera',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.videocam_rounded,
                  color: AppColors.primary,
                ),
                title: Text(
                  'Video',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final chatProvider = Provider.of<ChatProvider>(context);
    final messages = chatProvider.getMessagesForChatRoom(widget.chatRoom.id);
    
    // Scroll to bottom when messages change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDarkMode ? Colors.white : Colors.grey.shade800,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(widget.chatRoom.matchImage),
                ),
                if (widget.chatRoom.isMatchOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDarkMode ? Colors.grey.shade900 : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatRoom.matchName,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                                    widget.chatRoom.isMatchOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: widget.chatRoom.isMatchOnline 
                        ? Colors.green 
                        : (isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: isDarkMode ? Colors.white : Colors.grey.shade800,
            ),
            onPressed: () {
              // Show options menu
              showModalBottomSheet(
                context: context,
                backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: isDarkMode ? Colors.white : Colors.grey.shade800,
                        ),
                        title: Text(
                          'View Profile',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.grey.shade800,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to profile
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.block,
                          color: Colors.red.shade400,
                        ),
                        title: Text(
                          'Block User',
                          style: TextStyle(
                            color: Colors.red.shade400,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          // Block user
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.report,
                          color: Colors.orange.shade400,
                        ),
                        title: Text(
                          'Report User',
                          style: TextStyle(
                            color: Colors.orange.shade400,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          // Report user
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: chatProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 60,
                              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No messages yet',
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Say hi to ${widget.chatRoom.matchName}!',
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId == chatProvider.currentUserId;
                          final showDate = index == 0 || 
                              !_isSameDay(messages[index - 1].timestamp, message.timestamp);
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (showDate)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDarkMode 
                                            ? Colors.grey.shade800 
                                            : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _formatMessageDate(message.timestamp),
                                        style: TextStyle(
                                          color: isDarkMode 
                                              ? Colors.grey.shade300 
                                              : Colors.grey.shade700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              _buildMessageBubble(
                                message: message,
                                isMe: isMe,
                                isDarkMode: isDarkMode,
                              ),
                            ],
                          );
                        },
                      ),
          ),
          
          // Icebreaker suggestion
          if (_showIcebreakerSuggestion)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: IcebreakerSuggestionWidget(
                matchId: widget.chatRoom.matchId,
                onSendIcebreaker: (question) {
                  _handleSubmitted(question);
                  setState(() {
                    _showIcebreakerSuggestion = false;
                  });
                },
              ),
            ),
          
          // Message input
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade900 : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                // Icebreaker button
                IconButton(
                  icon: const Icon(Icons.lightbulb_outline),
                  onPressed: () {
                    setState(() {
                      _showIcebreakerSuggestion = !_showIcebreakerSuggestion;
                    });
                  },
                  color: _showIcebreakerSuggestion 
                      ? AppColors.primary 
                      : (isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700),
                ),
                IconButton(
                  icon: Icon(
                    Icons.photo_camera,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                  onPressed: _showMediaOptions,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    onChanged: (text) {
                      setState(() {
                        _isComposing = text.isNotEmpty;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _isComposing ? AppColors.primary : Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _isComposing
                        ? () {
                            _handleSubmitted(_messageController.text);
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required ChatMessage message,
    required bool isMe,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.chatRoom.matchImage),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: message.messageType == MessageType.text
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
                  : const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: isMe
                    ? AppColors.primary
                    : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomRight: isMe ? const Radius.circular(0) : null,
                  bottomLeft: !isMe ? const Radius.circular(0) : null,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Media content
                  if (message.messageType == MessageType.image)
                    _buildImageMessage(message, isMe, isDarkMode)
                  else if (message.messageType == MessageType.video)
                    _buildVideoMessage(message, isMe, isDarkMode)
                  else
                    Text(
                      message.content,
                      style: TextStyle(
                        color: isMe
                            ? Colors.white
                            : (isDarkMode ? Colors.white : Colors.black),
                        fontSize: 16,
                      ),
                    ),
                  
                  // Caption for media messages
                  if ((message.messageType == MessageType.image || 
                       message.messageType == MessageType.video) && 
                       message.content.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        message.content,
                        style: TextStyle(
                          color: isMe
                              ? Colors.white.withOpacity(0.9)
                              : (isDarkMode ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.9)),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('h:mm a').format(message.timestamp),
                    style: TextStyle(
                      color: isMe
                          ? Colors.white.withOpacity(0.7)
                          : (isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 4),
            Icon(
              message.isRead ? Icons.done_all : Icons.done,
              size: 16,
              color: message.isRead ? Colors.blue : Colors.grey,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageMessage(ChatMessage message, bool isMe, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        // Show full screen image
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                iconTheme: const IconThemeData(color: Colors.white),
                elevation: 0,
              ),
              body: Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: Image.file(
                    File(message.mediaUrl!),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(message.mediaUrl!),
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildVideoMessage(ChatMessage message, bool isMe, bool isDarkMode) {
    // Initialize video controller if not already initialized
    if (!_videoControllers.containsKey(message.id)) {
      final controller = VideoPlayerController.file(File(message.mediaUrl!));
      controller.initialize().then((_) {
        setState(() {});
      });
      _videoControllers[message.id] = controller;
    }
    
    final controller = _videoControllers[message.id]!;
    
    return GestureDetector(
      onTap: () {
        // Toggle play/pause
        setState(() {
          controller.value.isPlaying ? controller.pause() : controller.play();
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 200,
              height: 200,
              color: Colors.black,
              child: controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          if (controller.value.isInitialized && !controller.value.isPlaying)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    
    _messageController.clear();
    setState(() {
      _isComposing = false;
    });
    
    // Send message
    Provider.of<ChatProvider>(context, listen: false).sendMessage(
      widget.chatRoom.id,
      text,
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  String _formatMessageDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);
    
    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}
