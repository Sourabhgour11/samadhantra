 import 'package:get/get.dart';
import 'message_screen_controller.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(
          () => MessageController(),
    );
  }
}