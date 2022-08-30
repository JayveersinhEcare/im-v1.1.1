import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:incredibleman/app/routes/app_pages.dart';
import '../../../../main.dart';
import '../../../constants/constants.dart';
import '../../../utilits/shop_container.dart';
import '../../../utilits/tab_shimmer.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/im_comboo_screen_controller.dart';

class ImCombooScreenView extends GetView<ImCombooScreenController> {
  const ImCombooScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var cod = Get.find<HomeController>();
    return Obx(
      (() => controller.imloading.value || cod.isSaveLoading.value
          ? const Center(
              child: ContainerShimmer(),
            )
          : controller.imComboo.value == null ||
                  controller.imComboo.value!.isEmpty
              ? const Center(child: Text("No Items "))
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.05),
                      ),
                      itemCount: controller.imComboo.value!.length,
                      itemBuilder: (context, index) {
                        final p = controller.imComboo.value![index];
                        return ShopContainer(
                            price: p.onSale! ? p.salePrice! : p.regularPrice!,
                            image: p.images![0].src!,
                            dec: p.name,
                            dec2: p.name,
                            tag: "tag-${p.name} + ${p.price}",
                            like: () async {
                              if (Hive.box(FavList).containsKey(p.id)) {
                                cod.favRemove(p.id);
                              } else {
                                cod.addFav(p.id, p.id);
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
                      }),
                )),
    );
  }
}
