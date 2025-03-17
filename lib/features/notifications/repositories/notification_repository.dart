import 'dart:async';
import 'package:flutter_dating_app/features/chat/models/chat_message.dart';

import '../models/notification_model.dart';
import 'package:flutter_dating_app/features/chat/models/chat_room.dart';
import 'package:flutter_dating_app/features/matching/models/match_result.dart';


class NotificationRepository {
  // Simulate a database or API with a list of notifications
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      type: NotificationType.match,
      title: 'New Match!',
      message: 'You and Jessica matched!',
      time: '2 minutes ago',
      image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      type: NotificationType.like,
      title: 'New Like',
      message: 'Michael liked your profile',
      time: '1 hour ago',
      image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
      isRead: true,
    ),
    NotificationModel(
      id: '3',
      type: NotificationType.message,
      title: 'New Message',
      message: 'Sophia sent you a message',
      time: '3 hours ago',
      image: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      isRead: false,
    ),
    NotificationModel(
      id: '4',
      type: NotificationType.system,
      title: 'Profile Boost',
      message: 'Your profile boost is now active for 30 minutes!',
      time: '5 hours ago',
      image: null,
      isRead: true,
    ),
  ];

  // Get all notifications
  Future<List<NotificationModel>> getNotifications() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _notifications;
  }

  // Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index].isRead = true;
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    for (var notification in _notifications) {
      notification.isRead = true;
    }
  }

  // Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    _notifications.removeWhere((n) => n.id == notificationId);
  }

  // Add a new notification (for testing)
  Future<void> addNotification(NotificationModel notification) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    _notifications.insert(0, notification);
  }

  // Get match data for a match notification
  Future<MatchResult?> getMatchForNotification(String notificationId) async {
    // In a real app, you would fetch this from your backend
    // For now, return a mock match
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Find the notification
    final notification = _notifications.firstWhere(
      (n) => n.id == notificationId && n.type == NotificationType.match,
      orElse: () => throw Exception('Match notification not found'),
    );
    
    // Extract name from notification message
    final name = notification.message.split(' ')[2].replaceAll('!', ''); // Extract "Jessica" from "You and Jessica matched!"
    
    // Return mock match data
    return MatchResult(
      id: 'match-${notification.id}',
      name: name,
      age: 28,
      bio: 'I love hiking and photography',
      distance: '5 miles away',
      image: notification.image ?? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      interests: ['Photography', 'Hiking', 'Travel'],
      isOnline: true,
      occupation: 'Photographer',
      education: 'Art Institute',
    );
  }
  
  // Get chat room for a message notification
  Future<ChatRoom?> getChatRoomForNotification(String notificationId) async {
    // In a real app, you would fetch this from your backend
    // For now, return a mock chat room
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Find the notification
    final notification = _notifications.firstWhere(
      (n) => n.id == notificationId && n.type == NotificationType.message,
      orElse: () => throw Exception('Message notification not found'),
    );
    
    // Extract name from notification message
    final name = notification.message.split(' ')[0];
    
    // Return mock chat room with all required parameters
    return ChatRoom(
      id: 'chat-${notification.id}',
      userId: 'user-${notification.id}',
      matchId: 'match-${notification.id}',
      matchName: name,
      matchImage: notification.image ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      isMatchOnline: true,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      lastActivity: DateTime.now().subtract(const Duration(hours: 3)),
      lastMessage: ChatMessage(
        id: 'msg-${notification.id}',
        senderId: 'match-${notification.id}',
        receiverId: 'user-${notification.id}',
        content: notification.message,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: false,
      ),
      unreadCount: 1,
    );
  }
}
