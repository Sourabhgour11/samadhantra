// lib/app/modules/service_provider/controllers/service_provider_settings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceProviderSettingsController extends GetxController {
  var isLoading = false.obs;

  // Notification Settings
  var emailNotifications = true.obs;
  var pushNotifications = true.obs;
  var proposalAlerts = true.obs;
  var assignmentUpdates = true.obs;
  var paymentAlerts = true.obs;
  var reviewAlerts = true.obs;

  // Privacy Settings
  var profileVisible = true.obs;
  var portfolioVisible = true.obs;
  var earningsVisible = false.obs;
  var onlineStatus = true.obs;

  // Account Settings
  var currentPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;

  // Preferences
  var preferredLanguage = 'English'.obs;
  var currency = 'INR (₹)'.obs;
  var timezone = 'IST (UTC+5:30)'.obs;

  final List<String> languages = ['English', 'Hindi', 'Spanish', 'French'];
  final List<String> currencies = ['INR (₹)', 'USD (\$)', 'EUR (€)', 'GBP (£)'];
  final List<String> timezones = ['IST (UTC+5:30)', 'UTC', 'EST (UTC-5)', 'PST (UTC-8)'];

  void saveNotificationSettings() {
    // Save to API
    Get.snackbar('Success', 'Notification settings saved');
  }

  void savePrivacySettings() {
    // Save to API
    Get.snackbar('Success', 'Privacy settings saved');
  }

  void changePassword() {
    if (newPassword.value != confirmPassword.value) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    if (newPassword.value.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return;
    }

    // Call API to change password
    Get.snackbar('Success', 'Password changed successfully');

    // Clear fields
    currentPassword.value = '';
    newPassword.value = '';
    confirmPassword.value = '';
  }

  void updatePreferences() {
    // Save preferences to API
    Get.snackbar('Success', 'Preferences updated');
  }

  void deleteAccount() {
    Get.defaultDialog(
      title: 'Delete Account',
      middleText: 'Are you sure you want to delete your account? This action cannot be undone.',
      textConfirm: 'Delete Account',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        // Call API to delete account
        Get.offAllNamed('/login');
      },
    );
  }

  void exportData() {
    Get.snackbar('Info', 'Data export started. You will receive an email when ready.');
  }

  void contactSupport() {
    Get.toNamed('/service-provider/support');
  }

  void viewTerms() {
    Get.toNamed('/service-provider/terms');
  }

  void viewPrivacyPolicy() {
    Get.toNamed('/service-provider/privacy-policy');
  }
}