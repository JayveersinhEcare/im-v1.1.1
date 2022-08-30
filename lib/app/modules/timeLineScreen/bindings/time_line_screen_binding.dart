import 'package:get/get.dart';

import '../controllers/time_line_screen_controller.dart';

class TimeLineScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimeLineScreenController>(
      () => TimeLineScreenController(),
    );
  }
}
