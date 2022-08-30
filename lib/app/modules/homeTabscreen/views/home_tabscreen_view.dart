import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:incredibleman/app/constants/constants.dart';
import 'package:incredibleman/app/utilits/shop_container.dart';
import '../../../../main.dart';
import '../../../routes/app_pages.dart';
import '../../../utilits/tab_shimmer.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/home_tabscreen_controller.dart';

class HomeTabscreenView extends GetView<HomeTabscreenController> {
  const HomeTabscreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var contro = Get.find<HomeController>();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            GetBuilder<HomeTabscreenController>(
              init: controller,
              builder: ((controller) => SizedBox(
                    height: height / 7.5,
                    child: controller.categoryList.value == null
                        ? const TabShimmer()
                        : ListView.builder(
                            itemCount:
                                controller.categoryList.value!.length - 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final cat = controller.categoryList.value![index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 8.0,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.CATEGORY, arguments: [
                                      {"id": cat.id},
                                      {"name": cat.name}
                                    ]);
                                  },
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.20),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(
                                            5,
                                            5,
                                          ), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: height / 15,
                                          child: Image.asset(
                                            cimage[index],
                                            scale: 2,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          cat.name!,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                  )),
            ),
            const SizedBox(
              height: 5.0,
            ),
            GetBuilder<HomeTabscreenController>(
              init: controller,
              builder: ((controller) => controller.banner == null
                  ? const ContainerShimmer()
                  : GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.CATEGORY, arguments: [
                          {"id": controller.banner?.post1!.offerCategory![0]},
                          {"name": "offer"}
                        ]);
                      },
                      child: FittedBox(
                          child: SizedBox(
                        height: height / 3.8,
                        width: width,
                        child: Image.network(
                          controller.banner!.post1!.banner!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Image.asset(
                              logoloader,
                              width: width / 2,
                              height: height / 3.5,
                            );
                          },
                        ),
                      )),
                    )),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Best Selling ",
                  style: GoogleFonts.poppins(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0.0),
                    primary: Colors.transparent,
                    elevation: 0.0,
                    alignment: Alignment.centerRight,
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.ALL_PRODUCT_SCREEN);
                  },
                  child: Text(
                    "See all",
                    style: GoogleFonts.poppins(
                      color: Colors.black45,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Obx(
              (() => controller.productsAll.value == null ||
                      contro.isSaveLoading.value
                  ? const Center(
                      child: ContainerShimmer(),
                    )
                  : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      reverse: true,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.05),
                      ),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        final p = controller.productsAll.value![index + 24];

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
                      })),
            ),
            GetBuilder<HomeTabscreenController>(
              init: controller,
              builder: ((controller) => controller.banner == null
                  ? const ContainerShimmer()
                  : GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.CATEGORY, arguments: [
                          {"id": controller.banner?.post2!.offerCategory![0]},
                          {"name": "offer"}
                        ]);
                      },
                      child: FittedBox(
                          child: SizedBox(
                        height: height / 3.8,
                        width: width,
                        child: Image.network(
                          controller.banner!.post2!.banner!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Image.asset(
                              logoloader,
                              width: width / 2,
                              height: height / 3.5,
                            );
                          },
                        ),
                      )),
                    )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommended",
                  style: GoogleFonts.poppins(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0.0),
                    primary: Colors.transparent,
                    elevation: 0.0,
                    alignment: Alignment.centerRight,
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.ALL_PRODUCT_SCREEN);
                  },
                  child: Text(
                    "See all",
                    style: GoogleFonts.poppins(
                      color: Colors.black45,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 9.0,
            ),
            Obx(
              (() => controller.productsAll.value == null ||
                      contro.isSaveLoading.value
                  ? const Center(
                      child: ContainerShimmer(),
                    )
                  : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.05),
                      ),
                      itemCount: controller.productsAll.value!.length - 25,
                      itemBuilder: (context, index) {
                        final p = controller.productsAll.value![index];
                        return ShopContainer(
                            price: p.onSale! ? p.salePrice! : p.regularPrice!,
                            image: p.images![0].src!,
                            dec: p.name,
                            dec2: p.name,
                            tag: "tag-${p.name} + ${p.price}",
                            like: () async {
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
                      })),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text("© 2021 Incredible Man"),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
