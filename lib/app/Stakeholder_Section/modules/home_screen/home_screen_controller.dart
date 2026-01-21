// lib/app/modules/stakeholder/views/dashboard/controllers/dashboard_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:samadhantra/app/data/model/stake_requirement_model.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class HomeScreenController extends GetxController {

  final companyName = 'Tech Innovations Ltd.'.obs;
  final RxList<RequirementModel> recentRequirements = <RequirementModel>[].obs;

  // Stats
  final activeProjects = 5.obs;
  final completedProjects = 12.obs;
  final inReviewProjects = 3.obs;
  final totalProposals = 42.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    // Load data from API
    recentRequirements.value = [
      RequirementModel(
        id: '1',
        title: 'Mobile App Development',
        description: 'Need a mobile app for e-commerce',
        category: 'Mobile Development',
        budget: '₹50,000 - ₹1,00,000',
        deadline: DateTime.now().add(const Duration(days: 30)),
        status: 'active',
        proposalsCount: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      RequirementModel(
        id: '2',
        title: 'Website Redesign',
        description: 'Modern redesign of corporate website',
        category: 'Web Development',
        budget: '₹30,000 - ₹60,000',
        deadline: DateTime.now().add(const Duration(days: 45)),
        status: 'active',
        proposalsCount: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      RequirementModel(
        id: '3',
        title: 'ERP System Integration',
        description: 'Integrate existing ERP with new modules',
        category: 'Software Development',
        budget: '₹2,00,000 - ₹5,00,000',
        deadline: DateTime.now().add(const Duration(days: 90)),
        status: 'in_review',
        proposalsCount: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  void navigateToPostRequirement() {
    Get.toNamed(AppRoutes.postRequirementScreen);
  }

  void viewRequirementDetail(String requirementId) {
    Get.toNamed('/requirementDetails/$requirementId');
    // Get.toNamed('/stakeholder/requirement-detail/$requirementId');
  }
}
