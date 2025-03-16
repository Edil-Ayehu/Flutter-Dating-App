import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

class ChatSearchScreen extends StatefulWidget {
  const ChatSearchScreen({Key? key}) : super(key: key);

  @override
  State<ChatSearchScreen> createState() => _ChatSearchScreenState();
}

class _ChatSearchScreenState extends State<ChatSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  // Sample data - in a real app, this would come from your chat provider
  final List<Map<String, dynamic>> _allConversations = [
    {
      'id': '1',
      'name': 'Jessica',
      'lastMessage': 'Hey, how are you doing?',
      'time': '10:30 AM',
      'unread': 2,
      'isOnline': true,
      'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
    },
    {
      'id': '2',
      'name': 'Michael',
      'lastMessage': 'Let\'s meet tomorrow',
      'time': '9:15 AM',
      'unread': 0,
      'isOnline': false,
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
    },
    {
      'id': '3',
      'name': 'Sophia',
      'lastMessage': 'The movie was great!',
      'time': 'Yesterday',
      'unread': 0,
      'isOnline': true,
      'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
    },
    {
      'id': '4',
      'name': 'David',
      'lastMessage': 'Thanks for the coffee recommendation',
      'time': 'Yesterday',
      'unread': 1,
      'isOnline': false,
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _isSearching = query.isNotEmpty;
      if (_isSearching) {
        _searchResults = _allConversations.where((conversation) {
          return conversation['name'].toLowerCase().contains(query) ||
              conversation['lastMessage'].toLowerCase().contains(query);
        }).toList();
      } else {
        _searchResults = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search conversations...',
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              fontSize: 16,
            ),
            border: InputBorder.none,
          ),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.grey.shade800,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: Icon(
                Icons.clear,
                color: isDarkMode ? Colors.white : Colors.grey.shade800,
              ),
              onPressed: () {
                _searchController.clear();
              },
            ),
        ],
      ),
      body: _isSearching
          ? ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final conversation = _searchResults[index];
                return ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(conversation['image']),
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
                  title: Text(
                    conversation['name'],
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : AppColors.textPrimaryLight,
                      fontWeight: conversation['unread'] > 0
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    conversation['lastMessage'],
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
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
                          color: conversation['unread'] > 0
                              ? AppColors.primary
                              : (isDarkMode
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade600),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (conversation['unread'] > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
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
                  onTap: () {
                    // Navigate to chat screen
                    Navigator.pop(context, conversation['id']);
                  },
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 80,
                    color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Search for conversations',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
