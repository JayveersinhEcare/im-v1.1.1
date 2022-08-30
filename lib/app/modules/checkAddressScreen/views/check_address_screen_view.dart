import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:incredibleman/app/routes/app_pages.dart';

import '../../../constants/constants.dart';
import '../../../data/hiveDB/cartbox.dart';
import '../controllers/check_address_screen_controller.dart';

class CheckAddressScreenView extends GetView<CheckAddressScreenController> {
  const CheckAddressScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Address"),
          toolbarHeight: 70.0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ElevatedButton(
          onPressed: () {
            // openCheckOut();
            // Get.to(() => SummaryScreen(
            //       user: widget.user,
            //       price: widget.price!,
            //       products: widget.products,
            //     ));
            var d = Get.arguments;
            if (d != null) {
              // print(d[0]['product'][0].id);
              Get.toNamed(Routes.SUMMARY_SCREEN, arguments: [
                {
                  "product": [
                    CartBox(
                        1,
                        d[0]['product'][0].id,
                        d[0]['product'][0].name,
                        d[0]['product'][0].price,
                        d[0]['product'][0].urlImage ?? "",
                        true),
                  ]
                }
              ]);
            } else {
              Get.toNamed(Routes.SUMMARY_SCREEN);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            side: const BorderSide(
              width: 1.0,
              color: black,
            ),
            padding: const EdgeInsets.all(8.0),
            minimumSize: const Size(335, 50),
          ),
          child: const Text(
            "Proceed to Payment",
            style: TextStyle(
              color: black,
            ),
          ),
        ),
        body: Column(
          children: [
            ListTile(
              selected: true,
              selectedTileColor: const Color(0xffF1F1F1),
              onTap: () {
                // print("tile click");
              },
              leading: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: IconButton(
                  padding: const EdgeInsets.all(0.0),
                  icon: const Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 19.0,
                  ),
                  onPressed: () {},
                ),
              ),
              trailing: TextButton(
                onPressed: () {
                  Get.toNamed(Routes.ADDRESS_SCREEN);
                  // Get.to(() => EditAddressScreen(
                  //       user: widget.user,
                  //     ));
                },
                child: Text(
                  "Edit",
                  style: GoogleFonts.poppins(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: tabColor,
                  ),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  " ${controller.contro.customer.value?.billing!.firstName ?? " "} ",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${controller.contro.customer.value?.billing!.address1}, ${controller.contro.customer.value?.billing!.city}, ${controller.contro.customer.value?.billing!.address2}\n${controller.contro.customer.value?.billing?.postcode} ${controller.contro.customer.value?.billing!.state}",
                      style: GoogleFonts.poppins(
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Mobile: ${controller.contro.customer.value?.billing!.phone}",
                      style: GoogleFonts.poppins(
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
