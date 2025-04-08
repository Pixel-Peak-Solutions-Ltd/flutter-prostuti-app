// Model for conversations based on the API documentation
class ConversationsResponse {
  final bool? success;
  final String? message;
  final List<Conversation>? data;

  ConversationsResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ConversationsResponse.fromJson(Map<String, dynamic> json) {
    return ConversationsResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? List<Conversation>.from(
              json['data'].map((x) => Conversation.fromJson(x)))
          : null,
    );
  }
}

class Conversation {
  final String? id;
  final String? studentId;
  final String? message;
  final String? subject;
  final String? status;
  final String? acceptedBy;
  final String? conversationId;
  final String? expiryTime;
  final String? createdAt;
  final String? updatedAt;
  final Participant? participant;
  final LastMessage? lastMessage;

  Conversation({
    this.id,
    this.studentId,
    this.message,
    this.subject,
    this.status,
    this.acceptedBy,
    this.conversationId,
    this.expiryTime,
    this.createdAt,
    this.updatedAt,
    this.participant,
    this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id'],
      studentId: json['student_id'],
      message: json['message'],
      subject: json['subject'],
      status: json['status'],
      acceptedBy: json['accepted_by'],
      conversationId: json['conversation_id'],
      expiryTime: json['expiry_time'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      participant: json['participant'] != null
          ? Participant.fromJson(json['participant'])
          : null,
      lastMessage: json['lastMessage'] != null
          ? LastMessage.fromJson(json['lastMessage'])
          : null,
    );
  }
}

class Participant {
  final String? name;
  final String? profileImage;

  Participant({
    this.name,
    this.profileImage,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      name: json['name'],
      profileImage: json['profileImage'],
    );
  }
}

class LastMessage {
  final String? id;
  final String? senderId;
  final String? senderRole;
  final String? recipientId;
  final String? conversationId;
  final String? message;
  final bool? read;
  final String? createdAt;

  LastMessage({
    this.id,
    this.senderId,
    this.senderRole,
    this.recipientId,
    this.conversationId,
    this.message,
    this.read,
    this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
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
}
