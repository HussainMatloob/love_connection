import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_connection/Controllers/login_controller.dart';
import 'package:love_connection/Screens/BasicInfoScreens/home.dart';
import 'package:love_connection/Screens/auth/forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final int? keyParam;
  bool _obscureText = true;
  LoginScreen({this.keyParam});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // add image view for logo here
                Image.asset(
                  'assets/images/LClogo2.png',
                  height: 200,
                  color: Colors.pink.shade300,
                ),
                SizedBox(height: 20),
                // Title
                Text(
                  "Love Connection",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade700,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Find your heart's desire.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.pink.shade400,
                  ),
                ),
                SizedBox(height: 40),
                // Email Field
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.pink.shade300),
                    labelText: "Email",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Password Field
                Obx(() => TextField(
                  controller:passwordController,
                  obscureText: controller.isPasswordHidden.value,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.pink.shade300),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.pink.shade300,
                      ),
                      onPressed: () {
                        controller.togglePasswordVisibility();
                      },
                    ),
                    labelText: "Password",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )),

                // add text to forgot password in right side
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(ForgotPasswordScreen());
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.pink.shade400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),
                // Login Button
                Obx(() {
                  return SizedBox(
                    width: Get.width * 0.8,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        backgroundColor: Colors.pink.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                        
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Email and password cannot be empty.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          controller.login(email, password);
                        }
                      },
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(
                        color: Colors.pinkAccent,
                      )
                          : Text(
                        "Login",
                        style: TextStyle(fontSize: 16,color: Colors.white),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 20),
                // Footer Text
                Text(
                  "Made with 💖 for your heart's journey.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.pink.shade400,
                  ),
                ),
                SizedBox(height: 50),
// Footer RichText for user registration
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.pink.shade400),
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black), // Make this part black for contrast
                      ),
                      TextSpan(
                        text: "Register Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade600,
                          decoration: TextDecoration.underline, // Optional: underline the link text
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to the BasicInfoScreen for user registration
                            Get.to(() => Home());
                          },
                      ),
                    ],
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
