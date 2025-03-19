import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../models/chat_room.dart';
import '../repositories/chat_repository.dart';
import '../../../core/enums/message_type.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _repository;
  
  
  
  List<ChatRoom> _chatRooms = [];
  Map<String, List<ChatMessage>> _messages = {};
  bool _isLoading = false;
  String? _error;
  String _currentUserId = 'current_user'; // Will be replaced with actual user ID

  ChatProvider({required ChatRepository repository}) 
      : _repository = repository {
    _loadChatRooms();
  }

  // Getters
  List<ChatRoom> get chatRooms => _chatRooms;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentUserId => _currentUserId;

  // Get messages for a specific chat room
  List<ChatMessage> getMessagesForChatRoom(String chatRoomId) {
    return _messages[chatRoomId] ?? [];
  }

  // Load chat rooms
  Future<void> _loadChatRooms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _chatRooms = await _repository.getChatRooms(_currentUserId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Load messages for a specific chat room
  Future<void> loadMessages(String chatRoomId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final messages = await _repository.getChatMessages(chatRoomId);
      _messages[chatRoomId] = messages;
      
      // Mark messages as read
      await _repository.markMessagesAsRead(chatRoomId);
      
      // Update unread count in chat room
      final index = _chatRooms.indexWhere((room) => room.id == chatRoomId);
      if (index != -1) {
        _chatRooms[index] = _chatRooms[index].copyWith(unreadCount: 0);
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Send a message
  Future<void> sendMessage(String chatRoomId, String content, {String? mediaUrl}) async {
    try {
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: _currentUserId,
        receiverId: _chatRooms.firstWhere((room) => room.id == chatRoomId).matchId,
        content: content,
        timestamp: DateTime.now(),
        isRead: false,
        mediaUrl: mediaUrl,
      );
      
      // Add message to local state
      if (_messages.containsKey(chatRoomId)) {
        _messages[chatRoomId] = [..._messages[chatRoomId]!, message];
      } else {
        _messages[chatRoomId] = [message];
      }
      
      // Update last message in chat room
      final index = _chatRooms.indexWhere((room) => room.id == chatRoomId);
      if (index != -1) {
        _chatRooms[index] = _chatRooms[index].copyWith(
          lastMessage: message,
          lastActivity: DateTime.now(),
        );
      }
      
      notifyListeners();
      
      // Send message to repository
      await _repository.sendMessage(message);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Get or create chat room for a match
  Future<ChatRoom> getOrCreateChatRoomForMatch(
    String matchId, 
    String matchName, 
    String matchImage, 
    bool isMatchOnline
  ) async {
    try {
      // Try to find existing chat room
      final existingRoom = await _repository.getChatRoomByMatchId(_currentUserId, matchId);
      return existingRoom!;
    } catch (e) {
      // Create new chat room
      final newRoom = ChatRoom(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _currentUserId,
        matchId: matchId,
        matchName: matchName,
        matchImage: matchImage,
        isMatchOnline: isMatchOnline,
        createdAt: DateTime.now(),
        lastActivity: DateTime.now(),
      );
      
      final createdRoom = await _repository.createChatRoom(newRoom);
      
      // Add to local state
      _chatRooms = [..._chatRooms, createdRoom];
      notifyListeners();
      
      return createdRoom;
    }
  }

  // Refresh chat rooms
  Future<void> refreshChatRooms() async {
    await _loadChatRooms();
  }

  // Add this method to send media messages
  Future<void> sendMediaMessage(
    String chatRoomId, 
    String mediaPath, 
    MessageType messageType,
    {String caption = ''}
  ) async {
    try {
      // In a real app, you would upload the media to storage and get the URL
      // For this example, we'll just use the local path as the URL
      final String mediaUrl = mediaPath;
      
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: _currentUserId,
        receiverId: _chatRooms.firstWhere((room) => room.id == chatRoomId).matchId,
        content: caption,
        timestamp: DateTime.now(),
        isRead: false,
        mediaUrl: mediaUrl,
        messageType: messageType,
      );
      
      // Add message to local state
      if (_messages.containsKey(chatRoomId)) {
        _messages[chatRoomId] = [..._messages[chatRoomId]!, message];
      } else {
        _messages[chatRoomId] = [message];
      }
      
      // Update last message in chat room
      final index = _chatRooms.indexWhere((room) => room.id == chatRoomId);
      if (index != -1) {
        _chatRooms[index] = _chatRooms[index].copyWith(
          lastMessage: message,
          lastActivity: DateTime.now(),
        );
      }
      
      notifyListeners();
      
      // Send message to repository
      await _repository.sendMessage(message);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Add this method to send reply messages
  Future<void> sendReplyMessage(
    String chatRoomId,
    String content,
    ChatMessage replyToMessage,
    {String? mediaUrl, MessageType messageType = MessageType.text}
  ) async {
    try {
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: _currentUserId,
        receiverId: _chatRooms.firstWhere((room) => room.id == chatRoomId).matchId,
        content: content,
        timestamp: DateTime.now(),
        isRead: false,
        mediaUrl: mediaUrl,
        messageType: messageType,
        replyToId: replyToMessage.id,
        replyToContent: replyToMessage.content,
        replyToSenderId: replyToMessage.senderId,
      );
      
      // Add message to local state
      if (_messages.containsKey(chatRoomId)) {
        _messages[chatRoomId] = [..._messages[chatRoomId]!, message];
      } else {
        _messages[chatRoomId] = [message];
      }
      
      // Update last message in chat room
      final index = _chatRooms.indexWhere((room) => room.id == chatRoomId);
      if (index != -1) {
        _chatRooms[index] = _chatRooms[index].copyWith(
          lastMessage: message,
          lastActivity: DateTime.now(),
        );
      }
      
      notifyListeners();
      
      // Send message to repository
      await _repository.sendMessage(message);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
