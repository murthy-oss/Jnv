import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProfileController extends GetxController {
  RxBool hideEmail = false.obs; // RxBool for email checkbox
  RxBool hideLinkedin = false.obs; // RxBool for email checkbox
  RxBool hidePhone = false.obs; // RxBool for email checkbox
  void toggleEmailVisibility() {
    hideEmail.value = !hideEmail.value;
// Toggle checkbox value
  }

  void togglePhoneVisibility() {
    hidePhone.value = !hidePhone.value;
 // Toggle checkbox value
  }

  void toggleLinkedinVisibility() {
    hideLinkedin.value = !hideLinkedin.value;
// Toggle checkbox value
  }
}
