import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_dropdown.dart';
import 'package:samadhantra/app/constant/custom_textformfield.dart';
import 'package:samadhantra/app/constant/dropdown_controller.dart';
import 'package:samadhantra/app/constant/validators.dart';
import 'package:samadhantra/app/utils/widgets/place_search_widget.dart';
import 'complete_profile_screen_controller.dart';

class CompleteProfileScreen extends StatelessWidget {
  CompleteProfileScreen({super.key});

  final CompleteProfileController controller = Get.put(
    CompleteProfileController(),
  );
  final objectivesController = DropdownController<String>();
  final stakeController = DropdownController<String>();
  final investerTypeController = DropdownController<String>();
  final categoryController = DropdownController<String>();
  final subCategoryController = DropdownController<String>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _buildActionButtons(),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Back Button
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Complete Your Profile',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Help us verify your identity and set up your account',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Divider(height: 1),
                  const SizedBox(height: 30),

                  // Company Logo Upload
                  // _buildLogoUploadSection(),

                  // const SizedBox(height: 30),
                  Text("Reference Number"),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    hintText: "REF12345",
                    controller: controller.referenceController,
                    prefixIcon: Icons.link,
                    validator: Validators.name,
                  ),
                  const SizedBox(height: 20),

                  Text("Objectives *"),
                  const SizedBox(height: 5),
                  CustomDropdown<String>(
                    controller: objectivesController,
                    items: [
                      'Professional Networking',
                      'Access to Resources',
                      'Certification & Credentials',
                      'Collaboration Opportunities',
                      'Training & Development',
                      'Market Access'
                    ],
                    hintText: 'Select Objective',
                    icon: Icons.group,
                    displayText: (item) => item,
                  ),
                  const SizedBox(height: 20),
                  Text("Stakeholder *"),
                  const SizedBox(height: 5),
                  CustomDropdown<String>(
                    controller: stakeController,
                    items: [
                      'Students - ₹1,000',
                      'Freelancers - ₹5,000',
                      'Educational institutions - ₹10,000',
                      'Startups & MSMEs - ₹10,000',
                      'Incubation Centres - ₹10,000',
                      'Service & Product Providers - ₹25,000',
                      'Industry - ₹25,000',
                      'Investors - ₹25,000'
                    ],
                    hintText: 'Select Stakeholder',
                    icon: Icons.group,
                    displayText: (item) => item,
                  ),
                  const SizedBox(height: 20),
                  // Company Name Field
                  Text("Company / Organization"),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    hintText: "Enter company name",
                    controller: controller.companyNameController,
                    prefixIcon: Icons.business,
                    validator: Validators.name,
                  ),

                  const SizedBox(height: 20),

                  // Location Field with Auto-suggest
                  Text("Location"),
                  const SizedBox(height: 5),
                  PlaceSearchWidget(
                    controller: controller,
                    validator: Validators.requiredField,
                  ),

                  const SizedBox(height: 20),

                  // About Field
                  _buildAboutField(),
                  const SizedBox(height: 20),




                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Company Logo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'PNG, JPG up to 5MB',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),

        Obx(() {
          if (controller.companyLogo.value != null ||
              controller.companyLogoUrl.value.isNotEmpty) {
            return _buildLogoPreview();
          }
          return _buildUploadButton();
        }),
      ],
    );
  }

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: controller.pickCompanyLogo,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Obx(
          () => controller.isUploading.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload, size: 40, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      'Tap to upload logo',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Recommended: 500x500px',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildLogoPreview() {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Obx(() {
            if (controller.companyLogo.value != null) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  controller.companyLogo.value!,
                  fit: BoxFit.cover,
                ),
              );
            } else if (controller.companyLogoUrl.value.isNotEmpty) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  controller.companyLogoUrl.value,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          }),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: GestureDetector(
            onTap: controller.removeCompanyLogo,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    required String? Function(String?)? validator,
    Widget? suffixIcon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: Validators.name,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.appColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          validator: controller.validatePhone,
          decoration: InputDecoration(
            hintText: '+91 9876543210',
            prefixIcon: const Icon(Icons.phone, size: 20),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.appColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Obx(
          () => TextFormField(
            controller: controller.aboutController,
            maxLines: 4,
            validator: Validators.requiredField,
            decoration: InputDecoration(
              hintText: controller.aboutHintText,
              hintStyle: TextStyle(color: Colors.grey),
              alignLabelWithHint: true,
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.appColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: Text(
              'Back',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.completeProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                shadowColor: AppColors.appColor.withOpacity(0.4),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Complete Setup',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _getCurrentLocation() async {
    // Implement location service
    Get.snackbar(
      'Location',
      'Fetching your location...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Set mock location for demo
    controller.addressController.text = 'Mumbai, Maharashtra, India';
  }
}
