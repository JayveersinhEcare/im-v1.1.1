// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:get/get.dart';

import '../../../data/woocommerceModels/woo_products.dart';
import '../../home/controllers/home_controller.dart';
import '../../homeTabscreen/controllers/home_tabscreen_controller.dart';

class CategoryController extends GetxController {
  var homeTabController = Get.find<HomeTabscreenController>();
  var cod = Get.find<HomeController>();

  Rx<List<WooProduct>?> categoryProduct = Rx<List<WooProduct>?>(null);
  var catloading = RxBool(true);
  var id;
  var name;
  @override
  void onInit() async {
    var data = Get.arguments;
    id = data[0]['id'];
    name = data[1]['name'];
    // print("aaa to che idddd $id");
    // print("aaa to che name $name");
    await getProductByCategory();

    super.onInit();
  }

  getProductByCategory() async {
    categoryProduct.value = await homeTabController.wooCommerce.value
        ?.getProducts(category: "$id", minPrice: "1");
    catloading(false);
  }
}
