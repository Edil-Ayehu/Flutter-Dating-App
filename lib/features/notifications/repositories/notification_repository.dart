import 'dart:async';
import '../models/notification_model.dart';

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
}
