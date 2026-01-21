import 'package:get/get.dart';
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class RoleSelectionController extends GetxController {

  final List<RoleItem> roles = [
    RoleItem(
      id: 'startup',
      title: 'Startup',
      icon: '🚀',
      description: 'New business ventures',
    ),
    RoleItem(
      id: 'msme',
      title: 'MSME',
      icon: '🏢',
      description: 'Micro, Small & Medium Enterprises',
    ),
    RoleItem(
      id: 'corporate',
      title: 'Corporate',
      icon: '🏛️',
      description: 'Large established companies',
    ),
    RoleItem(
      id: 'institute',
      title: 'Institute',
      icon: '🎓',
      description: 'Educational institutions',
    ),
    RoleItem(
      id: 'student',
      title: 'Student',
      icon: '👨‍🎓',
      description: 'Learners and scholars',
    ),
    RoleItem(
      id: 'freelancer',
      title: 'Freelancer',
      icon: '💼',
      description: 'Independent professionals',
    ),
    RoleItem(
      id: 'vendor',
      title: 'Vendor',
      icon: '🛒',
      description: 'Suppliers and service providers',
    ),
  ];

  // Selected role
  Rx<RoleItem?> selectedRole = Rx<RoleItem?>(null);

  // Methods
  void selectRole(RoleItem role) {
    selectedRole.value = role;
  }

  void continueWithRole() {
    if (selectedRole.value != null) {

      CustomSnackBar.success("You selected: ${selectedRole.value!.title}");
      // Here you would navigate to the next screen
       Get.toNamed(AppRoutes.completeProfile);
    } else {
      CustomSnackBar.success("Please select a role to continue");

    }
  }
}

// Role model (inline in controller file)
class RoleItem {
  final String id;
  final String title;
  final String icon;
  final String description;

  RoleItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
  });
}