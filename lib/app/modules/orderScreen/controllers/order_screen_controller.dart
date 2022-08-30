import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';

class OrderScreenController extends GetxController {
  var cod = Get.find<HomeController>();
  @override
  void onInit() async {
    super.onInit();
    await cod.getOrders();
  }
}
