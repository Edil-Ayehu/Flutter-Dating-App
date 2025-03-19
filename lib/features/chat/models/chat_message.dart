import 'package:flutter_dating_app/core/enums/message_type.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final String? mediaUrl;
  final MessageType messageType;
    final String? replyToId;      // ID of the message being replied to
  final String? replyToContent; // Content of the message being replied to
  final String? replyToSenderId; // Sender ID of the message being replied to

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.mediaUrl,
    this.messageType = MessageType.text,
        this.replyToId,
    this.replyToContent,
    this.replyToSenderId,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    DateTime? timestamp,
    bool? isRead,
    String? mediaUrl,
    MessageType? messageType,
        String? replyToId,
    String? replyToContent,
    String? replyToSenderId,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      messageType: messageType ?? this.messageType,
      replyToId: replyToId ?? this.replyToId,
      replyToContent: replyToContent ?? this.replyToContent,
      replyToSenderId: replyToSenderId ?? this.replyToSenderId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isRead': isRead,
      'mediaUrl': mediaUrl,
      'messageType': MessageType.typeToString(messageType),
            'replyToId': replyToId,
      'replyToContent': replyToContent,
      'replyToSenderId': replyToSenderId,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      content: map['content'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      isRead: map['isRead'] ?? false,
      mediaUrl: map['mediaUrl'],
      messageType: map['messageType'] != null 
          ? MessageType.fromString(map['messageType']) 
          : MessageType.text,
      replyToId: map['replyToId'],
      replyToContent: map['replyToContent'],
      replyToSenderId: map['replyToSenderId'],
    );
  }
}
