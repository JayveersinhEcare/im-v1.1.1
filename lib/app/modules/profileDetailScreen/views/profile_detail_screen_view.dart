import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:incredibleman/app/routes/app_pages.dart';

import '../../../constants/constants.dart';
import '../../../data/woocommerceModels/woo_customer.dart';
import '../controllers/profile_detail_screen_controller.dart';

class ProfileDetailScreenView extends GetView<ProfileDetailScreenController> {
  const ProfileDetailScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile Details"),
          toolbarHeight: 70.0,
          elevation: 0.0,
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
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
                        left: width / 3,
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: bgcontainer,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            size: 70.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                Form(
                  key: controller.formkey,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10.0, bottom: 1.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Username",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 5, bottom: 10.0),
                            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                            child: TextFormField(
                              // initialValue: widget.user.firstName,
                              controller: controller.username,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Username";
                                }
                                return null;
                              },

                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Username',
                                  hintText: ''),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10.0, bottom: 1.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Email address",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 5, bottom: 10.0),
                            child: TextFormField(
                              controller: controller.email,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter email";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter email',
                                hintText: '',
                                // enabled: false,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10.0, bottom: 1.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Birthday ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controller.birth.isBlank!
                                      ? Container()
                                      : Text(
                                          "${controller.birth[0].value ?? ""}",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: tabColor,
                                          ),
                                        ),
                                  TextButton(
                                    onPressed: () {
                                      controller.editBirth();
                                    },
                                    child: Text("Edit",
                                        style: GoogleFonts.poppins(
                                          color: tabColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.editBirthDay.value,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 5,
                                  bottom: 10.0),
                              // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    // color: Colors.amber,
                                    border: Border.all(color: Colors.black45),
                                    borderRadius: BorderRadius.circular(7.0)),
                                child: Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceAround,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: controller.dd,
                                      // validator: (value) {
                                      //   if (value.isEmpty) {
                                      //     return "Day";
                                      //   }
                                      //   return null;
                                      // },
                                      maxLength: 2,

                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          left: 30,
                                        ),
                                        counterText: "",
                                        hintText: "DD",
                                        border: InputBorder.none,
                                      ),
                                    )),
                                    const SizedBox(
                                      height: 50,
                                      child: VerticalDivider(),
                                    ),

                                    Expanded(
                                        child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: controller.mm,
                                      // validator: (value) {
                                      //   if (value.isEmpty) {
                                      //     return "Month";
                                      //   }
                                      //   return null;
                                      // },

                                      maxLength: 2,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          left: 30,
                                        ),
                                        counterText: "",
                                        hintText: "MM",
                                        border: InputBorder.none,
                                      ),
                                    )),
                                    const SizedBox(
                                      height: 50,
                                      child: VerticalDivider(),
                                    ),
                                    Expanded(
                                        child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: controller.yyyy,

                                      // validator: (value) {
                                      //   if (value.isEmpty) {
                                      //     return "Year";
                                      //   }
                                      //   return null;
                                      // },
                                      maxLength: 4,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          left: 30,
                                        ),
                                        hintText: "YYYY",
                                        counterText: "",
                                        border: InputBorder.none,
                                      ),
                                    )),
                                    // Container(child: TextField()),
                                    // Container(child: TextField()),
                                    // TextField(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10.0, bottom: 1.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Mobile number",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 5, bottom: 10.0),
                            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                            child: TextFormField(
                              controller: controller.mobile,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter mobile";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              maxLength: 10,

                              // controller: _username,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter mobile number',
                                  counterText: "",
                                  hintText: ''),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.contro.customer.value != null,
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.toNamed(Routes.CHANGE_PASSWORD_SCREEN);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      side: const BorderSide(
                        width: 1.0,
                        color: tabColor,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      minimumSize: Size(width / 1.16, 50),
                    ),
                    child: const Text(
                      "CHANGE PASSWORD",
                      style: TextStyle(color: tabColor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                controller.isProfileSaving.value
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.black54),
                      )
                    : ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: tabColor,
                          textStyle: GoogleFonts.poppins(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          minimumSize: Size(width / 1.16, 50),
                        ),
                        onPressed: () async {
                          if (controller.formkey.currentState!.validate()) {
                            WooCustomer updateCustomer = WooCustomer(
                              id: controller.contro.customer.value?.id,
                              email: controller.email.text,
                              billing: Billing(phone: controller.mobile.text),
                              metaData: [
                                WooCustomerMetaData(
                                    controller.contro.customer.value?.id,
                                    "birthday_field",
                                    "${controller.dd.text} - ${controller.mm.text} -${controller.yyyy.text}")
                              ],
                            );
                            await controller.updateUserFromAPI(updateCustomer);
                            Get.snackbar(
                              "Updated Details",
                              "Your Details Has Been Updated",
                              backgroundColor: Colors.white,
                              colorText: Colors.black,
                            );
                          }
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Save"),
                      ),
                const SizedBox(
                  height: 25.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
