import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_camera_popup.dart';

class PostRequirementController extends GetxController {
  // Form controllers
  final titleController = TextEditingController();
  final problemController = TextEditingController();
  final outcomeController = TextEditingController();
  final budgetRangeController = TextEditingController();

  // Form fields
  RxString selectedStakeholder = 'Startup'.obs;
  RxString selectedRequirementTitle = ''.obs;
  RxString selectedTimeline = 'Within 30 days'.obs;
  RxString budgetMin = '10000'.obs;
  RxString budgetMax = '50000'.obs;
  RxString selectedLocation = ''.obs;

  // Engagement type (multiple selection)
  var selectedEngagementTypes = <String>[].obs;

  // Urgency level
  RxString selectedUrgency = 'Flexible'.obs;

  // Observable variables
  var attachments = <File>[].obs;
  var isLoading = false.obs;

  // Stakeholder types
  final stakeholders = [
    'Startup',
    'Small Business',
    'Enterprise',
    'Individual',
    'Non-Profit',
    'Government',
  ];

  // Requirement titles
  final requirementTitles = [
    'Mobile App Development',
    'Website Development',
    'Software Development',
    'UI/UX Design',
    'Digital Marketing',
    'Content Writing',
    'Data Analysis',
    'AI/ML Solution',
    'Consulting Services',
    'Other',
  ];

  // Timeline options
  final timelines = [
    'Within 7 days',
    'Within 15 days',
    'Within 30 days',
    'Within 60 days',
    'Within 90 days',
    'Flexible',
  ];

  // Budget options (predefined)
  final budgetRanges = [
    '₱ 5,000 – 20,000',
    '₱ 10,000 – 50,000',
    '₱ 25,000 – 100,000',
    '₱ 50,000 – 200,000',
    '₱ 100,000+',
    'Custom',
  ];

  // Engagement types
  final engagementTypes = [
    'One-time',
    'Short-term',
    'Long-term',
    'Subscription',
    'Pilot / PoC',
  ];

  // Urgency levels
  final urgencyLevels = [
    'Immediate',
    '30 Days',
    '1–3 Months',
    'Flexible',
  ];

  // Form key
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    titleController.dispose();
    problemController.dispose();
    outcomeController.dispose();
    super.onClose();
  }

  // Set budget from predefined range
  void setBudgetFromRange(String range) {
    if (range == 'Custom') {
      budgetMin.value = '';
      budgetMax.value = '';
      return;
    }

    final regex = RegExp(r'₱\s*([\d,]+)\s*–\s*₱\s*([\d,]+)');
    final match = regex.firstMatch(range);

    if (match != null) {
      budgetMin.value = match.group(1)!.replaceAll(',', '');
      budgetMax.value = match.group(2)!.replaceAll(',', '');
    }
  }

  // Get current budget range display
  String get budgetDisplay {
    if (budgetMin.value.isEmpty || budgetMax.value.isEmpty) {
      return 'Select Budget Range';
    }
    return '₱ ${_formatNumber(budgetMin.value)} – ₱ ${_formatNumber(budgetMax.value)}';
  }

  String _formatNumber(String number) {
    if (number.isEmpty) return '0';
    final num = int.tryParse(number) ?? 0;
    return num.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
    );
  }

  // Toggle engagement type
  void toggleEngagementType(String type) {
    if (selectedEngagementTypes.contains(type)) {
      selectedEngagementTypes.remove(type);
    } else {
      selectedEngagementTypes.add(type);
    }
  }

  // Add attachment (Camera / Gallery popup)
  Future<void> addAttachment() async {
    try {
      final File? file = await AppCameraDialog.show();
      if (file != null) {
        attachments.add(file);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add attachment');
    }
  }

  // Remove attachment
  void removeAttachment(int index) {
    attachments.removeAt(index);
  }

  // Validate form
  bool validateForm() {
    if (selectedRequirementTitle.value.isEmpty) {
      Get.snackbar('Error', 'Please select a requirement title');
      return false;
    }
    if (problemController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please describe your problem/need');
      return false;
    }
    if (outcomeController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please describe the expected outcome');
      return false;
    }
    if (selectedEngagementTypes.isEmpty) {
      Get.snackbar('Error', 'Please select at least one engagement type');
      return false;
    }
    if (budgetMin.value.isEmpty || budgetMax.value.isEmpty) {
      Get.snackbar('Error', 'Please set a budget range');
      return false;
    }
    return true;
  }

  // Submit requirement
  Future<void> submitRequirement() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      // Prepare data
      final requirementData = {
        'stakeholder': selectedStakeholder.value,
        'title': selectedRequirementTitle.value,
        'problem': problemController.text.trim(),
        'expected_outcome': outcomeController.text.trim(),
        'timeline': selectedTimeline.value,
        'budget_min': budgetMin.value,
        'budget_max': budgetMax.value,
        'budget_range': budgetDisplay,
        'location': selectedLocation.value,
        'engagement_types': selectedEngagementTypes.toList(),
        'urgency': selectedUrgency.value,
        'attachments': attachments.map((file) => file.path).toList(),
        'status': 'active',
        'created_at': DateTime.now().toIso8601String(),
      };

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success!',
        'Requirement posted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Clear form
      clearForm();

      // Navigate back to dashboard
      await Future.delayed(const Duration(seconds: 1));
      Get.back();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to post requirement: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form
  void clearForm() {
    selectedStakeholder.value = 'Startup';
    selectedRequirementTitle.value = '';
    problemController.clear();
    outcomeController.clear();
    selectedTimeline.value = 'Within 30 days';
    budgetMin.value = '10000';
    budgetMax.value = '50000';
    selectedLocation.value = '';
    selectedEngagementTypes.clear();
    selectedUrgency.value = 'Flexible';
    attachments.clear();
  }
}