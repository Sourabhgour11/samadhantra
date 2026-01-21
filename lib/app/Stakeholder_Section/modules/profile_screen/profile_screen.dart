import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/profile_screen/profile_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_logout_dialog.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Profile",isBackButton: false,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),

            const SizedBox(height: 24),

            // Company Details Section
            _buildCompanyDetailsSection(),

            const SizedBox(height: 24),

            // Contact Details Section
            _buildContactDetailsSection(),

            const SizedBox(height: 24),

            // About Section
            _buildAboutSection(),

            const SizedBox(height: 24),

            // Notification Settings
            // _buildNotificationSettings(),

            // const SizedBox(height: 24),

            // Change Password
            // _buildChangePasswordSection(),

            // const SizedBox(height: 24),

            // App Info & Actions
            _buildAppInfoSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo & Edit
          Stack(
            children: [
              Obx(() => Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.appColor, width: 3),
                ),
                child: controller.companyLogoUrl.value.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(47),
                  child: Image.network(
                    controller.companyLogoUrl.value,
                    fit: BoxFit.cover,
                  ),
                )
                    : controller.companyLogo.value != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(47),
                  child: Image.file(
                    controller.companyLogo.value!,
                    fit: BoxFit.cover,
                  ),
                )
                    : Center(
                  child: Text(
                    controller.companyName.value[0],
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appColor,
                    ),
                  ),
                ),
              )),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: controller.pickCompanyLogo,
                  child: Obx(() => Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.appColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: controller.isUploadingLogo.value
                        ? const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                        : const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  )),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Company Name
          Obx(() => Text(
            controller.companyName.value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          )),

          const SizedBox(height: 8),

          // Email
          Obx(() => Text(
            controller.companyEmail.value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCompanyDetailsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Company Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => controller.editSection('company'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => _buildDetailItem(
            icon: Icons.business,
            label: 'Company Name',
            value: controller.companyName.value,
          )),
        ],
      ),
    );
  }

  Widget _buildContactDetailsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contact Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => controller.editSection('contact'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Column(
            children: [
              _buildDetailItem(
                icon: Icons.email,
                label: 'Email',
                value: controller.companyEmail.value,
              ),
              const SizedBox(height: 12),
              _buildDetailItem(
                icon: Icons.phone,
                label: 'Phone',
                value: controller.companyPhone.value,
              ),
              const SizedBox(height: 12),
              _buildDetailItem(
                icon: Icons.location_on,
                label: 'Location',
                value: controller.companyLocation.value,
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'About Company',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => controller.editSection('about'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Text(
            controller.companyAbout.value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.appColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildNotificationSettings() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 20),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Notification Settings',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.black,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         Obx(() => Column(
  //           children: [
  //             _buildNotificationToggle(
  //               title: 'Email Notifications',
  //               value: controller.emailNotifications.value,
  //               onChanged: (value) => controller.emailNotifications.value = value,
  //             ),
  //             const SizedBox(height: 12),
  //             _buildNotificationToggle(
  //               title: 'Push Notifications',
  //               value: controller.pushNotifications.value,
  //               onChanged: (value) => controller.pushNotifications.value = value,
  //             ),
  //             const SizedBox(height: 12),
  //             _buildNotificationToggle(
  //               title: 'SMS Notifications',
  //               value: controller.smsNotifications.value,
  //               onChanged: (value) => controller.smsNotifications.value = value,
  //             ),
  //           ],
  //         )),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildNotificationToggle({
  //   required String title,
  //   required bool value,
  //   required Function(bool) onChanged,
  // }) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         title,
  //         style: TextStyle(
  //           fontSize: 14,
  //           color: Colors.black,
  //         ),
  //       ),
  //       Switch(
  //         value: value,
  //         onChanged: onChanged,
  //         activeColor: AppColors.appColor,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildChangePasswordSection() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 20),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Change Password',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.black,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         _buildPasswordField(
  //           controller: controller.oldPasswordController,
  //           label: 'Current Password',
  //           hint: 'Enter current password',
  //         ),
  //         const SizedBox(height: 12),
  //         _buildPasswordField(
  //           controller: controller.newPasswordController,
  //           label: 'New Password',
  //           hint: 'Enter new password',
  //         ),
  //         const SizedBox(height: 12),
  //         _buildPasswordField(
  //           controller: controller.confirmPasswordController,
  //           label: 'Confirm Password',
  //           hint: 'Confirm new password',
  //         ),
  //         const SizedBox(height: 20),
  //         Obx(() =>
  //           AppButton(title: "Change Password",onPressed: (){
  //
  //           },)
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Legal Links
          _buildActionButton(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: controller.viewPrivacyPolicy,
          ),
          const Divider(height: 1),
          _buildActionButton(
            icon: Icons.description,
            title: 'Terms & Conditions',
            onTap: controller.viewTermsAndConditions,
          ),
          const Divider(height: 1),
          _buildActionButton(
            icon: Icons.payment,
            title: 'Payments',
            onTap: controller.payments,
          ),
          const Divider(height: 1),
          _buildActionButton(
            icon: Icons.support_agent,
            title: 'Support',
            onTap: controller.support,
          ),
          const Divider(height: 1),
          // App Version
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Version ${controller.appVersion}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: (){
                showLogoutDialog(onLogout: (){
                  Get.offAllNamed(AppRoutes.login);
                } );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 18),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Colors.grey[600]),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}