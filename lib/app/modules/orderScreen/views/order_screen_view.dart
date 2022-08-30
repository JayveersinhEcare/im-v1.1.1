import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/constants.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/order_screen_controller.dart';

class OrderScreenView extends GetView<OrderScreenController> {
  const OrderScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var cod = Get.find<HomeController>();
    final width = MediaQuery.of(context).size.width;
    // print(cod.orders.value);
    return Scaffold(
      body: Obx(
        () => cod.isOrderLoading.value
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : cod.orders.value != null && cod.orders.value!.isEmpty
                ? const Center(
                    child: Text("No Orders Yet"),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final ord = cod.orders.value![index];
                        return SizedBox(
                          width: width,
                          child: ExpansionTile(
                            title: Text(
                              ord.number.toString(),
                              style: GoogleFonts.poppins(
                                color: mainColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ord.status.toString(),
                                  style: GoogleFonts.poppins(
                                    color: ord.status == "cancelled"
                                        ? Colors.red
                                        : ord.status == "processing" ||
                                                ord.status == "completed"
                                            ? Colors.green
                                            : Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Column(
                                children: List.generate(
                                  ord.lineItems!.length,
                                  (index) => ListTile(
                                    title: Text(
                                        "${ord.lineItems![index].name.toString()} ☓${ord.lineItems![index].quantity}"),
                                    subtitle: Text(
                                        "$rupee ${double.parse(ord.lineItems![index].price!).roundToDouble().toString()}"),
                                  ),
                                ),
                              ),
                              Column(
                                children: List.generate(
                                  ord.shippingLines!.length,
                                  (index) => ListTile(
                                    title: Text(
                                      "Shipping ${ord.shippingLines![index].methodTitle}",
                                    ),
                                    subtitle: Text(
                                        "$rupee ${ord.shippingLines![index].total.toString()}"),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: const Text("Total"),
                                subtitle: Text(
                                  "$rupee ${ord.total} (includes CGST, SGST)",
                                ),
                              ),

                              ///              This Block will take to OrderTimeline Screen   /////////////////
                              // TextButton(
                              //   onPressed: () {
                              //     Get.to(() => const OrderTimelineScreen());
                              //   },
                              //   child: Text(
                              //     "Track Order",
                              //     style: GoogleFonts.poppins(
                              //       color: tabColor,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.black45,
                      ),
                      itemCount: cod.orders.value?.length ?? 0,
                    ),
                  ),
      ),
    );
  }
}
