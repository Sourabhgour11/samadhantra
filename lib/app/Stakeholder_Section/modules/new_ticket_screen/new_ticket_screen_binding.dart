import 'package:get/get.dart';
import 'new_ticket_screen_controller.dart';

class NewTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewTicketController());
  }
}