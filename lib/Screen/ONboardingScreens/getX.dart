import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;

  void setPageIndex(int index) {
    currentIndex.value = index;
  }
}