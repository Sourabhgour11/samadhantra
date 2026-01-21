import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/data/model/stake_message_model.dart';

class MessageController extends GetxController {
  static MessageController get instance => Get.find();

  final RxList<AdminMessage> messages = <AdminMessage>[].obs;
  final RxList<MessageThread> currentThreads = <MessageThread>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedMessageId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  // app/modules/message/controllers/message_controller.dart

  // Add these methods to your existing MessageController

  void updateMessageThreads(String messageId, List<MessageThread> threads) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final updatedMessage = messages[index].copyWith(threads: threads);
      messages[index] = updatedMessage;
      update();
    }
  }

  void updateMessageStatus(String messageId, String status) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final updatedMessage = messages[index].copyWith(status: status);
      messages[index] = updatedMessage;
      update();
    }
  }

  void deleteMessage(String messageId) {
    messages.removeWhere((m) => m.id == messageId);
    update();
  }

  void loadMessages() {
    isLoading.value = true;

    // Mock data - Replace with API call
    messages.value = [
      AdminMessage(
        id: '1',
        subject: 'Service Provider Shortlisted',
        lastMessage: 'We have shortlisted 3 providers for your requirement...',
        lastMessageTime: DateTime.now().subtract(Duration(minutes: 30)),
        unreadCount: 2,
        relatedRequirement: 'Mobile App Development',
        status: 'new',
        assignedProvider: null,
        threads: [],
      ),
      AdminMessage(
        id: '2',
        subject: 'Requirement Clarification Needed',
        lastMessage: 'Can you provide more details about the timeline?',
        lastMessageTime: DateTime.now().subtract(Duration(hours: 2)),
        unreadCount: 0,
        relatedRequirement: 'UI/UX Design',
        status: 'pending',
        assignedProvider: null,
        threads: [],
      ),
      AdminMessage(
        id: '3',
        subject: 'Provider Assigned Successfully',
        lastMessage: 'Tech Solutions Inc. has been assigned to your project',
        lastMessageTime: DateTime.now().subtract(Duration(days: 1)),
        unreadCount: 0,
        relatedRequirement: 'Website Redesign',
        status: 'resolved',
        assignedProvider: 'Tech Solutions Inc.',
        threads: [],
      ),
    ];

    isLoading.value = false;
  }

  void loadMessageThreads(String messageId) {
    selectedMessageId.value = messageId;

    // Mock data - Replace with API call
    currentThreads.value = [
      MessageThread(
        id: '1',
        senderType: 'admin',
        senderName: 'Samadhantra Admin',
        message: 'Hello! We have received your requirement for Mobile App Development.',
        timestamp: DateTime.now().subtract(Duration(days: 3)),
        attachments: [],
        isRead: true,
      ),
      MessageThread(
        id: '2',
        senderType: 'stakeholder',
        senderName: 'You',
        message: 'Thank you! When can we expect the shortlisted providers?',
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        attachments: [],
        isRead: true,
      ),
      MessageThread(
        id: '3',
        senderType: 'admin',
        senderName: 'Samadhantra Admin',
        message: 'We have shortlisted 3 providers. They will submit proposals within 24 hours.',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        attachments: [],
        isRead: true,
      ),
      MessageThread(
        id: '4',
        senderType: 'stakeholder',
        senderName: 'You',
        message: 'That sounds good. Please keep me updated.',
        timestamp: DateTime.now().subtract(Duration(hours: 12)),
        attachments: [],
        isRead: true,
      ),
    ];
  }

  void sendMessage(String message, {List<String> attachments = const []}) {
    final newThread = MessageThread(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderType: 'stakeholder',
      senderName: 'You',
      message: message,
      timestamp: DateTime.now(),
      attachments: attachments,
      isRead: true,
    );

    currentThreads.insert(0, newThread);

    // Update last message in messages list
    final index = messages.indexWhere((m) => m.id == selectedMessageId.value);
    if (index != -1) {
      messages[index] = messages[index].copyWith(
        lastMessage: message,
        lastMessageTime: DateTime.now(),
      );
    }
  }

  void markAsRead(String messageId) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(unreadCount: 0);
    }
  }

  void markAsResolved(String messageId) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(status: 'resolved');
      Get.snackbar(
        'Success',
        'Conversation marked as resolved',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  // In your existing MessageController (app/modules/message/controllers/message_controller.dart)

  void createNewMessage({
    required String subject,
    required String message,
    required String requirementId,
    List<String> attachments = const [],
  }) {
    final newMessage = AdminMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subject: subject,
      lastMessage: message,
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
      relatedRequirement: requirementId,
      status: 'new',
      assignedProvider: null,
      threads: [
        MessageThread(senderName: 'ayush',
          id: '1',
          message: message,
          timestamp: DateTime.now(),
          senderType: 'user',
          isRead: true,
          attachments: attachments,
        ),
      ],
    );

    messages.insert(0, newMessage);
    update();

    // You might want to call an API here
    // await _messageRepository.createMessage(newMessage);
  }

  List<AdminMessage> get filteredMessages {
    if (searchQuery.value.isEmpty) return messages;

    return messages.where((msg) {
      return msg.subject.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          msg.relatedRequirement.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

//   void createNewMessage({
//     required String subject,
//     required String message,
//     required String requirementId,
//     List<String> attachments = const [],
//   }) {
//     final newMessage = AdminMessage(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       subject: subject,
//       lastMessage: message,
//       lastMessageTime: DateTime.now(),
//       unreadCount: 0,
//       relatedRequirement: requirementId,
//       status: 'new',
//       assignedProvider: null,
//       threads: [
//         MessageThread(
//           id: '1',
//           senderType: 'stakeholder',
//           senderName: 'You',
//           message: message,
//           timestamp: DateTime.now(),
//           attachments: attachments,
//         ),
//       ],
//     );
//
//     messages.insert(0, newMessage);
//
//     Get.back();
//     Get.snackbar(
//       'Success',
//       'Message sent to admin',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//   }
}

// Extension for copyWith method
extension AdminMessageExtension on AdminMessage {
  AdminMessage copyWith({
    String? id,
    String? subject,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    String? relatedRequirement,
    String? status,
    String? assignedProvider,
    List<MessageThread>? threads,
  }) {
    return AdminMessage(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      relatedRequirement: relatedRequirement ?? this.relatedRequirement,
      status: status ?? this.status,
      assignedProvider: assignedProvider ?? this.assignedProvider,
      threads: threads ?? this.threads,
    );
  }
}