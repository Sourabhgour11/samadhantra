import 'package:get/get.dart';
import 'package:samadhantra/app/modules/auth/signup_screen/signup_screen_controller.dart';

class SignupScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupScreenController>(() => SignupScreenController());
  }
}
