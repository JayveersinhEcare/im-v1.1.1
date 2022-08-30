import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:incredibleman/app/routes/app_pages.dart';

import '../../../constants/constants.dart';
import '../../../utilits/wishlist_container.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var contro = Get.find<HomeController>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70.0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Wishlist"),
              const SizedBox(
                height: 5.0,
              ),
              Obx(
                () => Text(
                  "${contro.favCount.value} Items",
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.white38,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Obx(() => Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Badge(
                    badgeColor: tabColor,
                    padding: const EdgeInsets.all(5.0),
                    position: const BadgePosition(
                      bottom: 29.0,
                      start: 29.0,
                    ),
                    badgeContent: Center(
                      child: Text(
                        "${contro.cartCount.value}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Get.toNamed(Routes.CART);
                      },
                    ),
                  ),
                )),
          ],
        ),
        body: Obx(
          () => contro.isSaveLoading.value
              ? const SizedBox(
                  height: 400,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : contro.favItems.value == null || contro.favItems.value!.isEmpty
                  ? const Center(
                      child: Text("No items Added Yet"),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 8.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          crossAxisCount: 2,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.05),
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: contro.favItems.value?.length,
                        itemBuilder: (context, index) {
                          final products = contro.favItems.value![index];
                          return WishListContainer(
                            like: () {
                              contro.favRemove(products.id);
                            },
                            details: () {
                              Get.toNamed(Routes.PRODUCT_DETAIL, arguments: [
                                {"product": products}
                              ]);
                            },
                            dec: products.name,
                            dec2: products.name,
                            price: products.price,
                            image: products.images![0].src,
                          );
                        },
                      ),
                    ),
        ),
      ),
    );
  }
}
