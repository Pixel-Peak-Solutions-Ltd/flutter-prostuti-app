// Model for chat messages based on the API documentation
class ChatMessagesResponse {
  final bool? success;
  final String? message;
  final ChatMessageData? data;

  ChatMessagesResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ChatMessagesResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessagesResponse(
      success: json['success'],
      message: json['message'],
      data:
          json['data'] != null ? ChatMessageData.fromJson(json['data']) : null,
    );
  }
}

class ChatMessageData {
  final List<ChatMessage>? messages;
  final int? total;

  ChatMessageData({
    this.messages,
    this.total,
  });

  factory ChatMessageData.fromJson(Map<String, dynamic> json) {
    return ChatMessageData(
      messages: json['messages'] != null
          ? List<ChatMessage>.from(
              json['messages'].map((x) => ChatMessage.fromJson(x)))
          : null,
      total: json['total'],
    );
  }
}

class ChatMessage {
  final String? id;
  final String? senderId;
  final String? senderRole;
  final String? recipientId;
  final String? conversationId;
  final String? message;
  final bool? read;
  final String? createdAt;

  ChatMessage({
    this.id,
    this.senderId,
    this.senderRole,
    this.recipientId,
    this.conversationId,
    this.message,
    this.read,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'],
      senderId: json['sender_id'],
      senderRole: json['sender_role'],
      recipientId: json['recipient_id'],
      conversationId: json['conversation_id'],
      message: json['message'],
      read: json['read'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender_id': senderId,
      'sender_role': senderRole,
      'recipient_id': recipientId,
      'conversation_id': conversationId,
      'message': message,
      'read': read,
      'createdAt': createdAt,
    };
  }
}

class UnreadCountResponse {
  final bool? success;
  final String? message;
  final UnreadCountData? data;

  UnreadCountResponse({
    this.success,
    this.message,
    this.data,
  });

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponse(
      success: json['success'],
      message: json['message'],
      data:
          json['data'] != null ? UnreadCountData.fromJson(json['data']) : null,
    );
  }
}

class UnreadCountData {
  final int? total;
  final List<ConversationUnreadCount>? conversations;

  UnreadCountData({
    this.total,
    this.conversations,
  });

  factory UnreadCountData.fromJson(Map<String, dynamic> json) {
    return UnreadCountData(
      total: json['total'],
      conversations: json['conversations'] != null
          ? List<ConversationUnreadCount>.from(json['conversations']
              .map((x) => ConversationUnreadCount.fromJson(x)))
          : null,
    );
  }
}

class ConversationUnreadCount {
  final String? id;
  final int? count;
  final ChatMessage? lastMessage;

  ConversationUnreadCount({
    this.id,
    this.count,
    this.lastMessage,
  });

  factory ConversationUnreadCount.fromJson(Map<String, dynamic> json) {
    return ConversationUnreadCount(
      id: json['_id'],
      count: json['count'],
      lastMessage: json['lastMessage'] != null
          ? ChatMessage.fromJson(json['lastMessage'])
          : null,
    );
  }
}
