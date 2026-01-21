// requiremnent_list_screen_controller.dart
import 'package:get/get.dart';
import 'package:samadhantra/app/data/model/stake_requirement_model.dart';

class RequirementsController extends GetxController {
  final RxList<RequirementModel> requirements = <RequirementModel>[].obs;
  final RxString selectedFilter = 'All'.obs;

  final filters = ['All', 'Active', 'In Review', 'Completed', 'Pending'];

  @override
  void onInit() {
    super.onInit();
    loadRequirements();
  }

  void loadRequirements() {
    // Load from API
    requirements.value = [
      RequirementModel(
        id: '1',
        title: 'Mobile App Development',
        category: 'Mobile Development',
        description: 'We need a mobile app for our e-commerce platform with the following features:\n\n1. User authentication\n2. Product catalog with categories\n3. Shopping cart functionality\n4. Payment gateway integration\n5. Order tracking\n6. Push notifications',
        status: 'active',
        proposalsCount: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        budget: '₹50,000 - ₹1,00,000',
        deadline: DateTime.now().add(const Duration(days: 30)),
        location: 'Mumbai, India',
        attachments: ['Project_Brief.pdf'],
        proposals: [
          ProposalModel(
            id: 'p1',
            providerName: 'Tech Solutions Inc.',
            providerImage: '',
            providerRating: '4.8',
            price: '₹75,000',
            timeline: '25 Days',
            description: 'We have extensive experience in e-commerce apps',
            status: 'submitted',
            submittedDate: DateTime.now().subtract(const Duration(days: 2)),
          ),
        ],
      ),
      RequirementModel(
        id: '2',
        title: 'Website Redesign',
        category: 'Web Development',
        description: 'Modern redesign of corporate website with responsive design and CMS integration',
        status: 'in_review',
        proposalsCount: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        budget: '₹30,000 - ₹60,000',
        deadline: DateTime.now().add(const Duration(days: 45)),
        location: 'Delhi, India',
      ),
      RequirementModel(
        id: '3',
        title: 'ERP System Integration',
        category: 'Software Development',
        description: 'Integrate existing ERP with new modules for inventory management and accounting',
        status: 'completed',
        proposalsCount: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        budget: '₹2,00,000 - ₹5,00,000',
        deadline: DateTime.now().add(const Duration(days: 90)),
        location: 'Bangalore, India',
      ),
    ];
  }

  List<RequirementModel> get filteredRequirements {
    if (selectedFilter.value == 'All') return requirements;
    return requirements
        .where((req) => req.status == selectedFilter.value.toLowerCase().replaceAll(' ', '_'))
        .toList();
  }

  void viewRequirementDetail(String id) {
    Get.toNamed('/requirementDetails/$id');
  }

  void deleteRequirement(String id) {
    requirements.removeWhere((req) => req.id == id);
  }
}