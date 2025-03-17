enum MessageType {
  text,
  image,
  audio,
  video,
  location,
  contact,
  system;
  
  // Returns a string representation of the message type
  static String typeToString(MessageType type) {
    switch (type) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.audio:
        return 'audio';
      case MessageType.video:
        return 'video';
      case MessageType.location:
        return 'location';
      case MessageType.contact:
        return 'contact';
      case MessageType.system:
        return 'system';
      default:
        return 'text';
    }
  }
  
  // Converts a string to MessageType
  static MessageType fromString(String value) {
    switch (value) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'audio':
        return MessageType.audio;
      case 'video':
        return MessageType.video;
      case 'location':
        return MessageType.location;
      case 'contact':
        return MessageType.contact;
      case 'system':
        return MessageType.system;
      default:
        return MessageType.text;
    }
  }
}
