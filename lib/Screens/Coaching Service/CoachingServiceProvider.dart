import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CoachingServiceProviderScreen extends StatefulWidget {
  @override
  _CoachingServiceProviderScreenState createState() =>
      _CoachingServiceProviderScreenState();
}

class _CoachingServiceProviderScreenState
    extends State<CoachingServiceProviderScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? profileImage;

  // Controllers for form fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  String gender = "Male"; // Default selection
  String modeOfCoaching = "Online"; // Default mode of coaching

  // Function to pick an image
  Future<void> pickProfileImage() async {
    final selectedImage =
    await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      profileImage = selectedImage;
    });
  }

  // UI Design for Coaching Service Providers
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Coaching Service Provider"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Information Section
            Text(
              "Personal Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: "First Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: "Last Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Gender Selection Dropdown
            DropdownButtonFormField<String>(
              value: gender,
              items: ["Male", "Female", "Other"]
                  .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Professional Information Section
            Text(
              "Professional Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: specializationController,
              decoration: InputDecoration(
                labelText: "Specialization",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: experienceController,
              decoration: InputDecoration(
                labelText: "Years of Experience",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Mode of Coaching Selection
            DropdownButtonFormField<String>(
              value: modeOfCoaching,
              items: ["Online", "Physical"]
                  .map((mode) => DropdownMenuItem(
                value: mode,
                child: Text(mode),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  modeOfCoaching = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Preferred Mode of Coaching",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Document Upload Section
            Text(
              "Upload Profile Image",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: pickProfileImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: profileImage == null
                    ? Center(
                  child: Text("Tap to upload profile image"),
                )
                    : Image.file(
                  File(profileImage!.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Submit form logic here
                if (firstNameController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    specializationController.text.isEmpty) {
                  Get.snackbar("Error", "Please fill all required fields");
                } else {
                  Get.snackbar("Success", "Data submitted successfully!");
                  // Navigate to appropriate screen
                }
              },
              child: const Text("Submit"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
