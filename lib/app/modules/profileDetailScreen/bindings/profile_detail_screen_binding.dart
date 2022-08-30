import 'package:get/get.dart';

import '../controllers/profile_detail_screen_controller.dart';

class ProfileDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileDetailScreenController>(
      () => ProfileDetailScreenController(),
    );
  }
}
