// assignment_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/assignment_screen/assignment_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/data/model/stake_assignment_model.dart';

class AssignmentDetailScreen extends StatefulWidget {
  const AssignmentDetailScreen({Key? key}) : super(key: key);

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  final AssignmentController controller = Get.find<AssignmentController>();
  late String assignmentId;
  bool _hasTriedLoading = false;

  @override
  void initState() {
    super.initState();
    _getArgumentsAndLoadAssignment();
  }

  void _getArgumentsAndLoadAssignment() {
    final dynamic args = Get.arguments;

    print('📦 Received arguments: $args (type: ${args.runtimeType})');

    if (args is String) {
      assignmentId = args;
    } else if (args is Map<String, dynamic>) {
      assignmentId = args['assignmentId']?.toString() ?? '';
    } else if (args != null) {
      assignmentId = args.toString();
    } else {
      assignmentId = '';
    }

    print('🎯 Assignment ID extracted: $assignmentId');

    if (assignmentId.isNotEmpty) {
      _loadAssignment();
    }
  }

  void _loadAssignment() {
    if (!_hasTriedLoading) {
      _hasTriedLoading = true;

      // Small delay to ensure widget is mounted
      Future.delayed(Duration.zero, () {
        if (mounted) {
          final success = controller.selectAssignmentById(assignmentId);
          if (!success) {
            print('❌ Failed to load assignment with ID: $assignmentId');
          }
        }
      });
    }
  }

  void _navigateToReviewScreen(Assignment assignment) {
    Get.toNamed(
      '/reviewService',
      arguments: {
        'assignmentId': assignment.id,
        'assignmentTitle': assignment.requirementTitle,
        'providerId': "1",
        'providerName': assignment.providerName,
      },
    )?.then((reviewSubmitted) {
      // Callback when returning from review screen
      if (reviewSubmitted == true) {
        // Mark assignment as reviewed
        _markAssignmentAsReviewed(assignment.id ?? "");

        // Show success message
        Get.snackbar(
          'Thank You!',
          'Your review has been submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    });
  }

  void _markAssignmentAsReviewed(String assignmentId) {
    // Update the assignment's review status
    // This would typically be an API call to your backend
    // For now, we'll update the local state

    // Get the controller
    final AssignmentController controller = Get.find<AssignmentController>();

    // Find the assignment and mark it as reviewed
    final index = controller.assignments.indexWhere((a) => a.id == assignmentId);
    if (index != -1) {
      final assignment = controller.assignments[index];

      // Create updated assignment (you'll need to update your model to make it mutable)
      // For now, we'll simulate the update
      print('✅ Assignment marked as reviewed: $assignmentId');

      // You might need to refresh the assignment details
      controller.selectAssignmentById(assignmentId);
    }
  }

  void _viewMyReview(Assignment assignment) {
    // Navigate to My Reviews screen
    Get.toNamed('/my-reviews');

    // Optional: You could navigate to a specific review
    // Get.toNamed('/my-reviews', arguments: {'assignmentId': assignment.id});
  }

  void _rateProvider(Assignment assignment) {
    // Show rating dialog
    Get.defaultDialog(
      title: 'Rate ${assignment.providerName}',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'How was your experience with ${assignment.providerName}?',
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: const Icon(Icons.star_border, size: 32),
                onPressed: () {
                  Get.back();
                  _navigateToReviewScreen(assignment);
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(
            'Tap a star to rate',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          _navigateToReviewScreen(assignment);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.appColor,
        ),
        child: const Text('Write Detailed Review'),
      ),
      cancel: TextButton(
        onPressed: Get.back,
        child: const Text('Maybe Later'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Assignment Details",
        isBackButton: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading.value && !_hasTriedLoading) {
        return _buildLoadingState();
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return _buildErrorState(controller.errorMessage.value);
      }

      final assignment = controller.selectedAssignment.value;

      if (assignment == null || assignment.id == null) {
        return _buildEmptyState();
      }

      return _buildAssignmentDetails(assignment);
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.appColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading assignment details...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Assignment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (assignmentId.isNotEmpty) {
                  controller.selectAssignmentById(assignmentId);
                } else {
                  Get.back();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'Go Back',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Assignment Not Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              assignmentId.isNotEmpty
                  ? 'Could not find assignment with ID: $assignmentId'
                  : 'No assignment ID provided',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadAssignment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reload'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'Go Back to Assignments',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentDetails(Assignment assignment) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Info Card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          assignment.requirementTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(assignment.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(assignment.status),
                          ),
                        ),
                        child: Text(
                          assignment.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getStatusColor(assignment.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Provider Info
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.appColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            assignment.providerName.isNotEmpty ? assignment.providerName[0] : '?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.appColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assignment.providerName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Service Provider',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.message, color: AppColors.appColor),
                        onPressed: () {
                          Get.snackbar(
                            'Message',
                            'Messaging feature coming soon',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Project Timeline
                  Row(
                    children: [
                      _buildTimelineItem(
                        icon: Icons.calendar_today,
                        label: 'Assigned',
                        date: assignment.formattedAssignedDate,
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey[300],
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                      _buildTimelineItem(
                        icon: Icons.play_circle_fill,
                        label: 'Started',
                        date: assignment.startDate != null
                            ? '${assignment.startDate!.day}/${assignment.startDate!.month}/${assignment.startDate!.year}'
                            : '-',
                      ),
                      if (assignment.completionDate != null) ...[
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey[300],
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                        _buildTimelineItem(
                          icon: Icons.check_circle,
                          label: 'Completed',
                          date: '${assignment.completionDate!.day}/${assignment.completionDate!.month}/${assignment.completionDate!.year}',
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Budget
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.attach_money, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Project Budget',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '₹${assignment.budget.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.snackbar(
                              'Payments',
                              'Payment details coming soon',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Payment'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ============ REVIEW BUTTON SECTION ============
                  // if (assignment.canBeReviewed)
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToReviewScreen(assignment),
                        icon: const Icon(Icons.star, size: 20),
                        label: const Text(
                          'Review Service',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  // else if (assignment.isReviewed)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'You have already reviewed this service',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _viewMyReview(assignment),
                            child: const Text('View Review'),
                          ),
                        ],
                      ),
                    ),
                  // ============ END OF REVIEW BUTTON SECTION ============
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Milestones
          if (assignment.milestones.isNotEmpty) ...[
            Text(
              'Milestones',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            ...assignment.milestones.map((milestone) => _buildMilestoneCard(milestone)).toList(),
            const SizedBox(height: 20),
          ],

          // Documents
          if (assignment.documents.isNotEmpty) ...[
            Text(
              'Documents',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            ...assignment.documents.map((document) => _buildDocumentCard(document)).toList(),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String label,
    required String date,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.appColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          date,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneCard(Milestone milestone) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getMilestoneColor(milestone.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(
                  _getMilestoneIcon(milestone.status),
                  color: _getMilestoneColor(milestone.status),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milestone.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    milestone.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        'Due: ${milestone.formattedDueDate}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getMilestoneColor(milestone.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                milestone.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: _getMilestoneColor(milestone.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(Document document) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.appColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.insert_drive_file,
            color: AppColors.appColor,
          ),
        ),
        title: Text(document.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Uploaded by: ${document.uploader}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Type: ${document.type}',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.download, color: AppColors.appColor),
          onPressed: () {
            Get.snackbar(
              'Download',
              'Downloading ${document.name}',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'assigned':
        return Colors.blue;
      case 'in-progress':
        return AppColors.appColor;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getMilestoneColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.grey;
      case 'in-progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'delayed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getMilestoneIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'in-progress':
        return Icons.play_circle_fill;
      case 'completed':
        return Icons.check_circle;
      case 'delayed':
        return Icons.error;
      default:
        return Icons.help;
    }
  }
}