import 'package:get/get.dart';
import 'forgot_otp_screen_controller.dart';

class ForgotOtpScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotOtpScreenController>(() => ForgotOtpScreenController());
  }
}
