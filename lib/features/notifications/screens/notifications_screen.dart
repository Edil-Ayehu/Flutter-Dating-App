import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/text_styles.dart';
import '../../../shared/layouts/main_layout.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Dummy notifications data
    final List<Map<String, dynamic>> notifications = [
      {
        'type': 'match',
        'title': 'New Match!',
        'message': 'You and Jessica matched!',
        'time': '2 minutes ago',
        'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
        'isRead': false,
      },
      {
        'type': 'like',
        'title': 'New Like',
        'message': 'Michael liked your profile',
        'time': '1 hour ago',
        'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        'isRead': true,
      },
      {
        'type': 'message',
        'title': 'New Message',
        'message': 'Sophia sent you a message',
        'time': '3 hours ago',
        'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
        'isRead': false,
      },
      {
        'type': 'system',
        'title': 'Profile Boost',
        'message': 'Your profile boost is now active for 30 minutes!',
        'time': '5 hours ago',
        'image': null,
        'isRead': true,
      },
    ];
    
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
            TextButton(
              onPressed: () {
                // Mark all as read
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
        body: notifications.isEmpty
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
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: notification['isRead']
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
                        notification['title'],
                        style: TextStyle(
                          fontWeight: notification['isRead'] ? FontWeight.normal : FontWeight.bold,
                          color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            notification['message'],
                            style: TextStyle(
                              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification['time'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      trailing: !notification['isRead']
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
                        // Handle notification tap
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _getNotificationIcon(Map<String, dynamic> notification, bool isDarkMode) {
    IconData iconData;
    Color iconColor;
    
    switch (notification['type']) {
      case 'match':
        iconData = Icons.favorite;
        iconColor = Colors.red;
        break;
      case 'like':
        iconData = Icons.thumb_up;
        iconColor = Colors.blue;
        break;
      case 'message':
        iconData = Icons.chat_bubble;
        iconColor = Colors.green;
        break;
      case 'system':
        iconData = Icons.notifications;
        iconColor = Colors.amber;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = AppColors.primary;
    }
    
    if (notification['image'] != null) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(notification['image']),
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
