// bindings/proposal_detail_binding.dart
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/proposals_details_screen/proposals_details_screen_controller.dart';

class ProposalDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProposalDetailController());
  }
}