// lib/app/modules/stakeholder/views/profile/controllers/profile_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  // User Profile Data
  final companyName = 'Tech Innovations Ltd.'.obs;
  final companyEmail = 'contact@techinnovations.com'.obs;
  final companyPhone = '+91 9876543210'.obs;
  final companyLocation = 'Mumbai, Maharashtra, India'.obs;
  final companyAbout = 'We are a technology company focused on innovative solutions...'.obs;
  final companyLogo = Rx<File?>(null);
  final companyLogoUrl = ''.obs;

  // Settings
  final RxBool emailNotifications = true.obs;
  final RxBool pushNotifications = true.obs;
  final RxBool smsNotifications = false.obs;

  // Security
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isUploadingLogo = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfileData();
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void _loadProfileData() {
    // Load from SharedPreferences or API
    // Mock data for now
    companyLogoUrl.value = 'https://example.com/logo.png';
  }

  // Pick and upload company logo
  Future<void> pickCompanyLogo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
      );

      if (image != null) {
        final file = File(image.path);
        companyLogo.value = file;
        await uploadCompanyLogo(file);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> uploadCompanyLogo(File file) async {
    isUploadingLogo.value = true;

    // Simulate upload
    await Future.delayed(const Duration(seconds: 2));

    companyLogoUrl.value = 'https://example.com/uploads/${DateTime.now().millisecondsSinceEpoch}.png';
    isUploadingLogo.value = false;

    Get.snackbar(
      'Success',
      'Logo updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Update profile
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? location,
    String? about,
  }) async {
    isLoading.value = true;

    try {
      // Update locally
      if (name != null) companyName.value = name;
      if (email != null) companyEmail.value = email;
      if (phone != null) companyPhone.value = phone;
      if (location != null) companyLocation.value = location;
      if (about != null) companyAbout.value = about;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Change password
  Future<void> changePassword() async {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'New passwords do not match');
      return;
    }

    if (newPasswordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear fields
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change password: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Edit profile section
  void editSection(String section) {
    switch (section) {
      case 'company':
        _showEditCompanyDialog();
        break;
      case 'contact':
        _showEditContactDialog();
        break;
      case 'about':
        _showEditAboutDialog();
        break;
    }
  }

  void _showEditCompanyDialog() {
    final nameController = TextEditingController(text: companyName.value);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Edit Company Name'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Company Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                updateProfile(name: nameController.text);
                Get.back();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditContactDialog() {
    final emailController = TextEditingController(text: companyEmail.value);
    final phoneController = TextEditingController(text: companyPhone.value);
    final locationController = TextEditingController(text: companyLocation.value);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Edit Contact Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              updateProfile(
                email: emailController.text,
                phone: phoneController.text,
                location: locationController.text,
              );
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditAboutDialog() {
    final aboutController = TextEditingController(text: companyAbout.value);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Edit About'),
        content: TextField(
          controller: aboutController,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'About Company',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (aboutController.text.isNotEmpty) {
                updateProfile(about: aboutController.text);
                Get.back();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Logout
  // void logout() {
  //   Get.dialog(
  //     Center(
  //       child: Material(
  //         color: Colors.transparent,
  //         child: Container(
  //           width: Get.width * 0.85,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(24),
  //             color: Colors.white,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.15),
  //                 blurRadius: 20,
  //                 offset: const Offset(0, 10),
  //               ),
  //             ],
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // 🔴 Header
  //               Container(
  //                 width: double.infinity,
  //                 padding: const EdgeInsets.symmetric(vertical: 28),
  //                 decoration: const BoxDecoration(
  //                   gradient: LinearGradient(
  //                     colors: [Color(0xFFFF5252), Color(0xFFD32F2F)],
  //                     begin: Alignment.topLeft,
  //                     end: Alignment.bottomRight,
  //                   ),
  //                   borderRadius: BorderRadius.vertical(
  //                     top: Radius.circular(24),
  //                   ),
  //                 ),
  //                 child: Column(
  //                   children: const [
  //                     Icon(
  //                       Iconsax.logout,
  //                       color: Colors.white,
  //                       size: 40,
  //                     ),
  //                     SizedBox(height: 12),
  //                     Text(
  //                       'Logout',
  //                       style: TextStyle(
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.w700,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //
  //               // 📝 Content
  //               Padding(
  //                 padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
  //                 child: Text(
  //                   'Are you sure you want to log out?\nYou’ll need to log in again to continue.',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     fontSize: 15,
  //                     color: Colors.grey.shade700,
  //                     height: 1.4,
  //                   ),
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 12),
  //
  //               // 🔘 Actions
  //               Padding(
  //                 padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                       child: OutlinedButton(
  //                         onPressed: () => Get.back(),
  //                         style: OutlinedButton.styleFrom(
  //                           side: BorderSide(color: Colors.grey.shade300),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(14),
  //                           ),
  //                           padding: const EdgeInsets.symmetric(vertical: 14),
  //                         ),
  //                         child: const Text(
  //                           'Cancel',
  //                           style: TextStyle(fontSize: 15),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 12),
  //                     Expanded(
  //                       child: ElevatedButton(
  //                         onPressed: () {
  //                           Get.back();
  //                           Get.offAllNamed('/login');
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           padding: const EdgeInsets.symmetric(vertical: 14),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(14),
  //                           ),
  //                           backgroundColor: const Color(0xFFD32F2F),
  //                           elevation: 3,
  //                         ),
  //                         child: const Text(
  //                           'Logout',
  //                           style: TextStyle(
  //                             fontSize: 15,
  //                             fontWeight: FontWeight.w600,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //     barrierDismissible: true,
  //   );
  // }


  // View privacy policy
  void viewPrivacyPolicy() {
    Get.toNamed('/privacy-policy');
  }

  // View terms
  void viewTermsAndConditions() {
    Get.toNamed('/terms');
  }

  void payments() {
    Get.toNamed(AppRoutes.paymentsScreen);
  }

  void support() {
    Get.toNamed(AppRoutes.supportScreen);
  }

  // Get app version
  String get appVersion => '1.0.0';
}