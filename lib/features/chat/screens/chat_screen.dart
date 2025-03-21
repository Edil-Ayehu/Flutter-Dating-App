import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dating_app/features/chat/utils/media_handler.dart';
import 'package:flutter_dating_app/features/chat/widgets/attachment_options.dart';
import 'package:flutter_dating_app/features/chat/widgets/caption_dialog.dart';
import 'package:flutter_dating_app/features/chat/widgets/full_screen_video_player.dart';
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
  late MediaHandler _mediaHandler;

  @override
  void initState() {
    super.initState();
       // Initialize the media handler
    _mediaHandler = MediaHandler(
      context: context,
      chatRoomId: widget.chatRoom.id,
    );
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
          emojiViewConfig: const EmojiViewConfig(
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
    await _mediaHandler.pickImage(source);
  }

  Future<void> _pickVideo() async {
    await _mediaHandler.pickVideo();
  }

  Future<void> _captureVideo() async {
    await _mediaHandler.captureVideo();
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
      backgroundColor:
          isDarkMode ? AppColors.backgroundDark : Colors.grey.shade50,
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
                          color:
                              isDarkMode ? Colors.grey.shade900 : Colors.white,
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
                    color:
                        isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.chatRoom.isMatchOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: widget.chatRoom.isMatchOnline
                        ? Colors.green
                        : (isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
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
                backgroundColor:
                    isDarkMode ? Colors.grey.shade900 : Colors.white,
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
                          color:
                              isDarkMode ? Colors.white : Colors.grey.shade800,
                        ),
                        title: Text(
                          'View Profile',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white
                                : Colors.grey.shade800,
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
                              color: isDarkMode
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No messages yet',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Say hi to ${widget.chatRoom.matchName}!',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe =
                              message.senderId == chatProvider.currentUserId;
                          final showDate = index == 0 ||
                              !_isSameDay(messages[index - 1].timestamp,
                                  message.timestamp);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (showDate)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
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
                    _showEmojiPicker
                        ? Icons.keyboard
                        : Icons.emoji_emotions_outlined,
                    color: AppColors.primary,
                  ),
                  onPressed: _toggleEmojiPicker,
                ),

                // Icebreaker suggestion button (NEW)
                IconButton(
                  icon: Icon(
                    Icons.lightbulb_outline,
                    color: _showIcebreakerSuggestion ? AppColors.primary : Colors.grey,
                  ),
                  onPressed: _toggleIcebreakerSuggestion,
                  tooltip: 'Get icebreaker suggestions',
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
                      fillColor: isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
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
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                        color: isDarkMode
                            ? Colors.grey.shade500
                            : Colors.grey.shade600,
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
          color:
              isMe ? Colors.white : (isDarkMode ? Colors.white : Colors.black),
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildReplyContent(ChatMessage message, bool isMe, bool isDarkMode) {
    if (message.replyToId == null) return const SizedBox.shrink();

    final isReplyToMe = message.replyToSenderId ==
        Provider.of<ChatProvider>(context, listen: false).currentUserId;

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
          ),
        ),
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
                      : (isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade600),
                ),
                const SizedBox(width: 4),
                Text(
                  isReplyToMe ? 'You' : widget.chatRoom.matchName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isReplyToMe
                        ? AppColors.primary
                        : (isDarkMode
                            ? Colors.grey.shade300
                            : Colors.grey.shade700),
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
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) =>
              FullScreenVideoPlayer(controller: controller),
        ),
      )
          .then((_) {
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
  showAttachmentOptions(
    context: context,
    onImageSelected: (source) => _pickImage(source),
    onVideoGallerySelected: _pickVideo,
    onVideoCameraSelected: _captureVideo,
    onEmojiSelected: _toggleEmojiPicker,
    onLocationSelected: () {
      // Implement location sharing
    },
    onContactSelected: () {
      // Implement contact sharing
    },
    onAudioSelected: () {
      // Implement audio recording
    },
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
    final isMyMessage = _replyToMessage!.senderId ==
        Provider.of<ChatProvider>(context, listen: false).currentUserId;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        border: const Border(
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
                    color:
                        isMyMessage ? AppColors.primary : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                if (_replyToMessage!.messageType == MessageType.text)
                  Text(
                    _replyToMessage!.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.grey.shade300
                          : Colors.grey.shade700,
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
                          color: isDarkMode
                              ? Colors.grey.shade300
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  )
                else if (_replyToMessage!.messageType == MessageType.video)
                  Row(
                    children: [
                      Icon(Icons.videocam,
                          size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        'Video',
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.grey.shade300
                              : Colors.grey.shade700,
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

  void _toggleIcebreakerSuggestion() {
    setState(() {
      _showIcebreakerSuggestion = !_showIcebreakerSuggestion;
    });
  }
}
