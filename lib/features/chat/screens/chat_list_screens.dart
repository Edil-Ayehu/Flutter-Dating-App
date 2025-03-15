import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/text_styles.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../routes/route_names.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Dummy data for matches and messages
    final List<Map<String, dynamic>> newMatches = [
      {
        'id': '1',
        'name': 'Jessica',
        'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
        'isOnline': true,
      },
      {
        'id': '2',
        'name': 'Michael',
        'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        'isOnline': false,
      },
      {
        'id': '3',
        'name': 'Sophia',
        'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
        'isOnline': true,
      },
      {
        'id': '4',
        'name': 'David',
        'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
        'isOnline': false,
      },
    ];
    
    final List<Map<String, dynamic>> conversations = [
      {
        'id': '1',
        'name': 'Jessica',
        'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
        'lastMessage': 'Hey, how are you doing?',
        'time': '2m ago',
        'unread': 2,
        'isOnline': true,
      },
      {
        'id': '3',
        'name': 'Sophia',
        'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
        'lastMessage': 'I would love to go hiking this weekend!',
        'time': '1h ago',
        'unread': 0,
        'isOnline': true,
      },
      {
        'id': '5',
        'name': 'Emma',
        'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
        'lastMessage': 'That sounds like a great idea',
        'time': '3h ago',
        'unread': 0,
        'isOnline': false,
      },
    ];
    
    return MainLayout(
      currentIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Messages',
            style: TextStyle(
              color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: isDarkMode ? AppColors.backgroundDark : Colors.white,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // New matches section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'New Matches',
                style: AppTextStyles.h3Light.copyWith(
                  color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: newMatches.length,
                itemBuilder: (context, index) {
                  final match = newMatches[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(match['image']),
                                backgroundColor: Colors.grey.shade300,
                              ),
                            ),
                            if (match['isOnline'])
                              Positioned(
                                right: 4,
                                bottom: 4,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDarkMode ? AppColors.backgroundDark : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          match['name'],
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            const Divider(),
            
            // Messages section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Messages',
                style: AppTextStyles.h3Light.copyWith(
                  color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            Expanded(
              child: conversations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 60,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No messages yet',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start matching to begin conversations',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = conversations[index];
                        return ListTile(
                          onTap: () {
                            // Navigate to chat screen
                            Navigator.pushNamed(
                              context,
                              RouteNames.chat,
                              arguments: {
                                'id': conversation['id'],
                                'name': conversation['name'],
                                'image': conversation['image'],
                              },
                            );
                          },
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(conversation['image']),
                                backgroundColor: Colors.grey.shade300,
                              ),
                              if (conversation['isOnline'])
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
                                        color: isDarkMode ? AppColors.backgroundDark : Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          title: Text(
                            conversation['name'],
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            conversation['lastMessage'],
                            style: TextStyle(
                              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                conversation['time'],
                                style: TextStyle(
                                  color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (conversation['unread'] > 0)
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    conversation['unread'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
