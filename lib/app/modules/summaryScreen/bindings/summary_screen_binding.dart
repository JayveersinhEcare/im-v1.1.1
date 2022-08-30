import 'package:get/get.dart';

import '../controllers/summary_screen_controller.dart';

class SummaryScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      SummaryScreenController(),
    );
  }
}
