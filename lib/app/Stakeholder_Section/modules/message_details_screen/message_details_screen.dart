import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/data/model/stake_message_model.dart';
import 'message_details_screen_controller.dart';

class MessageThreadScreen extends StatelessWidget {
  const MessageThreadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: "Conversation with Admin",
      isBackButton: true,
      actions: [
        GetBuilder<MessageThreadController>(
          builder: (controller) => PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,color: AppColors.white,),
            onSelected: (value) => _handleMenuAction(value, controller),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'mark_resolved',
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text('Mark as Resolved'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Delete Conversation'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return GetBuilder<MessageThreadController>(
      builder: (controller) => Column(
        children: [
          _buildHeader(controller),
          _buildMessageList(controller),
          _buildMessageInput(controller),
        ],
      ),
    );
  }

  Widget _buildHeader(MessageThreadController controller) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        // border: Border(bottom: BorderSide(color: Colors.grey[200])),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.appColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.admin_panel_settings,
              color: AppColors.appColor,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Samadhantra Admin",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 2),
                Obx(() => Text(
                  controller.currentMessage.value?.relatedRequirement != null
                      ? "Regarding: ${controller.currentMessage.value!.relatedRequirement}"
                      : "Regarding: General Inquiry",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                )),
              ],
            ),
          ),
          Obx(() {
            final status = controller.currentMessage.value?.status ?? 'new';
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: controller.getStatusColor(status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: controller.getStatusColor(status)),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: controller.getStatusColor(status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMessageList(MessageThreadController controller) {
    return Expanded(
      child: Obx(() => ListView.builder(
        padding: EdgeInsets.all(16),
        reverse: true,
        itemCount: controller.currentThreads.length,
        itemBuilder: (context, index) {
          final thread = controller.currentThreads[index];
          return _buildMessageBubble(thread, controller);
        },
      )),
    );
  }

  Widget _buildMessageBubble(MessageThread thread, MessageThreadController controller) {
    final bool isAdmin = thread.senderType == 'admin';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isAdmin ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAdmin)
            Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.appColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.admin_panel_settings,
                size: 16,
                color: AppColors.appColor,
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: isAdmin ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                if (thread.attachments.isNotEmpty)
                  ...thread.attachments.map((attachment) =>
                      Container(
                        margin: EdgeInsets.only(bottom: 4),
                        child: _buildAttachment(attachment),
                      ),
                  ).toList(),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isAdmin ? Colors.grey[100] : AppColors.appColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isAdmin ? Colors.transparent : AppColors.appColor.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    thread.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: isAdmin ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: [
                    Text(
                      controller.formatTime(thread.timestamp),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                    if (!isAdmin) ...[
                      SizedBox(width: 4),
                      Icon(
                        thread.isRead ? Icons.done_all : Icons.done,
                        size: 12,
                        color: thread.isRead ? Colors.blue : Colors.grey[400],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachment(String attachment) {
    return Container(
      width: 200,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: Colors.grey[300]),
      ),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file, color: AppColors.appColor, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.split('/').last,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                Text(
                  'PDF Document',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.download, size: 16),
            onPressed: () {
              // Implement download functionality
              Get.snackbar('Info', 'Download feature coming soon');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(MessageThreadController controller) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border(top: BorderSide(color: Colors.grey[200])),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: AppColors.appColor),
            onPressed: controller.attachFile,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: controller.messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: InputBorder.none,
                ),
                maxLines: null,
                onSubmitted: (value) {
                  controller.sendMessage(value);
                },
              ),
            ),
          ),
          SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.appColor,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: () => controller.sendMessage(
                controller.messageController.text.trim(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, MessageThreadController controller) {
    switch (action) {
      case 'mark_resolved':
        controller.markAsResolved(controller.selectedMessageId.value);
        break;
      case 'delete':
        controller.showDeleteDialog();
        break;
    }
  }
}