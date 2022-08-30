import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:incredibleman/app/routes/app_pages.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../main.dart';
import '../../../constants/constants.dart';
import '../../../data/hiveDB/cartbox.dart';
import '../../../utilits/cart_container.dart';
import '../../../utilits/sample_container.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var contro = Get.find<HomeController>();
    double width = MediaQuery.of(context).size.width;
    // print(contro.cartItems.value!.length);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70.0,
          title: const Text(
            "Shopping cart",
            style: TextStyle(color: Colors.white),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              double.parse(contro.cartTotals.value) >= 700.0
                  ? ElevatedButton.icon(
                      onPressed: () async {
                        showCupertinoModalBottomSheet(
                          builder: (context) {
                            return Material(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SingleChildScrollView(
                                // physics: const NeverScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      "Add Sample Prodcuts",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Obx(
                                      (() => ListView.builder(
                                          itemCount: controller
                                              .sampleItem.value!.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final cat = controller
                                                .sampleItem.value![index];
                                            //  CartBox dd = contro.tcart[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SampleContainer(
                                                name: cat.name!,
                                                url: cat.images![0].src ??
                                                    "https://incredibleman-174dc.kxcdn.com/wp-content/uploads/2021/09/pomade.png",
                                                add: () {
                                                  var x = contro.cartItems.value
                                                      ?.where((element) =>
                                                          element.sample ==
                                                          false)
                                                      .toList();
                                                  if (double.parse(contro
                                                              .cartTotals
                                                              .value) >=
                                                          1200.0 &&
                                                      x!.length < 2) {
                                                    Hive.box(CartBoxDB).put(
                                                        cat.id,
                                                        CartBox(
                                                          1,
                                                          cat.id!,
                                                          cat.name!,
                                                          cat.price!,
                                                          cat.images![0].src!,
                                                          false,
                                                        ));
                                                    contro.getCartTotal();
                                                  } else if (double.parse(contro
                                                              .cartTotals
                                                              .value) >=
                                                          700.0 &&
                                                      double.parse(contro
                                                              .cartTotals
                                                              .value) <
                                                          1200.0 &&
                                                      // ignore: prefer_is_empty
                                                      x!.length == 0) {
                                                    Hive.box(CartBoxDB).put(
                                                        cat.id,
                                                        CartBox(
                                                          1,
                                                          cat.id!,
                                                          cat.name!,
                                                          cat.price!,
                                                          cat.images![0].src!,
                                                          false,
                                                        ));
                                                    contro.getCartTotal();

                                                    Get.snackbar(
                                                      "Sample Added",
                                                      "one Sample Added",
                                                      backgroundColor:
                                                          Colors.black54,
                                                      colorText: Colors.white,
                                                    );
                                                  } else {
                                                    Get.snackbar(
                                                      "Sample Already Added",
                                                      "No More Sample ",
                                                      backgroundColor:
                                                          Colors.black54,
                                                      colorText: Colors.white,
                                                    );
                                                  }
                                                },
                                              ),
                                            );
                                          })),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          context: context,
                          expand: true,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          textStyle: GoogleFonts.poppins(
                            fontSize: 17.0,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          minimumSize: Size(width / 1.1, 60)),
                      icon: const Icon(CupertinoIcons.arrow_right_circle_fill),
                      label: const Text("Add Sample"),
                    )
                  : Container(),
              const SizedBox(
                height: 5.0,
              ),
              contro.cartCount.value == 0
                  ? ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          textStyle: GoogleFonts.poppins(
                            fontSize: 17.0,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          minimumSize: Size(width / 1.1, 60)),
                      icon: const Icon(CupertinoIcons.arrow_right_circle_fill),
                      label: const Text("Add Product to cart"),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        contro.gUser.value != null &&
                                contro.customer.value?.billing?.address1 == ""
                            ? Get.toNamed(Routes.ADDRESS_SCREEN)
                            : contro.gUser.value == null
                                ? contro.openLogin(context)
                                : Get.toNamed(Routes.CHECK_ADDRESS_SCREEN);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          textStyle: GoogleFonts.poppins(
                            fontSize: 17.0,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          minimumSize: Size(width / 1.1, 60)),
                      icon: const Icon(CupertinoIcons.arrow_right_circle_fill),
                      label: const Text("PLACE ORDER"),
                    ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Obx(
                  () => contro.isSaveLoading.value
                      ? const SizedBox(
                          height: 400,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "${contro.cartCount.value} Items",
                                style: GoogleFonts.poppins(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "Total: ${rupee + contro.cartTotals.string}",
                                style: GoogleFonts.poppins(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                Obx(
                  () => contro.isSaveLoading.value
                      ? const SizedBox(
                          height: 400,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : contro.cartItems.value!.isEmpty
                          ? const Center(
                              child: Text("No items Added Yet"),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                CartBox cBox = contro.cartItems.value![index];
                                return OrderContainer(
                                  sample: contro.cartItems.value![index].sample,
                                  qun: cBox.quntity.toString(),
                                  url: cBox.urlImage,
                                  name: cBox.name,
                                  price: cBox.price,
                                  shortname: cBox.name,
                                  wishList: () {
                                    if (Hive.box(FavList)
                                        .containsKey(cBox.id)) {
                                      contro.favRemove(cBox.id);
                                    } else {
                                      contro.addFav(cBox.id, cBox.id);
                                    }
                                  },
                                  minus: () {
                                    var qv = cBox.quntity--;
                                    if (qv != 1) {
                                      qv--;
                                    }
                                    // print(qv);
                                    contro.addToCart(
                                        cBox.id,
                                        CartBox(
                                          qv,
                                          cBox.id,
                                          cBox.name,
                                          cBox.price,
                                          cBox.urlImage,
                                          true,
                                        ));
                                    contro.sampleDatacheck();
                                  },
                                  inc: () {
                                    var qvr = cBox.quntity++;
                                    if (qvr != 10) {
                                      qvr++;
                                    }
                                    // print(qvr);
                                    contro.addToCart(
                                        cBox.id,
                                        CartBox(
                                          qvr,
                                          cBox.id,
                                          cBox.name,
                                          cBox.price,
                                          cBox.urlImage,
                                          true,
                                        ));
                                    contro.sampleDatacheck();
                                  },
                                  remove: () {
                                    contro.removeCartItem(cBox.id);
                                    contro.sampleDatacheck();
                                  },
                                  ic: Icon(
                                      Hive.box(FavList).containsKey(cBox.id)
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                      color:
                                          Hive.box(FavList).containsKey(cBox.id)
                                              ? Colors.red
                                              : Colors.black),
                                );
                              },
                              itemCount: contro.cartItems.value?.length,
                            ),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
