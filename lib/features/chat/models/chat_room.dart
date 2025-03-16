import 'chat_message.dart';

class ChatRoom {
  final String id;
  final String userId;
  final String matchId;
  final String matchName;
  final String matchImage;
  final bool isMatchOnline;
  final DateTime createdAt;
  final DateTime? lastActivity;
  final ChatMessage? lastMessage;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.userId,
    required this.matchId,
    required this.matchName,
    required this.matchImage,
    this.isMatchOnline = false,
    required this.createdAt,
    this.lastActivity,
    this.lastMessage,
    this.unreadCount = 0,
  });

  ChatRoom copyWith({
    String? id,
    String? userId,
    String? matchId,
    String? matchName,
    String? matchImage,
    bool? isMatchOnline,
    DateTime? createdAt,
    DateTime? lastActivity,
    ChatMessage? lastMessage,
    int? unreadCount,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      matchId: matchId ?? this.matchId,
      matchName: matchName ?? this.matchName,
      matchImage: matchImage ?? this.matchImage,
      isMatchOnline: isMatchOnline ?? this.isMatchOnline,
      createdAt: createdAt ?? this.createdAt,
      lastActivity: lastActivity ?? this.lastActivity,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'matchId': matchId,
      'matchName': matchName,
      'matchImage': matchImage,
      'isMatchOnline': isMatchOnline,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastActivity': lastActivity?.millisecondsSinceEpoch,
      'lastMessage': lastMessage?.toMap(),
      'unreadCount': unreadCount,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      matchId: map['matchId'] ?? '',
      matchName: map['matchName'] ?? '',
      matchImage: map['matchImage'] ?? '',
      isMatchOnline: map['isMatchOnline'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      lastActivity: map['lastActivity'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['lastActivity']) 
          : null,
      lastMessage: map['lastMessage'] != null 
          ? ChatMessage.fromMap(map['lastMessage']) 
          : null,
      unreadCount: map['unreadCount'] ?? 0,
    );
  }
}
