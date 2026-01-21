// requirement_detail_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/data/model/stake_requirement_model.dart';

class RequirementDetailController extends GetxController {
  final Rx<RequirementModel?> requirement = Rx<RequirementModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString selectedTab = 'Details'.obs;
  final RxList<ProposalModel> proposals = <ProposalModel>[].obs;
  final RxString errorMessage = ''.obs;
  String? requirementId;

  @override
  void onInit() {
    super.onInit();
    getRequirementIdFromRoute();
  }

  Future<void> loadRequirementDetails(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // For demo, create a requirement based on ID
      final mockRequirements = {
        '1': RequirementModel(
          id: '1',
          title: 'Mobile App Development',
          category: 'Mobile Development',
          description: 'We need a mobile app for our e-commerce platform with the following features:\n\n1. User authentication\n2. Product catalog with categories\n3. Shopping cart functionality\n4. Payment gateway integration\n5. Order tracking\n6. Push notifications\n\nThe app should be built using Flutter for both iOS and Android platforms.',
          status: 'active',
          proposalsCount: 8,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          budget: '₹50,000 - ₹1,00,000',
          deadline: DateTime.now().add(const Duration(days: 30)),
          location: 'Mumbai, India',
          attachments: ['Project_Brief.pdf', 'Wireframes.zip', 'Design_Guidelines.pdf'],
          proposals: [
            ProposalModel(
              id: 'p1',
              providerName: 'Tech Solutions Inc.',
              providerImage: '',
              providerRating: '4.8',
              price: '₹75,000',
              timeline: '25 Days',
              description: 'We have extensive experience in e-commerce apps and can deliver high-quality solution.',
              status: 'submitted',
              submittedDate: DateTime.now().subtract(const Duration(days: 2)),
            ),
            ProposalModel(
              id: 'p2',
              providerName: 'Mobile App Masters',
              providerImage: '',
              providerRating: '4.6',
              price: '₹90,000',
              timeline: '28 Days',
              description: 'Specialized in Flutter development with 50+ apps delivered.',
              status: 'submitted',
              submittedDate: DateTime.now().subtract(const Duration(days: 1)),
            ),
            ProposalModel(
              id: 'p3',
              providerName: 'Digital Innovators',
              providerImage: '',
              providerRating: '4.9',
              price: '₹65,000',
              timeline: '35 Days',
              description: 'Offer comprehensive solution with 6 months free maintenance.',
              status: 'accepted',
              submittedDate: DateTime.now().subtract(const Duration(days: 3)),
            ),
          ],
        ),
        '2': RequirementModel(
          id: '2',
          title: 'Website Redesign',
          category: 'Web Development',
          description: 'Modern redesign of corporate website with responsive design and CMS integration.',
          status: 'in_review',
          proposalsCount: 5,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          budget: '₹30,000 - ₹60,000',
          deadline: DateTime.now().add(const Duration(days: 45)),
          location: 'Delhi, India',
          attachments: ['Design_Brief.pdf'],
          proposals: [
            ProposalModel(
              id: 'p4',
              providerName: 'Web Design Studio',
              providerImage: '',
              providerRating: '4.7',
              price: '₹45,000',
              timeline: '30 Days',
              description: 'Expert in modern web design with CMS integration.',
              status: 'submitted',
              submittedDate: DateTime.now().subtract(const Duration(days: 1)),
            ),
          ],
        ),
        '3': RequirementModel(
          id: '3',
          title: 'ERP System Integration',
          category: 'Software Development',
          description: 'Integrate existing ERP with new modules for inventory management and accounting.',
          status: 'completed',
          proposalsCount: 3,
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          budget: '₹2,00,000 - ₹5,00,000',
          deadline: DateTime.now().add(const Duration(days: 90)),
          location: 'Bangalore, India',
          attachments: ['Requirements.pdf'],
          proposals: [
            ProposalModel(
              id: 'p5',
              providerName: 'ERP Solutions Ltd.',
              providerImage: '',
              providerRating: '4.9',
              price: '₹3,50,000',
              timeline: '80 Days',
              description: 'Specialized in ERP integration with 10+ years experience.',
              status: 'accepted',
              submittedDate: DateTime.now().subtract(const Duration(days: 50)),
            ),
          ],
        ),
      };

      requirement.value = mockRequirements[id];

      if (requirement.value != null) {
        proposals.value = requirement.value!.proposals;
        print('✅ Requirement loaded successfully: ${requirement.value!.title}');
      } else {
        errorMessage.value = 'Requirement not found';
        print('❌ Requirement not found with ID: $id');
      }

    } catch (e) {
      errorMessage.value = 'Failed to load requirement: $e';
      print('❌ Error loading requirement: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(String tabName) {
    selectedTab.value = tabName;
  }

  void acceptProposal(String proposalId) {
    final index = proposals.indexWhere((p) => p.id == proposalId);
    if (index != -1) {
      proposals[index] = ProposalModel(
        id: proposals[index].id,
        providerName: proposals[index].providerName,
        providerImage: proposals[index].providerImage,
        providerRating: proposals[index].providerRating,
        price: proposals[index].price,
        timeline: proposals[index].timeline,
        description: proposals[index].description,
        status: 'accepted',
        submittedDate: proposals[index].submittedDate,
      );

      Get.snackbar(
        'Proposal Accepted',
        'Proposal from ${proposals[index].providerName} has been accepted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      proposals.refresh();
    }
  }

  void rejectProposal(String proposalId) {
    final index = proposals.indexWhere((p) => p.id == proposalId);
    if (index != -1) {
      proposals[index] = ProposalModel(
        id: proposals[index].id,
        providerName: proposals[index].providerName,
        providerImage: proposals[index].providerImage,
        providerRating: proposals[index].providerRating,
        price: proposals[index].price,
        timeline: proposals[index].timeline,
        description: proposals[index].description,
        status: 'rejected',
        submittedDate: proposals[index].submittedDate,
      );

      Get.snackbar(
        'Proposal Rejected',
        'Proposal from ${proposals[index].providerName} has been rejected',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      proposals.refresh();
    }
  }

  void getRequirementIdFromRoute() {
    // Try to get ID from parameters first
    requirementId = Get.parameters['id'];

    // If not in parameters, try from arguments
    if (requirementId == null) {
      final dynamic args = Get.arguments;
      if (args is String) {
        requirementId = args;
      } else if (args is Map<String, dynamic>) {
        requirementId = args['id']?.toString();
      }
    }

    // TEMPORARY FIX: If still no ID, use default ID for testing
    if (requirementId == null || requirementId!.isEmpty) {
      print('⚠️ No ID found, using default ID for testing');
      requirementId = '1'; // Use default ID
    }

    if (requirementId != null && requirementId!.isNotEmpty) {
      print('🔍 Loading requirement with ID: $requirementId');
      loadRequirementDetails(requirementId!);
    } else {
      errorMessage.value = 'Requirement ID not found';
      print('❌ No requirement ID found');
    }
  }

  void reload() {
    if (requirementId != null) {
      loadRequirementDetails(requirementId!);
    }
  }
}