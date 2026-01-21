import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class LoginScreenController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables
  var selectedUserType = 'Stakeholder'.obs;
  var isPasswordVisible = true.obs;
  var isLoading = false.obs;
  var rememberMe = false.obs;
  var isPhoneLogin = true.obs; // Toggle for phone/email login

  @override
  void onInit() {
    super.onInit();
    // Set default user type
    selectedUserType.value = 'Stakeholder';
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   phoneController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }

  // Toggle between phone and email login
  void toggleLoginMethod() {
    isPhoneLogin.value = !isPhoneLogin.value;

    // Clear text controllers when switching
    if (isPhoneLogin.value) {
      emailController.clear();
    } else {
      phoneController.clear();
    }
  }

  // Set user type
  void setUserType(String userType) {
    selectedUserType.value = userType;
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Phone validation
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Basic phone number validation (10 digits)
    if (!GetUtils.isPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Get the current identifier (email or phone)
  String getIdentifier() {
    return isPhoneLogin.value ? phoneController.text : emailController.text;
  }

  // Login function
  Future<void> login() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      CustomSnackBar.error('Please fill all required fields correctly');
      return;
    }

    if (selectedUserType.value.isEmpty) {
      CustomSnackBar.error('Please select user type');
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock login logic - replace with actual API call
      final identifier = getIdentifier();
      if (identifier.isNotEmpty) {
        // Show success message
        CustomSnackBar.success('Login successful! Welcome ${selectedUserType.value}');

        // Navigate based on user type
        _navigateToDashboard();
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      CustomSnackBar.error('Login failed. Please check your credentials.');
    } finally {
      isLoading.value = false;
    }
  }

  // Navigate to appropriate dashboard based on user type
  void _navigateToDashboard() {
    switch (selectedUserType.value) {
      case 'Stakeholder':
        !isPhoneLogin.value?
        Get.toNamed(AppRoutes.bottomnavScreen) : Get.toNamed(AppRoutes.otp,arguments: {
          "isStackholder" : selectedUserType.value,
        });
        // Get.toNamed(AppRoutes.studentBottomNavScreen);
        break;
      case 'ServiceProvider':
        !isPhoneLogin.value?
        Get.toNamed(AppRoutes.serviceProviderBottomNav) : Get.toNamed(AppRoutes.otp,arguments: {
          "isStackholder" : selectedUserType.value,
        });
        print('Navigate to Parent Dashboard');
        break;
      default:
        print('Unknown user type');
    }
  }

  // Forgot password function
  void forgotPassword() {
    Get.toNamed('/forgotPassword');
  }

  // Go to sign up
  void goToSignUp() {
    Get.toNamed('/signUp');
  }
}