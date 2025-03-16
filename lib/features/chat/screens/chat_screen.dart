import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/text_styles.dart';
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
  bool _isComposing = false;

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.photo_camera,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                  onPressed: () {
                    // Handle image upload
                  },
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isMe
                          ? Colors.white
                          : (isDarkMode ? Colors.white : Colors.black),
                      fontSize: 16,
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
