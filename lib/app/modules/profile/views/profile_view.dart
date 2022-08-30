import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:incredibleman/app/modules/home/controllers/home_controller.dart';
import 'package:incredibleman/app/routes/app_pages.dart';
import '../../../constants/constants.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var cod = Get.find<HomeController>();
    // print(cod.gUser.value);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Obx(
            () => cod.isSaveLoading.value
                ? Container()
                : Column(
                    children: [
                      Container(
                        height: height / 6,
                        width: double.infinity,
                        color: Colors.black,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: height / 15,
                              left: width / 30,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 90.0,
                                      width: 90.0,
                                      decoration: BoxDecoration(
                                          color: bgcontainer,
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: const Icon(
                                        Icons.person_outline_outlined,
                                        size: 50.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        cod.gUser.value != null
                                            ? Text(
                                                cod.customer.value?.username ??
                                                    cod.gUser.value
                                                        ?.displayName ??
                                                    "User",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                              )
                                            : Text(
                                                "Hello Guest",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                        // SizedBox(
                                        //   height: 5.0,
                                        // ),
                                        cod.gUser.value != null
                                            ? Text(
                                                cod.customer.value?.email ??
                                                    cod.gUser.value?.email ??
                                                    cod.gUser.value
                                                        ?.phoneNumber ??
                                                    "",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white38,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 35.0,
                      ),
                      ListTile(
                        onTap: () {
                          //newwwwww
                          Get.toNamed(Routes.WISHLIST);
                        },
                        title: Text(
                          "Wishlist",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        leading: Image.asset(
                          wishList,
                          scale: 2,
                        ),
                        subtitle: const Text("your most loved products"),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                        ),
                      ),
                      cod.gUser.value != null ? const Divider() : Container(),
                      cod.gUser.value != null
                          ? ListTile(
                              onTap: () {
                                Get.toNamed(Routes.ADDRESS_SCREEN);
                              },
                              title: Text(
                                "Address",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              leading: Image.asset(
                                address,
                                scale: 2,
                              ),
                              subtitle: const Text("save address for checkout"),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                              ),
                            )
                          : Container(),
                      cod.gUser.value != null ? const Divider() : Container(),
                      cod.gUser.value != null
                          ? ListTile(
                              onTap: () {
                                Get.toNamed(Routes.PROFILE_DETAIL_SCREEN);
                              },
                              title: Text(
                                "Profile Details",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              leading: Image.asset(
                                profile,
                                scale: 2,
                              ),
                              subtitle:
                                  const Text("Change profile information"),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                              ),
                            )
                          : Container(),
                      const Divider(),
                      cod.gUser.value != null
                          ? Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    textStyle: GoogleFonts.poppins(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    side: const BorderSide(
                                      width: 1.0,
                                      color: tabColor,
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    minimumSize: Size(width / 1.12, 50),
                                  ),
                                  onPressed: () {
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
                                                  cod.logoutGoogle();
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
                                                  Get.back();
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
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: tabColor,
                                  ),
                                  label: const Text(
                                    "LOG OUT",
                                    style: TextStyle(
                                      color: tabColor,
                                    ),
                                  )),
                            )
                          : Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    textStyle: GoogleFonts.poppins(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    side: const BorderSide(
                                      width: 1.0,
                                      color: tabColor,
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    minimumSize: Size(width / 1.12, 50),
                                  ),
                                  onPressed: () {
                                    cod.openLogin(context);
                                    //new
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: tabColor,
                                  ),
                                  label: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: tabColor,
                                    ),
                                  )),
                            ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
          ),
        ));
  }
}
