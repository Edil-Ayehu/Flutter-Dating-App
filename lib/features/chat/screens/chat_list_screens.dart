import 'package:flutter/material.dart';
import 'package:flutter_dating_app/features/chat/models/chat_room.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/text_styles.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../routes/route_names.dart';
import '../../matching/models/match_result.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  void _navigateToMatchPreview(
      BuildContext context, Map<String, dynamic> match) {
    // Create a MatchResult object from the match data
    final matchResult = MatchResult(
      id: match['id'],
      name: match['name'],
      image: match['image'],
      isOnline: match['isOnline'] ?? false,
      age: match['age'] ?? 25, // Add default value if not available
      distance: match['distance'] ??
          '2 miles away', // Add default value if not available
      bio: match['bio'] ??
          'No bio available', // Add default value if not available
      interests: match['interests'] != null
          ? List<String>.from(match['interests'])
          : [],
      occupation: match['occupation'] ?? '',
      education: match['education'] ?? '',
    );

    // Navigate to match preview screen
    Navigator.pushNamed(
      context,
      RouteNames.matchPreview,
      arguments: matchResult,
    );
  }

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
        'age': 28,
        'distance': '3 miles away',
        'bio': 'Love hiking and outdoor adventures',
        'interests': ['Hiking', 'Photography', 'Travel'],
        'occupation': 'Photographer',
        'education': 'Art Institute',
      },
      {
        'id': '2',
        'name': 'Michael',
        'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        'isOnline': false,
        'age': 32,
        'distance': '5 miles away',
        'bio': 'Software engineer who loves coffee and hiking',
        'interests': ['Coding', 'Coffee', 'Hiking'],
        'occupation': 'Software Engineer',
        'education': 'Stanford University',
      },
      {
        'id': '3',
        'name': 'Sophia',
        'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
        'isOnline': true,
        'age': 27,
        'distance': '1 mile away',
        'bio': 'Artist and yoga enthusiast',
        'interests': ['Art', 'Yoga', 'Music'],
        'occupation': 'Graphic Designer',
        'education': 'RISD',
      },
      {
        'id': '4',
        'name': 'David',
        'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
        'isOnline': false,
        'age': 30,
        'distance': '7 miles away',
        'bio': 'Fitness coach who loves outdoor activities',
        'interests': ['Fitness', 'Nutrition', 'Sports'],
        'occupation': 'Personal Trainer',
        'education': 'University of Michigan',
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
        backgroundColor:
            isDarkMode ? AppColors.backgroundDark : Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            'Messages',
            style: TextStyle(
              color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor:
              isDarkMode ? AppColors.backgroundDark : Colors.grey.shade50,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: isDarkMode ? Colors.white : Colors.grey.shade800,
              ),
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context, 
                  RouteNames.chatSearch
                );
                
                if (result != null && result is String) {
                  // Get the conversation ID from search result
                  final conversationId = result;
                  
                  // Find the conversation in your list
                  final selectedConversation = conversations.firstWhere(
                    (conv) => conv['id'] == conversationId,
                    orElse: () => conversations.first,
                  );
                  
                  // Create a ChatRoom object from the conversation data
                  final chatRoom = ChatRoom(
                    id: selectedConversation['id'],
                    userId: 'current_user',
                    matchId: selectedConversation['id'],
                    matchName: selectedConversation['name'],
                    matchImage: selectedConversation['image'],
                    isMatchOnline: selectedConversation['isOnline'] ?? false,
                    createdAt: DateTime.now().subtract(const Duration(days: 1)),
                    lastActivity: DateTime.now(),
                    unreadCount: selectedConversation['unread'] ?? 0,
                  );
                  
                  // Navigate to chat screen with the chat room
                  Navigator.pushNamed(
                    context,
                    RouteNames.chat,
                    arguments: chatRoom,
                  );
                }
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
                        color: isDarkMode
                            ? Colors.white
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to discover screen to see all potential matches
                        Navigator.pushNamed(context, RouteNames.discover);
                      },
                      child: const Text(
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
                    return GestureDetector(
                      onTap: () => _navigateToMatchPreview(context, match),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
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
                                      color: isDarkMode
                                          ? AppColors.backgroundDark
                                          : Colors.white,
                                    ),
                                    child: CircleAvatar(
                                      radius: 32,
                                      backgroundImage:
                                          NetworkImage(match['image']),
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
                                          color: isDarkMode
                                              ? AppColors.backgroundDark
                                              : Colors.white,
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
                                color: isDarkMode
                                    ? Colors.white
                                    : AppColors.textPrimaryLight,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
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
                    color:
                        isDarkMode ? Colors.white : AppColors.textPrimaryLight,
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
                              color: isDarkMode
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No messages yet',
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white
                                  : Colors.grey.shade800,
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
                                color: isDarkMode
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, RouteNames.discover);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
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
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.grey.shade900
                                : Colors.white,
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
                              // Create a ChatRoom object from the conversation data
                              final chatRoom = ChatRoom(
                                id: conversation['id'],
                                userId:
                                    'current_user_id', // You'll need to get the actual user ID
                                matchId: conversation['id'],
                                matchName: conversation['name'],
                                matchImage: conversation['image'],
                                isMatchOnline:
                                    conversation['isOnline'] ?? false,
                                createdAt: DateTime
                                    .now(), // You might want to use actual creation time if available
                                lastActivity: DateTime.now(),
                                unreadCount: conversation['unread'] ?? 0,
                              );

                              // Navigate to chat screen with the ChatRoom object
                              Navigator.pushNamed(
                                context,
                                RouteNames.chat,
                                arguments: chatRoom,
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 28,
                                          backgroundImage: NetworkImage(
                                              conversation['image']),
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
                                                color: isDarkMode
                                                    ? Colors.grey.shade900
                                                    : Colors.white,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              conversation['name'],
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : AppColors
                                                        .textPrimaryLight,
                                                fontWeight:
                                                    conversation['unread'] > 0
                                                        ? FontWeight.bold
                                                        : FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              conversation['time'],
                                              style: TextStyle(
                                                color: conversation['unread'] >
                                                        0
                                                    ? AppColors.primary
                                                    : (isDarkMode
                                                        ? Colors.grey.shade500
                                                        : Colors.grey.shade600),
                                                fontSize: 12,
                                                fontWeight:
                                                    conversation['unread'] > 0
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
                                                  color: conversation[
                                                              'unread'] >
                                                          0
                                                      ? (isDarkMode
                                                          ? Colors.white
                                                          : AppColors
                                                              .textPrimaryLight)
                                                      : (isDarkMode
                                                          ? Colors.grey.shade400
                                                          : Colors
                                                              .grey.shade700),
                                                  fontWeight:
                                                      conversation['unread'] > 0
                                                          ? FontWeight.w500
                                                          : FontWeight.normal,
                                                  fontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            if (conversation['unread'] > 0)
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: const BoxDecoration(
                                                  color: AppColors.primary,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  conversation['unread']
                                                      .toString(),
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
