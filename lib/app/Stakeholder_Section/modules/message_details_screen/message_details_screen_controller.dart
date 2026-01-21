import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/message_screen/message_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/data/model/stake_message_model.dart';


class MessageThreadController extends GetxController {
  final MessageController _messageController = Get.find();

  // Rx variables
  final RxString selectedMessageId = ''.obs;
  final RxList<MessageThread> currentThreads = <MessageThread>[].obs;
  final Rx<AdminMessage?> currentMessage = Rx<AdminMessage?>(null);
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final messageId = Get.parameters['id'];
    if (messageId != null) {
      selectedMessageId.value = messageId;
      loadMessageThreads();
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void loadMessageThreads() {
    try {
      final message = _messageController.messages.firstWhere(
            (m) => m.id == selectedMessageId.value,
        orElse: () => AdminMessage(
          id: selectedMessageId.value,
          subject: '',
          lastMessage: '',
          lastMessageTime: DateTime.now(),
          unreadCount: 0,
          relatedRequirement: '',
          status: 'new',
          assignedProvider: null,
          threads: [],
        ),
      );

      currentMessage.value = message;
      currentThreads.assignAll(message.threads.reversed.toList());
    } catch (e) {
      Get.snackbar('Error', 'Failed to load message threads');
    }
  }

  void sendMessage(String message) {
    if (message.trim().isEmpty) return;

    final newThread = MessageThread(
      senderName: 'Ayush',
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message.trim(),
      timestamp: DateTime.now(),
      senderType: 'user',
      isRead: false,
      attachments: [],
    );

    currentThreads.insert(0, newThread);

    // Update the original message in MessageController
    final updatedThreads = List<MessageThread>.from(currentThreads.reversed);
    _messageController.updateMessageThreads(
      selectedMessageId.value,
      updatedThreads,
    );

    messageController.clear();
  }

  void markAsResolved(String messageId) {
    _messageController.updateMessageStatus(messageId, 'resolved');
    currentMessage.value = currentMessage.value?.copyWith(status: 'resolved');
    Get.snackbar('Success', 'Marked as resolved');
  }

  void deleteMessage(String messageId) {
    _messageController.deleteMessage(messageId);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'in-progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void attachFile() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.document_scanner, color: AppColors.appColor),
              title: Text('Document'),
              subtitle: Text('Upload PDF, DOC, TXT files'),
              onTap: () => uploadDocument(),
            ),
            ListTile(
              leading: Icon(Icons.image, color: AppColors.appColor),
              title: Text('Image'),
              subtitle: Text('Upload JPG, PNG files'),
              onTap: () => uploadImage(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void uploadDocument() {
    Get.back();
    // Implement document upload
    Get.snackbar('Info', 'Document upload feature coming soon');
  }

  void uploadImage() {
    Get.back();
    // Implement image upload
    Get.snackbar('Info', 'Image upload feature coming soon');
  }

  void showDeleteDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Conversation'),
        content: Text('Are you sure you want to delete this conversation?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              deleteMessage(selectedMessageId.value);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}