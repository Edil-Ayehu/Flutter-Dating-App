import 'package:flutter/material.dart';
import 'package:flutter_dating_app/routes/route_names.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../shared/layouts/main_layout.dart';
import '../models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final provider = Provider.of<NotificationProvider>(context);
    final notifications = provider.notifications;
    final isLoading = provider.isLoading;
    final error = provider.error;
    
    return MainLayout(
      currentIndex: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Activity'),
          backgroundColor: isDarkMode ? AppColors.backgroundDark : Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            if (provider.unreadCount > 0)
              TextButton(
                onPressed: () {
                  provider.markAllAsRead();
                },
                child: Text(
                  'Mark all as read',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading notifications',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => provider.fetchNotifications(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : notifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 80,
                              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No notifications yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => provider.fetchNotifications(),
                        child: ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return Dismissible(
                              key: Key(notification.id),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                provider.deleteNotification(notification.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Notification deleted'),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () {
                                        // Implement undo functionality if needed
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: notification.isRead
                                      ? (isDarkMode ? Colors.grey.shade900 : Colors.white)
                                      : (isDarkMode
                                          ? AppColors.primary.withOpacity(0.15)
                                          : AppColors.primary.withOpacity(0.05)),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  leading: _getNotificationIcon(notification, isDarkMode),
                                  title: Text(
                                    notification.title,
                                    style: TextStyle(
                                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                                      color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        notification.message,
                                        style: TextStyle(
                                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        notification.time,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: !notification.isRead
                                      ? Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : null,
                                  onTap: () {
                                    // Mark as read when tapped
                                    if (!notification.isRead) {
                                      provider.markAsRead(notification.id);
                                    }
                                    
                                    // Handle notification tap based on type
                                    _handleNotificationTap(context, notification);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, NotificationModel notification) async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      switch (notification.type) {
        case NotificationType.match:
          // Get match data and navigate to match details
          final match = await provider.getMatchForNotification(notification.id);
          if (context.mounted) {
            Navigator.pop(context); // Remove loading dialog
            if (match != null) {
              Navigator.pushNamed(
                context, 
                RouteNames.matchDetails,
                arguments: match,
              );
            } else {
              // Fallback if match data couldn't be retrieved
              Navigator.pushNamed(context, RouteNames.discover);
            }
          }
          break;
        
        case NotificationType.like:
          // For likes, navigate to discover screen
          if (context.mounted) {
            Navigator.pop(context); // Remove loading dialog
            Navigator.pushNamed(context, RouteNames.discover);
          }
          break;
        
        case NotificationType.message:
          // Get chat room data and navigate to chat
          final chatRoom = await provider.getChatRoomForNotification(notification.id);
          if (context.mounted) {
            Navigator.pop(context); // Remove loading dialog
            if (chatRoom != null) {
              Navigator.pushNamed(
                context, 
                RouteNames.chat,
                arguments: chatRoom,
              );
            } else {
              // Fallback if chat data couldn't be retrieved
              Navigator.pushNamed(context, RouteNames.chatList);
            }
          }
          break;
        
        case NotificationType.system:
          if (context.mounted) {
            Navigator.pop(context); // Remove loading dialog
            _showSystemNotificationDetails(context, notification);
          }
          break;
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Remove loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSystemNotificationDetails(BuildContext context, NotificationModel notification) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
        title: Text(
          notification.title,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: TextStyle(
                color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              notification.time,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getNotificationIcon(NotificationModel notification, bool isDarkMode) {
    IconData iconData;
    Color iconColor;
    
    switch (notification.type) {
      case NotificationType.match:
        iconData = Icons.favorite;
        iconColor = Colors.red;
        break;
      case NotificationType.like:
        iconData = Icons.thumb_up;
        iconColor = Colors.blue;
        break;
      case NotificationType.message:
        iconData = Icons.chat_bubble;
        iconColor = Colors.green;
        break;
      case NotificationType.system:
        iconData = Icons.notifications;
        iconColor = Colors.amber;
        break;
    }
    
    if (notification.image != null) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(notification.image!),
        backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
      );
    }
    
    return CircleAvatar(
      radius: 24,
      backgroundColor: iconColor.withOpacity(0.2),
      child: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }
}
