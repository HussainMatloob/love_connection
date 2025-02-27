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
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.lock_reset, size: 100, color: Colors.pinkAccent),
              SizedBox(height: 20),
              Text(
                "Reset Your Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Enter your email to verify your account and reset your password.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Email Input
              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  prefixIcon: Icon(Icons.email, color: Colors.pink),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),

              // Show Password Field & Update Button After Email Verification
              Obx(() => controller.isEmailVerified.value
                  ? Column(
                children: [
                  // Password Input with Toggle
                  Obx(() => TextField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      prefixIcon: Icon(Icons.lock, color: Colors.pink),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility,
                          color: Colors.pink,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: controller.validatePassword,
                  )),
                  SizedBox(height: 10),

                  // Password Strength Message
                  Obx(() => controller.passwordErrorMessage.value.isNotEmpty
                      ? Text(
                    controller.passwordErrorMessage.value,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  )
                      : SizedBox()),

                  SizedBox(height: 20),

                  // Update Password Button (Only visible after email verification)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoadingUpdate.value ? null : controller.updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: controller.isLoadingUpdate.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Update Password", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              )
                  : Column(
                children: [
                  // Verify Email Button (Hidden after verification)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoadingVerify.value ? null : controller.verifyEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: controller.isLoadingVerify.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Verify Email", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
