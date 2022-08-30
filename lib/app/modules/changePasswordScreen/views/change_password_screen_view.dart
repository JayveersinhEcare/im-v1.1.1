import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/constants.dart';
import '../controllers/change_password_screen_controller.dart';

class ChangePasswordScreenView extends GetView<ChangePasswordScreenController> {
  const ChangePasswordScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Change Your Password"),
        ),
        body: Form(
          key: controller.formkey,
          child: Column(
            children: [
              const SizedBox(
                height: 35.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20, top: 10.0, bottom: 1.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    " Enter New Password",
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
                  controller: controller.newPassword,
                  // initialValue: widget.user.firstName,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter new password";
                    }
                    return null;
                  },
                  // controller: _username,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter new password',
                    hintText: '',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20, top: 10.0, bottom: 1.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Confirm password",
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
                  controller: controller.confirm,

                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Confirm password";
                    }
                    return null;
                  },
                  // controller: _username,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Confirm password',
                    hintText: '',
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              controller.isloadingPassword.value
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
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
                          await controller.changePassword();
                          Get.back();
                          Get.snackbar(
                            "password changed",
                            "Your Password has been updated ",
                            colorText: Colors.white,
                            backgroundColor: Colors.black,
                          );
                        }
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Save"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
