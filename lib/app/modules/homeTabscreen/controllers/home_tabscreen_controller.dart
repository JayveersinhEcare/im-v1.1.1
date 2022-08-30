import 'package:get/get.dart';

import '../../../data/customModels/banner_ad.dart';
import '../../../data/woocommerceModels/wooMain/woo_main.dart';
import '../../../data/woocommerceModels/woo_product_category.dart';
import '../../../data/woocommerceModels/woo_products.dart';
import '../../splash/controllers/splash_controller.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class HomeTabscreenController extends GetxController {
  var cod = Get.find<SplashController>();

  Rx<List<WooProductCategory>?> categoryList =
      Rx<List<WooProductCategory>?>(null);
  Rx<List<WooProduct>?> productsAll = Rx<List<WooProduct>?>(null);

  BannerAd? banner;
  Rx<WooCommerce?> wooCommerce = Rx<WooCommerce?>(null);
  @override
  void onInit() {
    getCategorys();
    productsAll.value = cod.newProducts.value;
    wooCommerce.value = cod.wooCommerce.value;
    super.onInit();
  }

  @override
  void onReady() {
    bannerAD();
    super.onReady();
  }

  getCategorys() async {
    categoryList.value = await cod.wooCommerce.value.getProductCategories();
    update();
  }

  bannerAD() async {
    try {
      var response = await http.get(
          Uri.parse("https://www.incredibleman.in/wp-json/banner/v1/banner"));

      banner = bannerAdFromJson(response.body);

      // ignore: unused_catch_clause
    } on Exception catch (e) {
      rethrow;
    }
    update();
  }
}
