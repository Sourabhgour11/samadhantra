import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_camera_popup.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class CompleteProfileController extends GetxController {
  // Form fields
  final companyNameController = TextEditingController();
  final referenceController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final aboutController = TextEditingController();

  // Observable variables
  var selectedRole = ''.obs;
  var companyLogo = Rx<File?>(null);
  var companyLogoUrl = ''.obs;
  var isLoading = false.obs;
  var isUploading = false.obs;

  // Validation
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Get role from previous screen
    selectedRole.value = Get.arguments?['role'] ?? '';
    // Initialize phone with country code
    // phoneController.text = '+91 ';
  }

  @override
  void onClose() {
    companyNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    aboutController.dispose();
    super.onClose();
  }

  // Pick image from gallery
  Future<void> pickCompanyLogo() async {
    final File? image = await AppCameraDialog.show();

    if (image != null) {
      companyLogo.value = image;
      companyLogoUrl.value = ''; // clear network image if any
    }
  }

  // Simulate upload to server
  Future<void> uploadCompanyLogo(File file) async {
    isUploading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // In real app, upload to your server and get URL
    companyLogoUrl.value = 'https://example.com/uploads/${DateTime.now().millisecondsSinceEpoch}.jpg';

    isUploading.value = false;

    Get.snackbar(
      'Success',
      'Company logo uploaded successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Remove selected logo
  void removeCompanyLogo() {
    companyLogo.value = null;
    companyLogoUrl.value = '';
  }

  // Validate phone number
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 10) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  // Validate required field
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < 3) {
      return '$fieldName must be at least 3 characters';
    }
    return null;
  }

  // Submit form
  Future<void> completeProfile() async {
    if (!formKey.currentState!.validate()) {
      Get.toNamed(AppRoutes.bottomnavScreen);
      return;
    }

    isLoading.value = true;

    try {
      // Prepare data
      final profileData = {
        'role': selectedRole.value,
        'companyName': companyNameController.text.trim(),
        'location': addressController.text.trim(),
        'phone': phoneController.text.trim(),
        'about': aboutController.text.trim(),
        'logoUrl': companyLogoUrl.value,
      };

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Save to local storage (shared preferences)
      // await storage.write('user_profile', profileData);

      Get.snackbar(
        'Success!',
        'Profile completed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate to dashboard
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed('/dashboard');

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get role display text
  String get roleDisplayText {
    switch (selectedRole.value.toLowerCase()) {
      case 'startup': return 'Startup Founder';
      case 'msme': return 'MSME Owner';
      case 'corporate': return 'Corporate Representative';
      case 'institute': return 'Institute Admin';
      case 'student': return 'Student';
      case 'freelancer': return 'Freelancer';
      case 'vendor': return 'Vendor';
      default: return 'User';
    }
  }

  // Get hint text for about field based on role
  String get aboutHintText {
    switch (selectedRole.value.toLowerCase()) {
      case 'startup': return 'Tell us about your startup...';
      case 'msme': return 'Tell us about your business...';
      case 'corporate': return 'Tell us about your company...';
      case 'institute': return 'Tell us about your institute...';
      case 'student': return 'Tell us about yourself...';
      case 'freelancer': return 'Tell us about your services...';
      case 'vendor': return 'Tell us about your products...';
      default: return 'Tell us about yourself...';
    }
  }
}