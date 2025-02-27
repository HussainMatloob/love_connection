import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text("Forgot Password", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reset Your Password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Enter your email address to reset your password.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  prefixIcon: Icon(Icons.email, color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),

              Obx(() => controller.isEmailVerified.value
                  ? Column(
                children: [
                  TextField(
                    controller: controller.passwordController,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      prefixIcon: Icon(Icons.lock, color: Colors.pink),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  Obx(() => SizedBox(
                    width: double.infinity, // FULL WIDTH
                    child: ElevatedButton(
                      onPressed: controller.isLoadingUpdate.value ? null : controller.updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: controller.isLoadingUpdate.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        "Update Password",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  )),
                ],
              )
                  : Obx(() => SizedBox(
                width: double.infinity, // FULL WIDTH
                child: ElevatedButton(
                  onPressed: controller.isLoadingVerify.value ? null : controller.verifyEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isLoadingVerify.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Verify Email",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ))),
            ],
          ),
        ),
      ),
    );
  }
}
