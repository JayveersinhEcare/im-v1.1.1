import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../main.dart';
import '../../../constants/constants.dart';
import '../../../routes/app_pages.dart';
import '../../../utilits/shop_container.dart';
import '../../../utilits/tab_shimmer.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/all_product_screen_controller.dart';

class AllProductScreenView extends GetView<AllProductScreenController> {
  const AllProductScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var contro = Get.find<HomeController>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70.0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Products List",
              ),
              const SizedBox(
                height: 5.0,
              ),
              Obx(
                () => Text(
                  "${contro.cod.productsAll.value?.length} items",
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 15.0,
                  ),
                ),
              )
            ],
          ),
          actions: [
            Padding(
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
            )
          ],
        ),
        body: Obx(
          (() =>
              contro.cod.productsAll.value == null || contro.isSaveLoading.value
                  ? const Center(
                      child: ContainerShimmer(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          crossAxisCount: 2,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.05),
                        ),
                        itemCount: contro.cod.productsAll.value?.length,
                        itemBuilder: (context, index) {
                          final p = contro.cod.productsAll.value![index];
                          return ShopContainer(
                              price: p.onSale! ? p.salePrice! : p.regularPrice!,
                              image: p.images![0].src!,
                              dec: p.name,
                              dec2: p.name,
                              tag: "tag-${p.name} + ${p.price}",
                              like: () async {
                                // contro.isSaveCheck(p.id);
                                if (Hive.box(FavList).containsKey(p.id)) {
                                  contro.favRemove(p.id);
                                } else {
                                  contro.addFav(p.id, p.id);
                                }
                              },
                              details: () {
                                Get.toNamed(Routes.PRODUCT_DETAIL, arguments: [
                                  {"product": p}
                                ]);
                              },
                              icon: Icon(
                                Icons.favorite,
                                size: 20.0,
                                color: Hive.box(FavList).containsKey(p.id)
                                    ? Colors.red
                                    : bgcontainer,
                              ),
                              sale: p.onSale!);
                        },
                      ),
                    )),
        ),
      ),
    );
  }
}
