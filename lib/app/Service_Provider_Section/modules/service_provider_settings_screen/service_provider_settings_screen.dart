// lib/app/modules/service_provider/views/service_provider_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_settings_screen/service_provider_settings_screen_controller.dart';

class ServiceProviderSettingsScreen extends StatelessWidget {
  final ServiceProviderSettingsController controller = Get.put(ServiceProviderSettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Account Settings
            _buildSection(
              title: 'Account',
              children: [
                _buildSettingItem(
                  icon: Icons.person,
                  title: 'Profile Settings',
                  subtitle: 'Update your profile information',
                  onTap: () => Get.toNamed('/service-provider/edit-profile'),
                ),
                _buildSettingItem(
                  icon: Icons.lock,
                  title: 'Change Password',
                  subtitle: 'Update your password',
                  onTap: () => _changePassword(),
                ),
                _buildSettingItem(
                  icon: Icons.notifications,
                  title: 'Notification Settings',
                  subtitle: 'Manage notification preferences',
                  onTap: () => _notificationSettings(),
                ),
              ],
            ),

            // Preferences
            _buildSection(
              title: 'Preferences',
              children: [
                _buildSettingItem(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: controller.preferredLanguage.value,
                  onTap: () => _selectLanguage(),
                ),
                _buildSettingItem(
                  icon: Icons.currency_rupee,
                  title: 'Currency',
                  subtitle: controller.currency.value,
                  onTap: () => _selectCurrency(),
                ),
                _buildSettingItem(
                  icon: Icons.access_time,
                  title: 'Timezone',
                  subtitle: controller.timezone.value,
                  onTap: () => _selectTimezone(),
                ),
              ],
            ),

            // Privacy & Security
            _buildSection(
              title: 'Privacy & Security',
              children: [
                Obx(() => SwitchListTile(
                  title: Text('Profile Visibility'),
                  subtitle: Text('Allow clients to view your profile'),
                  value: controller.profileVisible.value,
                  onChanged: (value) {
                    controller.profileVisible.value = value;
                    controller.savePrivacySettings();
                  },
                )),
                Obx(() => SwitchListTile(
                  title: Text('Show Online Status'),
                  subtitle: Text('Display when you are online'),
                  value: controller.onlineStatus.value,
                  onChanged: (value) {
                    controller.onlineStatus.value = value;
                    controller.savePrivacySettings();
                  },
                )),
                _buildSettingItem(
                  icon: Icons.security,
                  title: 'Privacy Policy',
                  subtitle: 'View our privacy policy',
                  onTap: controller.viewPrivacyPolicy,
                ),
                _buildSettingItem(
                  icon: Icons.description,
                  title: 'Terms of Service',
                  subtitle: 'View terms and conditions',
                  onTap: controller.viewTerms,
                ),
              ],
            ),

            // Support
            _buildSection(
              title: 'Support',
              children: [
                _buildSettingItem(
                  icon: Icons.help,
                  title: 'Help & Support',
                  subtitle: 'Get help and contact support',
                  onTap: controller.contactSupport,
                ),
                _buildSettingItem(
                  icon: Icons.feedback,
                  title: 'Send Feedback',
                  subtitle: 'Share your feedback with us',
                  onTap: () => _sendFeedback(),
                ),
                _buildSettingItem(
                  icon: Icons.share,
                  title: 'Share App',
                  subtitle: 'Share with friends and colleagues',
                  onTap: () => _shareApp(),
                ),
                _buildSettingItem(
                  icon: Icons.star,
                  title: 'Rate App',
                  subtitle: 'Rate us on app store',
                  onTap: () => _rateApp(),
                ),
              ],
            ),

            // Data Management
            _buildSection(
              title: 'Data Management',
              children: [
                _buildSettingItem(
                  icon: Icons.download,
                  title: 'Export Data',
                  subtitle: 'Download your data',
                  onTap: controller.exportData,
                ),
                _buildSettingItem(
                  icon: Icons.delete,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  onTap: controller.deleteAccount,
                  color: Colors.red,
                ),
              ],
            ),

            // App Info
            _buildSection(
              title: 'App Info',
              children: [
                ListTile(
                  title: Text('Version'),
                  subtitle: Text('1.0.0'),
                ),
                ListTile(
                  title: Text('Build Number'),
                  subtitle: Text('2024.01.001'),
                ),
              ],
            ),

            SizedBox(height: 32),
            Text(
              'Samadhantra © 2024',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
      onTap: onTap,
    );
  }

  void _changePassword() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Change Password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Obx(() => TextField(
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onChanged: (value) => controller.currentPassword.value = value,
              )),
              SizedBox(height: 16),
              Obx(() => TextField(
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onChanged: (value) => controller.newPassword.value = value,
              )),
              SizedBox(height: 16),
              Obx(() => TextField(
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onChanged: (value) => controller.confirmPassword.value = value,
              )),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.changePassword,
                child: Text('Change Password'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _notificationSettings() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Notification Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Obx(() => SwitchListTile(
                title: Text('Email Notifications'),
                subtitle: Text('Receive notifications via email'),
                value: controller.emailNotifications.value,
                onChanged: (value) {
                  controller.emailNotifications.value = value;
                },
              )),
              Obx(() => SwitchListTile(
                title: Text('Push Notifications'),
                subtitle: Text('Receive push notifications'),
                value: controller.pushNotifications.value,
                onChanged: (value) {
                  controller.pushNotifications.value = value;
                },
              )),
              Obx(() => SwitchListTile(
                title: Text('Proposal Alerts'),
                subtitle: Text('Get notified about new proposals'),
                value: controller.proposalAlerts.value,
                onChanged: (value) {
                  controller.proposalAlerts.value = value;
                },
              )),
              Obx(() => SwitchListTile(
                title: Text('Assignment Updates'),
                subtitle: Text('Get updates on assignments'),
                value: controller.assignmentUpdates.value,
                onChanged: (value) {
                  controller.assignmentUpdates.value = value;
                },
              )),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.saveNotificationSettings();
                  Get.back();
                },
                child: Text('Save Settings'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectLanguage() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Language',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...controller.languages.map((language) {
              return Obx(() => RadioListTile(
                title: Text(language),
                value: language,
                groupValue: controller.preferredLanguage.value,
                onChanged: (value) {
                  controller.preferredLanguage.value = value.toString();
                  controller.updatePreferences();
                  Get.back();
                },
              ));
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _selectCurrency() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Currency',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...controller.currencies.map((currency) {
              return Obx(() => RadioListTile(
                title: Text(currency),
                value: currency,
                groupValue: controller.currency.value,
                onChanged: (value) {
                  controller.currency.value = value.toString();
                  controller.updatePreferences();
                  Get.back();
                },
              ));
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _selectTimezone() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Timezone',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...controller.timezones.map((timezone) {
              return Obx(() => RadioListTile(
                title: Text(timezone),
                value: timezone,
                groupValue: controller.timezone.value,
                onChanged: (value) {
                  controller.timezone.value = value.toString();
                  controller.updatePreferences();
                  Get.back();
                },
              ));
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _sendFeedback() {
    String feedback = '';

    Get.dialog(
      AlertDialog(
        title: Text('Send Feedback'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Share your feedback or suggestions...',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
          onChanged: (value) => feedback = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (feedback.isNotEmpty) {
                Get.back();
                Get.snackbar('Thank You', 'Feedback submitted successfully');
              }
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _shareApp() {
    // Implement share functionality
    Get.snackbar('Share', 'Sharing functionality coming soon');
  }

  void _rateApp() {
    // Implement rate app functionality
    Get.snackbar('Rate App', 'Rate app functionality coming soon');
  }
}