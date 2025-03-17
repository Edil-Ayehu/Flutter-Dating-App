enum NotificationType {
  match,
  like,
  message,
  system,
}

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String time;
  final String? image;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    this.image,
    this.isRead = false,
  });

  // Convert NotificationType to string
  static String typeToString(NotificationType type) {
    switch (type) {
      case NotificationType.match:
        return 'match';
      case NotificationType.like:
        return 'like';
      case NotificationType.message:
        return 'message';
      case NotificationType.system:
        return 'system';
      default:
        return 'system';
    }
  }

  // Convert string to NotificationType
  static NotificationType stringToType(String typeStr) {
    switch (typeStr) {
      case 'match':
        return NotificationType.match;
      case 'like':
        return NotificationType.like;
      case 'message':
        return NotificationType.message;
      case 'system':
        return NotificationType.system;
      default:
        return NotificationType.system;
    }
  }

  // Convert from Map (for API responses)
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      type: stringToType(map['type'] ?? 'system'),
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      time: map['time'] ?? '',
      image: map['image'],
      isRead: map['isRead'] ?? false,
    );
  }

  // Convert to Map (for API requests)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': typeToString(type),
      'title': title,
      'message': message,
      'time': time,
      'image': image,
      'isRead': isRead,
    };
  }

  // Create a copy with some fields changed
  NotificationModel copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    String? time,
    String? image,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      image: image ?? this.image,
      isRead: isRead ?? this.isRead,
    );
  }
}
