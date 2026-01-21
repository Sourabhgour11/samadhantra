class AdminMessage {
  final String id;
  final String subject;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String relatedRequirement;
  final String status; // 'new', 'pending', 'in-progress', 'resolved'
  final String? assignedProvider;
  final List<MessageThread> threads;

  AdminMessage({
    required this.id,
    required this.subject,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.relatedRequirement,
    required this.status,
    this.assignedProvider,
    required this.threads,
  });

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(lastMessageTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${lastMessageTime.day}/${lastMessageTime.month}/${lastMessageTime.year}';
    }
  }

  factory AdminMessage.fromJson(Map<String, dynamic> json) {
    return AdminMessage(
      id: json['id'],
      subject: json['subject'],
      lastMessage: json['last_message'],
      lastMessageTime: DateTime.parse(json['last_message_time']),
      unreadCount: json['unread_count'],
      relatedRequirement: json['related_requirement'],
      status: json['status'],
      assignedProvider: json['assigned_provider'],
      threads: (json['threads'] as List).map((e) => MessageThread.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime.toIso8601String(),
      'unread_count': unreadCount,
      'related_requirement': relatedRequirement,
      'status': status,
      'assigned_provider': assignedProvider,
      'threads': threads.map((e) => e.toJson()).toList(),
    };
  }
}

class MessageThread {
  final String id;
  final String senderType; // 'stakeholder', 'admin'
  final String senderName;
  final String message;
  final DateTime timestamp;
  final List<String> attachments;
  final bool isRead;

  MessageThread({
    required this.id,
    required this.senderType,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.attachments = const [],
    this.isRead = false,
  });

  factory MessageThread.fromJson(Map<String, dynamic> json) {
    return MessageThread(
      id: json['id'],
      senderType: json['sender_type'],
      senderName: json['sender_name'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      attachments: List<String>.from(json['attachments'] ?? []),
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_type': senderType,
      'sender_name': senderName,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'attachments': attachments,
      'is_read': isRead,
    };
  }
}