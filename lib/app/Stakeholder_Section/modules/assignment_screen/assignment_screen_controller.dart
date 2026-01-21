// assignment_screen_controller.dart
import 'package:get/get.dart';
import 'package:samadhantra/app/data/model/stake_assignment_model.dart';

class AssignmentController extends GetxController {
  static AssignmentController get instance => Get.find();

  final RxList<Assignment> assignments = <Assignment>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<Assignment?> selectedAssignment = Rx<Assignment?>(null);
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data
      assignments.value = [
        Assignment(
          id: '1',
          requirementTitle: 'Mobile App Development',
          providerName: 'Tech Solutions Inc.',
          providerImage: '',
          status: 'in-progress',
          assignedDate: DateTime.now().subtract(const Duration(days: 15)),
          startDate: DateTime.now().subtract(const Duration(days: 10)),
          budget: 50000.00,
          milestones: [
            Milestone(
              id: 'm1',
              title: 'Requirement Analysis',
              description: 'Gather and document requirements',
              dueDate: DateTime.now().subtract(const Duration(days: 5)),
              status: 'completed',
              completedDate: DateTime.now().subtract(const Duration(days: 6)),
            ),
            Milestone(
              id: 'm2',
              title: 'UI/UX Design',
              description: 'Create wireframes and mockups',
              dueDate: DateTime.now().add(const Duration(days: 5)),
              status: 'in-progress',
            ),
            Milestone(
              id: 'm3',
              title: 'Development Phase 1',
              description: 'Backend development',
              dueDate: DateTime.now().add(const Duration(days: 15)),
              status: 'pending',
            ),
          ],
          documents: [
            Document(
              id: 'd1',
              name: 'Service Agreement.pdf',
              type: 'agreement',
              url: '',
              uploadDate: DateTime.now().subtract(const Duration(days: 14)),
              uploader: 'Samadhantra Admin',
            ),
          ],
        ),
        Assignment(
          id: '2',
          requirementTitle: 'UI/UX Design',
          providerName: 'Design Studio Pro',
          providerImage: '',
          status: 'completed',
          assignedDate: DateTime.now().subtract(const Duration(days: 60)),
          startDate: DateTime.now().subtract(const Duration(days: 55)),
          completionDate: DateTime.now().subtract(const Duration(days: 10)),
          budget: 20000.00,
          milestones: [
            Milestone(
              id: 'm1',
              title: 'Wireframe Design',
              description: 'Create wireframes for all screens',
              dueDate: DateTime.now().subtract(const Duration(days: 45)),
              status: 'completed',
              completedDate: DateTime.now().subtract(const Duration(days: 46)),
            ),
            Milestone(
              id: 'm2',
              title: 'Mockup Design',
              description: 'Create high-fidelity mockups',
              dueDate: DateTime.now().subtract(const Duration(days: 30)),
              status: 'completed',
              completedDate: DateTime.now().subtract(const Duration(days: 31)),
            ),
            Milestone(
              id: 'm3',
              title: 'Final Delivery',
              description: 'Deliver all design assets',
              dueDate: DateTime.now().subtract(const Duration(days: 15)),
              status: 'completed',
              completedDate: DateTime.now().subtract(const Duration(days: 16)),
            ),
          ],
          documents: [
            Document(
              id: 'd1',
              name: 'Design Proposal.pdf',
              type: 'proposal',
              url: '',
              uploadDate: DateTime.now().subtract(const Duration(days: 58)),
              uploader: 'Design Studio Pro',
            ),
          ],
        ),
      ];

      print('✅ Assignments loaded: ${assignments.length}');

    } catch (e) {
      errorMessage.value = 'Failed to load assignments: $e';
      print('❌ Error loading assignments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to find and select assignment by ID
  bool selectAssignmentById(String assignmentId) {
    try {
      errorMessage.value = '';
      print('🔍 Looking for assignment with ID: $assignmentId');

      // Clear previous selection
      selectedAssignment.value = null;

      // Find the assignment
      final foundAssignment = assignments.firstWhere(
            (assignment) => assignment.id == assignmentId,
      );

      if (foundAssignment.id != null) {
        selectedAssignment.value = foundAssignment;
        print('✅ Found assignment: ${foundAssignment.requirementTitle}');
        return true;
      } else {
        errorMessage.value = 'Assignment not found';
        print('❌ Assignment not found');
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error finding assignment: $e';
      print('❌ Error in selectAssignmentById: $e');
      return false;
    }
  }

  // Get assignment by ID (without selecting it)
  Assignment? getAssignmentById(String assignmentId) {
    try {
      return assignments.firstWhere((a) => a.id == assignmentId);
    } catch (e) {
      return null;
    }
  }

  List<Assignment> get activeAssignments {
    return assignments.where((a) => a.status != 'completed' && a.status != 'cancelled').toList();
  }

  List<Assignment> get completedAssignments {
    return assignments.where((a) => a.status == 'completed').toList();
  }
}