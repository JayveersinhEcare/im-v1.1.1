import 'package:get/get.dart';

import '../controllers/all_product_screen_controller.dart';

class AllProductScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllProductScreenController>(
      () => AllProductScreenController(),
    );
  }
}
