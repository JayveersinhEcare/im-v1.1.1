import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/constants.dart';
import '../controllers/address_screen_controller.dart';

class AddressScreenView extends GetView<AddressScreenController> {
  const AddressScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print(controller.state.text);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Address '),
          centerTitle: true,
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: controller.formkey,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10.0, bottom: 1.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Name",
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
                              controller: controller.firstname,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter firstName";
                                }
                                return null;
                              },
                              // controller: _username,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Name',
                                  hintText: ''),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10.0, bottom: 1.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Mobile",
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
                              keyboardType: TextInputType.number,
                              controller: controller.phone,
                              validator: (value) {
                                if (value!.isEmpty && value.length == 10) {
                                  return "Please enter Mobile";
                                }
                                return null;
                              },
                              // controller: _username,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Moblie',
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
                            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                            child: TextFormField(
                              controller: controller.email,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter email address";
                                }
                                return null;
                              },
                              // controller: _username,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter email address',
                                  hintText: 'Enter email address'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 5, bottom: 10.0),
                            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Pincode",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      TextFormField(
                                        controller: controller.postal,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Enter pincode";
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                            left: 15.0,
                                          ),
                                          hintText: "Your pincode",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "State",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    DropdownButtonFormField(
                                        hint: const Text("Your state"),
                                        isExpanded: true,
                                        value: controller.state.value.text,
                                        validator: (value) {
                                          if (value == null) {
                                            return 'State is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(8.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        items: state.map((e) {
                                          return DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(
                                              e,
                                              softWrap: false,
                                              style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          controller.state.text = value!;
                                          // print(
                                          //     "state is : ${controller.state.text}");
                                        }),
                                  ],
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10.0, bottom: 1.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Postal address",
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
                              controller: controller.address,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter House no./Building";
                                }
                                return null;
                              },
                              // controller: _username,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter House no./Building',
                                  hintText: 'Enter House no./Building'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 5, bottom: 10.0),
                            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                            child: TextFormField(
                              controller: controller.address1,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Locality/town";
                                }
                                return null;
                              },
                              // controller: _username,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter Locality/town',
                                hintText: 'Enter Locality/town',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 5, bottom: 10.0),
                            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                            child: TextFormField(
                              controller: controller.city,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter City/District";
                                }
                                return null;
                              },
                              // controller: _username,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter City/District',
                                hintText: 'Enter City/District',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                controller.isSavingAddress.value
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
                          minimumSize: const Size(335, 50),
                        ),
                        onPressed: () async {
                          if (controller.formkey.currentState!.validate()) {
                            // print(controller.state.text);
                            var data = {
                              "billing": {
                                "first_name": controller.firstname.text,
                                "address_1": controller.address.text,
                                "address_2": controller.address1.text,
                                "city": controller.city.text,
                                "state": controller.state.text,
                                "postcode": controller.postal.text,
                                "email": controller.email.text,
                                "phone": controller.phone.text
                              },
                            };
                            await controller.saveAddressDetails(data: data);
                            // if (Get.isSnackbarOpen) {
                            //   Get.closeCurrentSnackbar();
                            //   Get.back();
                            // }
                          }
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("ADD NEW ADDRESS"),
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
