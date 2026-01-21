import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:samadhantra/app/constant/app_color.dart';

class NotificationsController extends GetxController {

  // Notifications list
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxList<NotificationModel> unreadNotifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      notifications.value = [
        NotificationModel(
          id: '1',
          title: 'New Proposal Received',
          message: 'Design Studio Pro has submitted a proposal for your "UI/UX Design" requirement',
          type: 'proposal',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          data: {'requirementId': '123', 'providerId': '456'},
        ),
        NotificationModel(
          id: '2',
          title: 'Requirement Status Updated',
          message: 'Your "Mobile App Development" requirement is now active and visible to providers',
          type: 'status',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          data: {'requirementId': '123'},
        ),
        NotificationModel(
          id: '3',
          title: 'Message Received',
          message: 'Tech Solutions Inc. sent you a new message regarding your project',
          type: 'message',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          data: {'chatId': '789'},
        ),
        NotificationModel(
          id: '4',
          title: 'Proposal Accepted',
          message: 'You have accepted the proposal from Web Masters for "Website Redesign"',
          type: 'accepted',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          data: {'proposalId': '101', 'providerId': '202'},
        ),
        NotificationModel(
          id: '5',
          title: 'Payment Received',
          message: 'Payment of ₹50,000 has been received for project "ERP System Integration"',
          type: 'payment',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          data: {'amount': '50000', 'projectId': '303'},
        ),
        NotificationModel(
          id: '6',
          title: 'Deadline Reminder',
          message: 'Your requirement "Mobile App Development" deadline is in 3 days',
          type: 'reminder',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          data: {'requirementId': '123', 'daysLeft': '3'},
        ),
        NotificationModel(
          id: '7',
          title: 'System Update',
          message: 'New features added: File sharing in chats, advanced filters in requirements',
          type: 'system',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          data: {},
        ),
      ];

      // Update unread notifications list
      updateUnreadList();
      isLoading.value = false;
    });
  }

  void updateUnreadList() {
    unreadNotifications.value = notifications.where((n) => !n.isRead).toList();
  }

  // Mark as read
  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
      updateUnreadList();
    }
  }

  // Mark all as read
  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    notifications.refresh();
    updateUnreadList();

    Get.snackbar(
      'Success',
      'All notifications marked as read',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Delete notification
  void deleteNotification(String notificationId) {
    notifications.removeWhere((n) => n.id == notificationId);
    updateUnreadList();

    Get.snackbar(
      'Deleted',
      'Notification removed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  void showNotificationDetailDialog(NotificationModel notification) {
    // Mark as read when viewing details
    if (!notification.isRead) {
      markAsRead(notification.id);
    }

    Get.dialog(
      NotificationDetailDialog(notification: notification),
      barrierDismissible: true,
    );
  }


  // Clear all notifications
  void clearAllNotifications() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),

        title: Row(
          children: const [
            Icon(
              Icons.notifications_off_rounded,
              color: Colors.red,
              size: 28,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Clear Notifications',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),

        content: const Text(
          'Are you sure you want to clear all notifications?\n\nThis action cannot be undone.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black87,
            height: 1.4,
          ),
        ),

        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actionsAlignment: MainAxisAlignment.spaceBetween,

        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ),

          ElevatedButton.icon(
            onPressed: () {
              notifications.clear();
              unreadNotifications.clear();
              Get.back();

              Get.snackbar(
                'Cleared',
                'All notifications have been cleared',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.blue,
                colorText: Colors.white,
                borderRadius: 12,
                margin: const EdgeInsets.all(12),
              );
            },
            icon: const Icon(Icons.delete_forever),
            label: const Text('Clear All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }


  // Get notification icon
  IconData getNotificationIcon(String type) {
    switch (type) {
      case 'proposal':
        return Icons.request_quote;
      case 'message':
        return Icons.message;
      case 'status':
        return Icons.update;
      case 'accepted':
        return Icons.check_circle;
      case 'payment':
        return Icons.attach_money;
      case 'reminder':
        return Icons.notifications_active;
      case 'system':
        return Icons.system_update;
      default:
        return Icons.notifications;
    }
  }

  // Get notification color
  Color getNotificationColor(String type) {
    switch (type) {
      case 'proposal':
        return Colors.blue;
      case 'message':
        return Colors.green;
      case 'status':
        return Colors.orange;
      case 'accepted':
        return Colors.purple;
      case 'payment':
        return Colors.teal;
      case 'reminder':
        return Colors.red;
      case 'system':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  // Handle notification tap
  void handleNotificationTap(NotificationModel notification) {
    showNotificationDetailDialog(notification);
    // Mark as read first
    // if (!notification.isRead) {
    //   markAsRead(notification.id);
    // }
    //
    // // Navigate based on type
    // switch (notification.type) {
    //   case 'proposal':
    //   case 'accepted':
    //     Get.toNamed(
    //       '/stakeholder/requirement-detail/${notification.data['requirementId']}',
    //     );
    //     break;
    //   case 'message':
    //     Get.toNamed(
    //       '/stakeholder/chat/${notification.data['chatId']}',
    //     );
    //     break;
    //   case 'status':
    //   case 'reminder':
    //     Get.toNamed(
    //       '/stakeholder/requirements',
    //     );
    //     break;
    //   case 'payment':
    //     Get.toNamed(
    //       '/stakeholder/payments',
    //     );
    //     break;
    //   default:
    //   // Do nothing for system notifications
    //     break;
    // }
  }

  // Format date for display
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }
}

class NotificationDetailDialog extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailDialog({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final NotificationsController controller = Get.find<NotificationsController>();
    final color = controller.getNotificationColor(notification.type);
    final icon = controller.getNotificationIcon(notification.type);

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.9),
                      color.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // Icon with glowing effect
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 32,
                          color: color,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title with beautiful typography
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        notification.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Time and status badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          controller.formatDate(notification.createdAt),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            notification.isRead ? 'READ' : 'UNREAD',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Message content
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Message title
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Message',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Message content in card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey[200]!,
                        ),
                      ),
                      child: Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          height: 1.6,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),

                    // Additional details if available
                    if (_hasAdditionalDetails(notification.type)) ...[
                      const SizedBox(height: 28),

                      // Details title
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Details cards
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey[200]!,
                          ),
                        ),
                        child: Column(
                          children: _buildDetailItems(notification.type),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Action buttons
              Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    // Close button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          backgroundColor: Colors.grey[50],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Action button
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: LinearGradient(
                            colors: [
                              color,
                              color.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: double.infinity, // 🔑 IMPORTANT
                          child: ElevatedButton(
                            onPressed: () =>
                                _handleActionButton(notification.type, notification.data),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // 🔑 IMPORTANT
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildActionButtonContent(notification.type),
                            ),
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasAdditionalDetails(String type) {
    return ['proposal', 'message', 'payment', 'reminder', 'status', 'accepted'].contains(type);
  }

  List<Widget> _buildDetailItems(String type) {
    final List<Widget> items = [];

    switch (type) {
      case 'proposal':
        items.addAll([
          _buildDetailCard(
            icon: Icons.description,
            title: 'Requirement',
            value: 'Mobile App Development',
            color: Colors.blue,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildDetailCard(
            icon: Icons.person,
            title: 'Provider',
            value: 'Design Studio Pro',
            color: Colors.green,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildDetailCard(
            icon: Icons.schedule,
            title: 'Submitted',
            value: '30 minutes ago',
            color: Colors.orange,
          ),
        ]);
        break;

      case 'message':
        items.addAll([
          _buildDetailCard(
            icon: Icons.person,
            title: 'From',
            value: 'Tech Solutions Inc.',
            color: Colors.purple,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildDetailCard(
            icon: Icons.topic,
            title: 'Regarding',
            value: 'Mobile App Development',
            color: Colors.teal,
          ),
        ]);
        break;

      case 'payment':
        items.addAll([
          _buildDetailCard(
            icon: Icons.currency_rupee,
            title: 'Amount',
            value: '₹50,000',
            color: Colors.green,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildDetailCard(
            icon: Icons.description,
            title: 'Project',
            value: 'ERP System Integration',
            color: Colors.blue,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildDetailCard(
            icon: Icons.date_range,
            title: 'Date',
            value: 'Jan 15, 2024',
            color: Colors.orange,
          ),
        ]);
        break;

      case 'reminder':
        items.addAll([
          _buildDetailCard(
            icon: Icons.calendar_today,
            title: 'Deadline',
            value: 'Jan 18, 2024',
            color: Colors.red,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildDetailCard(
            icon: Icons.description,
            title: 'Requirement',
            value: 'Mobile App Development',
            color: Colors.blue,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildDetailCard(
            icon: Icons.timer,
            title: 'Time Left',
            value: '3 days',
            color: Colors.orange,
          ),
        ]);
        break;

      case 'status':
        items.addAll([
          _buildDetailCard(
            icon: Icons.description,
            title: 'Requirement',
            value: 'Mobile App Development',
            color: Colors.blue,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildDetailCard(
            icon: Icons.assignment_turned_in,
            title: 'Status',
            value: 'Active',
            color: Colors.green,
          ),
        ]);
        break;

      case 'accepted':
        items.addAll([
          _buildDetailCard(
            icon: Icons.description,
            title: 'Requirement',
            value: 'Website Redesign',
            color: Colors.blue,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildDetailCard(
            icon: Icons.assignment_turned_in,
            title: 'Status',
            value: 'Accepted',
            color: Colors.purple,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildDetailCard(
            icon: Icons.person,
            title: 'Provider',
            value: 'Web Masters',
            color: Colors.teal,
          ),
        ]);
        break;

      case 'system':
        items.addAll([
          _buildDetailCard(
            icon: Icons.update,
            title: 'Update Type',
            value: 'Feature Release',
            color: Colors.indigo,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildDetailCard(
            icon: Icons.date_range,
            title: 'Released',
            value: 'Jan 10, 2024',
            color: Colors.orange,
          ),
        ]);
        break;
    }

    return items;
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 20,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleActionButton(String type, Map<String, dynamic> data) {
    Get.back();

    switch (type) {
      case 'proposal':
      case 'accepted':
        Get.toNamed(
          '/stakeholder/requirement-detail/${data['requirementId']}',
        );
        break;
      case 'message':
        Get.toNamed(
          '/stakeholder/chat/${data['chatId']}',
        );
        break;
      case 'status':
      case 'reminder':
        Get.toNamed('/stakeholder/requirements');
        break;
      case 'payment':
        Get.toNamed('/stakeholder/payments');
        break;
    }
  }

  List<Widget> _buildActionButtonContent(String type) {
    List<Widget> build(String text, IconData icon) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ).children;
    }

    switch (type) {
      case 'proposal':
      case 'accepted':
        return build('View Details', Icons.remove_red_eye);

      case 'message':
        return build('Open Chat', Icons.message);

      case 'status':
      case 'reminder':
        return build('View Requirements', Icons.list_alt);

      case 'payment':
        return build('View Payments', Icons.attach_money);

      default:
        return build('Got it', Icons.check);
    }
  }

}

// Notification Model
class NotificationModel {
  String id;
  String title;
  String message;
  String type;
  bool isRead;
  DateTime createdAt;
  Map<String, dynamic> data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.data,
  });
}