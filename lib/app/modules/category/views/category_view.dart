import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../main.dart';
import '../../../constants/constants.dart';
import '../../../routes/app_pages.dart';
import '../../../utilits/item_search.dart';
import '../../../utilits/shimmer_loading.dart';
import '../../../utilits/shop_container.dart';
import '../controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70.0,
          title: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${controller.name} products"),
                const SizedBox(
                  height: 5,
                ),
                controller.catloading.value
                    ? const SizedBox()
                    : Text(
                        "${controller.categoryProduct.value?.length} Items",
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.white38,
                        ),
                      ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: IconButton(
                icon: Image.asset(
                  search,
                  scale: 2,
                ),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ItemSearch(),
                  );
                },
              ),
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(7.0),
                child: Badge(
                  badgeColor: tabColor,
                  padding: const EdgeInsets.all(5.0),
                  position: const BadgePosition(
                    bottom: 30.0,
                    start: 25.0,
                  ),
                  badgeContent: Center(
                    child: Text(
                      "${controller.cod.cartCount.value}",
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
              ),
            ),
            // PopupMenuButton(
            //   onSelected: (value) {
            //     switch (value) {
            //       case 0:
            //         controller.categoryProduct.value?.sort(
            //           (a, b) => double.parse(a.price!).compareTo(
            //             double.parse(b.price!),
            //           ),
            //         );

            //         break;
            //       case 1:
            //         controller.categoryProduct.value?.sort(
            //           (a, b) => double.parse(b.price!).compareTo(
            //             double.parse(a.price!),
            //           ),
            //         );

            //         break;
            //       default:
            //     }
            //   },
            //   icon: const Icon(Icons.more_vert),
            //   itemBuilder: (context) => [
            //     PopupMenuItem(
            //       value: 0,
            //       child: Row(
            //         children: const [
            //           Icon(
            //             Icons.align_vertical_top,
            //             color: Colors.black,
            //           ),
            //           Text(" Low - High "),
            //         ],
            //       ),
            //     ),
            //     PopupMenuItem(
            //       value: 1,
            //       child: Row(
            //         children: const [
            //           Icon(
            //             Icons.align_vertical_bottom,
            //             color: Colors.black,
            //           ),
            //           Text(" High - Low "),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
        body: Obx(
          (() => controller.catloading.value ||
                  controller.cod.isSaveLoading.value
              ? const Center(
                  child: ShimmerLoading(),
                )
              : controller.categoryProduct.value == null ||
                      controller.categoryProduct.value!.isEmpty
                  ? const Center(child: Text("No Items "))
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            crossAxisCount: 2,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.05),
                          ),
                          itemCount: controller.categoryProduct.value!.length,
                          itemBuilder: (context, index) {
                            final p = controller.categoryProduct.value![index];
                            return ShopContainer(
                                price:
                                    p.onSale! ? p.salePrice! : p.regularPrice!,
                                image: p.images![0].src!,
                                dec: p.name,
                                dec2: p.name,
                                tag: "tag-${p.name} + ${p.price}",
                                like: () async {
                                  if (Hive.box(FavList).containsKey(p.id)) {
                                    controller.cod.favRemove(p.id);
                                  } else {
                                    controller.cod.addFav(p.id, p.id);
                                  }
                                },
                                details: () {
                                  Get.toNamed(Routes.PRODUCT_DETAIL,
                                      arguments: [
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
                          }),
                    )),
        ),
      ),
    );
  }
}
