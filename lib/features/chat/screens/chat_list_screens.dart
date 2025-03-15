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
        backgroundColor: isDarkMode ? AppColors.backgroundDark : Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            'Messages',
            style: TextStyle(
              color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: isDarkMode ? AppColors.backgroundDark : Colors.grey.shade50,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.search_rounded,
                color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
              ),
              onPressed: () {
                // Search functionality
              },
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            // New matches section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Matches',
                      style: AppTextStyles.h3Light.copyWith(
                        color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // View all matches
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // New matches horizontal list
            SliverToBoxAdapter(
              child: SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: newMatches.length,
                  itemBuilder: (context, index) {
                    final match = newMatches[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      Colors.purple,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDarkMode ? AppColors.backgroundDark : Colors.white,
                                  ),
                                  child: CircleAvatar(
                                    radius: 32,
                                    backgroundImage: NetworkImage(match['image']),
                                    backgroundColor: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              if (match['isOnline'])
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 14,
                                    height: 14,
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
                          const SizedBox(height: 8),
                          Text(
                            match['name'],
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Messages section header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  'Messages',
                  style: AppTextStyles.h3Light.copyWith(
                    color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            // Messages list
            conversations.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDarkMode 
                                  ? Colors.grey.shade800.withOpacity(0.5) 
                                  : Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 48,
                              color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No messages yet',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.grey.shade800,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Start matching with people to begin conversations',
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, RouteNames.discover);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Discover People'),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final conversation = conversations[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey.shade900 : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
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
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 28,
                                          backgroundImage: NetworkImage(conversation['image']),
                                          backgroundColor: Colors.grey.shade300,
                                        ),
                                      ),
                                      if (conversation['isOnline'])
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 14,
                                            height: 14,
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
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              conversation['name'],
                                              style: TextStyle(
                                                color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                                                fontWeight: conversation['unread'] > 0 
                                                    ? FontWeight.bold 
                                                    : FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              conversation['time'],
                                              style: TextStyle(
                                                color: conversation['unread'] > 0
                                                    ? AppColors.primary
                                                    : (isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600),
                                                fontSize: 12,
                                                fontWeight: conversation['unread'] > 0 
                                                    ? FontWeight.bold 
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                conversation['lastMessage'],
                                                style: TextStyle(
                                                  color: conversation['unread'] > 0
                                                      ? (isDarkMode ? Colors.white : AppColors.textPrimaryLight)
                                                      : (isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700),
                                                  fontWeight: conversation['unread'] > 0 
                                                      ? FontWeight.w500 
                                                      : FontWeight.normal,
                                                  fontSize: 14,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: conversations.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
