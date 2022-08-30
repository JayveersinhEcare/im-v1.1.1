import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share_plus/share_plus.dart';
import '../../../constants/constants.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/drawer_screen_controller.dart';

class DrawerScreenView extends GetView<DrawerScreenController> {
  const DrawerScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var contro = Get.find<HomeController>();
    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: contro.isSaveLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  color: Colors.white,
                  child: ListView(
                    children: [
                      Obx(
                        () => contro.gUser.value != null
                            ? UserAccountsDrawerHeader(
                                margin: const EdgeInsets.only(
                                  bottom: 10.0,
                                ),
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage(
                                    drawerbg,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                                // arrowColor: Colors.black,
                                accountName: Text(
                                  contro.customer.value?.email ??
                                      contro.gUser.value?.displayName ??
                                      "User",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                accountEmail: Text(
                                  contro.gUser.value?.email ??
                                      contro.gUser.value?.phoneNumber
                                          .toString() ??
                                      "",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                currentAccountPicture:
                                    contro.gUser.value?.photoURL != null
                                        ? ClipOval(
                                            child: Image.network(
                                              contro.gUser.value!.photoURL!,
                                              scale: 1.0,
                                            ),
                                          )
                                        : const CircleAvatar(
                                            backgroundColor: tabColor,
                                            child: Icon(Icons.person),
                                          ),
                              )
                            : const UserAccountsDrawerHeader(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage(
                                    drawerbg,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                                // arrowColor: Colors.black,
                                accountName: Text(" Hi Guest "),

                                currentAccountPicture: CircleAvatar(
                                  backgroundColor: tabColor,
                                  child: Icon(Icons.person),
                                ),
                                accountEmail: Text(""),
                              ),
                      ),

                      Obx(() => GestureDetector(
                            onTap: () {
                              Get.back();
                              Get.toNamed(Routes.CART);
                            },
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              // color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 30.0,
                                  left: 20.0,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.shopping_cart,
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    Text(
                                      "My Cart",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 9.0,
                                        right: 9.0,
                                        top: 5.0,
                                        bottom: 5.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: tabColor,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Text(
                                        "${contro.cartCount.value} Items",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 11.50,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                      Obx(
                        () => GestureDetector(
                          onTap: () {
                            Get.back();
                            Get.toNamed(Routes.WISHLIST);
                          },
                          child: SizedBox(
                            width: double.infinity,
                            // color: Colors.red,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 30.0,
                                left: 20.0,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    "Wishlist",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${contro.favCount.value}",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 0.0,
                          left: 20.0,
                          right: 20.0,
                          bottom: 0.0,
                        ),
                        child: Divider(
                          thickness: 1.8,
                        ),
                      ),

                      ///yeeeeeeeeeeeeeee
                      ///
                      GestureDetector(
                        onTap: () {
                          //73
                          Get.back();
                          Get.toNamed(Routes.CATEGORY, arguments: [
                            {"id": "73"},
                            {"name": "IM Combo"}
                          ]);
                        },
                        child: SizedBox(
                          width: double.infinity,
                          // color: Colors.red,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 30.0,
                              left: 20.0,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  imcat,
                                  scale: 3,
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  "IM Combo",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          Get.toNamed(Routes.CATEGORY, arguments: [
                            {"id": "37"},
                            {"name": "Beard"}
                          ]);
                        },
                        child: SizedBox(
                          width: double.infinity,
                          // color: Colors.red,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 30.0,
                              left: 20.0,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  breadcat,
                                  scale: 3,
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  "Beard",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          //63
                          Get.back();
                          Get.toNamed(Routes.CATEGORY, arguments: [
                            {"id": "63"},
                            {"name": "Hair"}
                          ]);
                        },
                        child: SizedBox(
                          width: double.infinity,
                          // color: Colors.red,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 30.0,
                              left: 20.0,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  haircat,
                                  scale: 3,
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  "Hair",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          //65
                          Get.back();
                          Get.toNamed(Routes.CATEGORY, arguments: [
                            {"id": "65"},
                            {"name": "Face"}
                          ]);
                        },
                        child: SizedBox(
                          width: double.infinity,
                          // color: Colors.red,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 30.0,
                              left: 20.0,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  facecat,
                                  scale: 3,
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  "Face",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          //64
                          Get.back();
                          Get.toNamed(Routes.CATEGORY, arguments: [
                            {"id": "64"},
                            {"name": "Body"}
                          ]);
                        },
                        child: SizedBox(
                          width: double.infinity,
                          // color: Colors.red,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 30.0,
                              left: 20.0,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  bodycat,
                                  scale: 3,
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  "Body",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          //68
                          Get.back();
                          Get.toNamed(Routes.CATEGORY, arguments: [
                            {"id": "68"},
                            {"name": "Oral"}
                          ]);
                        },
                        child: SizedBox(
                          width: double.infinity,
                          // color: Colors.red,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 30.0,
                              left: 20.0,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  oralcat,
                                  scale: 3,
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  "Oral",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 0.0,
                          left: 20.0,
                          right: 20.0,
                          bottom: 0.0,
                        ),
                        child: Divider(
                          thickness: 1.8,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Share.share("https://www.incredibleman.in/faq/");
                          controller
                              .launchURL("https://www.incredibleman.in/faq/");
                        },
                        child: SizedBox(
                          width: double.infinity,
                          // color: Colors.red,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 30.0,
                              left: 20.0,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error,
                                  color: Colors.black54,
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  "FAQs",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Share.share(
                          //     "https://www.incredibleman.in/contact-us");
                          controller.launchURL(
                              "https://www.incredibleman.in/contact-us/");
                        },
                        child: SizedBox(
                          width: double.infinity,
                          // color: Colors.red,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 30.0,
                              left: 20.0,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.support_agent,
                                  color: Colors.black54,
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  "Contact Us",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Share.share(
                          //     "https://www.incredibleman.in/privacy-policy/");
                          controller.launchURL(
                              "https://www.incredibleman.in/privacy-policy/");
                        },
                        child: SizedBox(
                          width: double.infinity,
                          // color: Colors.red,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 30.0,
                              left: 20.0,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.lock,
                                  color: Colors.black54,
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  "Privacy Policy",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      contro.gUser.value != null
                          ? GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Alert!"),
                                        content: const Text(
                                            " Are you sure you want to Logout?"),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              contro.logoutGoogle();
                                              Get.back();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: tabColor,
                                            ),
                                            child: Text(
                                              "yes",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.black,
                                            ),
                                            child: Text(
                                              "No",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: SizedBox(
                                width: double.infinity,
                                // color: Colors.red,
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 30.0,
                                    left: 20.0,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.logout_sharp,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(
                                        width: 20.0,
                                      ),
                                      Text(
                                        "Log out",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Get.back();
                                // Get.toNamed(Routes.LOGIN);
                                contro.openLogin(context);
                              },
                              child: SizedBox(
                                width: double.infinity,
                                // color: Colors.red,
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 30.0,
                                    left: 20.0,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.logout_sharp,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(
                                        width: 20.0,
                                      ),
                                      Text(
                                        "Login",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      // const SizedBox(
                      //   height: 250.0,
                      // ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "V1.0.6 ©Incredibleman.in",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
