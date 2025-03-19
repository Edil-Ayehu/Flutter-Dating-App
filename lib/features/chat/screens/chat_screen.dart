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
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';



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
  ChatMessage? _replyToMessage;
  bool _isReplying = false;
  bool _showEmojiPicker = false;
  FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Load messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false)
          .loadMessages(widget.chatRoom.id);
    });
    
    // Add listener to focus node to hide emoji picker when keyboard appears
    _messageFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.removeListener(_onFocusChange);
    _messageFocusNode.dispose();
    // Dispose all video controllers
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    if (_messageFocusNode.hasFocus) {
      setState(() {
        _showEmojiPicker = false;
      });
    }
  }

  // Add this method to toggle emoji picker
  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
      if (_showEmojiPicker) {
        // Hide keyboard when showing emoji picker
        _messageFocusNode.unfocus();
      } else {
        // Show keyboard when hiding emoji picker
        _messageFocusNode.requestFocus();
      }
    });
  }

  // Add this method to insert emoji into text field
  void _onEmojiSelected(Emoji emoji) {
    final text = _messageController.text;
    final textSelection = _messageController.selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      emoji.emoji,
    );
    final newSelection = TextSelection.collapsed(
      offset: textSelection.start + emoji.emoji.length,
    );
    
    setState(() {
      _messageController.text = newText;
      _messageController.selection = newSelection;
      _isComposing = _messageController.text.isNotEmpty;
    });
  }

  // Add this method to build the emoji picker
  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          _onEmojiSelected(emoji);
        },
        config: Config(
          emojiViewConfig: EmojiViewConfig(
            columns: 7,
            emojiSizeMax: 32.0,
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: EdgeInsets.zero,
          ),
          categoryViewConfig: CategoryViewConfig(
            initCategory: Category.RECENT,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            indicatorColor: AppColors.primary,
            iconColor: Colors.grey,
            iconColorSelected: AppColors.primary,
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
          ),
          bottomActionBarConfig: BottomActionBarConfig(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            buttonColor: AppColors.primary,
          ),
          skinToneConfig: const SkinToneConfig(
            dialogBackgroundColor: Colors.white,
            indicatorColor: Colors.grey,
          ),
        ),
      ),
    );
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
        await _processVideoFile(pickedFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking video: $e')),
      );
    }
  }

  Future<void> _captureVideo() async {
    try {
      final XFile? capturedFile = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 30),
      );
      
      if (capturedFile != null) {
        await _processVideoFile(capturedFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing video: $e')),
      );
    }
  }

  Future<void> _processVideoFile(XFile videoFile) async {
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
    final String? caption = await _showCaptionDialog();
    
    // Send video message
    Provider.of<ChatProvider>(context, listen: false).sendMediaMessage(
      widget.chatRoom.id,
      videoFile.path,
      MessageType.video,
      caption: caption ?? '',
    );
  }

  Future<String?> _showCaptionDialog() {
    final TextEditingController captionController = TextEditingController();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return showDialog<String>(
      context: context,
      builder: (context) => Dialog(
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
                controller: captionController,
                decoration: InputDecoration(
                  hintText: 'Write something about this...',
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
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
                      foregroundColor: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, captionController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                leading: const Icon(
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
                leading: const Icon(
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
                leading: const Icon(
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
                              _buildMessageItem(
                                message,
                                isMe,
                                isDarkMode,
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
          
          // Reply preview
          _buildReplyPreview(),
          
          // Message input
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade900 : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                // Emoji button
                IconButton(
                  icon: Icon(
                    _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
                    color: AppColors.primary,
                  ),
                  onPressed: _toggleEmojiPicker,
                ),
                
                // Attachment button
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  color: AppColors.primary,
                  onPressed: _showAttachmentOptions,
                ),
                
                // Text input field
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _messageFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _isComposing = text.isNotEmpty;
                      });
                    },
                  ),
                ),
                
                // Send button
                IconButton(
                  icon: const Icon(Icons.send),
                  color: _isComposing ? AppColors.primary : Colors.grey,
                  onPressed: _isComposing ? _sendMessage : null,
                ),
              ],
            ),
          ),
          
          // Emoji picker
          if (_showEmojiPicker) _buildEmojiPicker(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message, bool isMe, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) _buildAvatar(isDarkMode),
          const SizedBox(width: 8),
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                _showReplyUI(message);
              },
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Show reply content if this is a reply message
                  if (message.replyToId != null)
                    _buildReplyContent(message, isMe, isDarkMode),
                  
                  // Show the actual message content based on type
                  if (message.messageType == MessageType.text)
                    _buildTextMessage(message, isMe, isDarkMode)
                  else if (message.messageType == MessageType.image)
                    _buildImageMessage(message, isMe, isDarkMode)
                  else if (message.messageType == MessageType.video)
                    _buildVideoMessage(message, isMe, isDarkMode),
                  
                  // Show timestamp
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat('h:mm a').format(message.timestamp),
                      style: TextStyle(
                        fontSize: 10,
                        color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isDarkMode) {
    return CircleAvatar(
      radius: 16,
      backgroundImage: NetworkImage(widget.chatRoom.matchImage),
    );
  }

  Widget _buildTextMessage(ChatMessage message, bool isMe, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.primary
            : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(18).copyWith(
          bottomRight: isMe ? const Radius.circular(0) : null,
          bottomLeft: !isMe ? const Radius.circular(0) : null,
        ),
      ),
      child: Text(
        message.content,
        style: TextStyle(
          color: isMe
              ? Colors.white
              : (isDarkMode ? Colors.white : Colors.black),
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildReplyContent(ChatMessage message, bool isMe, bool isDarkMode) {
    if (message.replyToId == null) return const SizedBox.shrink();
    
    final isReplyToMe = message.replyToSenderId == Provider.of<ChatProvider>(context, listen: false).currentUserId;
    
    return GestureDetector(
      onTap: () {
        // Scroll to the original message
        _scrollToMessage(message.replyToId!);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDarkMode 
              ? Colors.grey.shade800.withOpacity(0.5) 
              : Colors.grey.shade200.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
          border: const Border(
            left: BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
        ),),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.reply,
                  size: 14,
                  color: isReplyToMe 
                      ? AppColors.primary 
                      : (isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
                const SizedBox(width: 4),
                Text(
                  isReplyToMe ? 'You' : widget.chatRoom.matchName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isReplyToMe 
                        ? AppColors.primary 
                        : (isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              message.replyToContent ?? '',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
        // Navigate to full screen video player
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => _FullScreenVideoPlayer(controller: controller),
          ),
        ).then((_) {
          // Pause the video when returning from full screen
          if (controller.value.isPlaying) {
            controller.pause();
          }
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
          if (controller.value.isInitialized)
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

  void _showAttachmentOptions() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    _buildAttachmentOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                    _buildAttachmentOption(
                      icon: Icons.videocam,
                      label: 'Video',
                      onTap: () {
                        Navigator.pop(context);
                        _pickVideo();
                      },
                    ),
                    _buildAttachmentOption(
                      icon: Icons.emoji_emotions,
                      label: 'Emoji',
                      onTap: () {
                        Navigator.pop(context);
                        _toggleEmojiPicker();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentOption(
                      icon: Icons.location_on,
                      label: 'Location',
                      onTap: () {
                        Navigator.pop(context);
                        // Implement location sharing
                      },
                    ),
                    _buildAttachmentOption(
                      icon: Icons.contact_phone,
                      label: 'Contact',
                      onTap: () {
                        Navigator.pop(context);
                        // Implement contact sharing
                      },
                    ),
                    _buildAttachmentOption(
                      icon: Icons.mic,
                      label: 'Audio',
                      onTap: () {
                        Navigator.pop(context);
                        // Implement audio recording
                      },
                    ),
                    const SizedBox(width: 70), // Empty space for balance
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
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

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    final content = _messageController.text.trim();
    _messageController.clear();
    setState(() {
      _isComposing = false;
    });
    
    if (_isReplying && _replyToMessage != null) {
      // Send as a reply
      Provider.of<ChatProvider>(context, listen: false).sendReplyMessage(
        widget.chatRoom.id,
        content,
        _replyToMessage!,
      );
      
      // Reset reply state
      setState(() {
        _replyToMessage = null;
        _isReplying = false;
      });
    } else {
      // Send as a normal message
      Provider.of<ChatProvider>(context, listen: false).sendMessage(
        widget.chatRoom.id,
        content,
      );
    }
    
    // Scroll to bottom after sending
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
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

  void _showReplyUI(ChatMessage message) {
    setState(() {
      _replyToMessage = message;
      _isReplying = true;
    });
    // Focus the text field
    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyToMessage = null;
      _isReplying = false;
    });
  }

  Widget _buildReplyPreview() {
    if (!_isReplying || _replyToMessage == null) {
      return const SizedBox.shrink();
    }
    
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isMyMessage = _replyToMessage!.senderId == Provider.of<ChatProvider>(context, listen: false).currentUserId;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        border: Border(
          left: BorderSide(
            color: AppColors.primary,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isMyMessage ? 'You' : widget.chatRoom.matchName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMyMessage ? AppColors.primary : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                if (_replyToMessage!.messageType == MessageType.text)
                  Text(
                    _replyToMessage!.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                  )
                else if (_replyToMessage!.messageType == MessageType.image)
                  Row(
                    children: [
                      Icon(Icons.image, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        'Photo',
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  )
                else if (_replyToMessage!.messageType == MessageType.video)
                  Row(
                    children: [
                      Icon(Icons.videocam, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        'Video',
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _cancelReply,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    
    _messageController.clear();
    setState(() {
      _isComposing = false;
    });
    
    // Send the message
    Provider.of<ChatProvider>(context, listen: false).sendMessage(
      widget.chatRoom.id,
      text,
    );
    
    // Scroll to bottom after sending
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToMessage(String messageId) {
    final messages = Provider.of<ChatProvider>(context, listen: false)
        .getMessagesForChatRoom(widget.chatRoom.id);
    
    final index = messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      // Calculate the position to scroll to
      final itemHeight = 70.0; // Approximate height of a message item
      final position = index * itemHeight;
      
      // Scroll to the position
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      
      // Highlight the message briefly
      // This would require adding a highlighted state to the message item
    }
  }
}

// Add this new class for the full-screen video player
class _FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const _FullScreenVideoPlayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<_FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<_FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    // Add listener to update UI when video state changes
    _controller.addListener(_updateState);
  }
  
  @override
  void dispose() {
    // Remove listener when disposing
    _controller.removeListener(_updateState);
    super.dispose();
  }
  
  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        backgroundColor: AppColors.primary,
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
