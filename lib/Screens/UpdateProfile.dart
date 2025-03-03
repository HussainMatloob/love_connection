import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Controllers/update_profile_controller.dart';

class UpdateProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildProfileImage()),
            SizedBox(height: 20),
            _buildTextField("First Name", controller.controllers['firstname']!, Icons.person),
            _buildTextField("Last Name", controller.controllers['lastname']!, Icons.person_outline),
            _buildTextField("Email", controller.controllers['email']!, Icons.email),
            _buildTextField("Password", controller.controllers['password']!, Icons.lock, obscureText: true),
            SizedBox(height: 10),
            _buildRowFields("City", controller.controllers['city']!, Icons.location_city, "City Looking For", controller.controllers['citylookingfor']!, Icons.search),
            _buildRowFields("Country", controller.controllers['country']!, Icons.flag, "Country Looking For", controller.controllers['countrylookingfor']!, Icons.public),
            _buildRowFields("Religion", controller.controllers['religion']!, Icons.book, "Religion Looking For", controller.controllers['religionlookingfor']!, Icons.search),
            _buildRowFields("Education", controller.controllers['education']!, Icons.school, "Education Looking For", controller.controllers['educationlookingfor']!, Icons.search),
            SizedBox(height: 20),
            Text("Upload CNIC Documents", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildImagePicker('cnic_front')),
                SizedBox(width: 10),
                Expanded(child: _buildImagePicker('cnic_back')),
              ],
            ),
            SizedBox(height: 20),
            Text("Upload Passport Documents", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildImagePicker('passport_front')),
                SizedBox(width: 10),
                Expanded(child: _buildImagePicker('passport_back')),
              ],
            ),
            SizedBox(height: 20),
            Text("Selfie Verification", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink)),
            SizedBox(height: 10),
            _buildSelfiePicker('selfieimage'),
            SizedBox(height: 20),
            Center(
              child: Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: controller.updateUserProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                ),
                child: Text("Update Profile", style: TextStyle(fontSize: 16, color: Colors.white)),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () => controller.pickImage(ImageSource.gallery, 'profileimage'),
      child: Obx(() => CircleAvatar(
        radius: 60,
        backgroundColor: Colors.blueGrey[100],
        backgroundImage: controller.imageFiles['profileimage']?.value != null
            ? FileImage(controller.imageFiles['profileimage']!.value!)
            : null,
        child: controller.imageFiles['profileimage']?.value == null
            ? Icon(Icons.camera_alt, size: 40, color: Colors.grey[600])
            : null,
      )),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.pink),
          filled: true,
          fillColor: Colors.blueGrey[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildRowFields(String hint1, TextEditingController controller1, IconData icon1, String hint2, TextEditingController controller2, IconData icon2) {
    return Row(
      children: [
        Expanded(child: _buildTextField(hint1, controller1, icon1)),
        SizedBox(width: 10),
        Expanded(child: _buildTextField(hint2, controller2, icon2)),
      ],
    );
  }

  Widget _buildImagePicker(String field) {
    return GestureDetector(
      onTap: () => controller.pickImage(ImageSource.gallery, field),
      child: Obx(() => Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: controller.imageFiles[field]?.value != null ? Colors.grey[300] : Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.pink, width: 2),
        ),
        child: controller.imageFiles[field]?.value != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(controller.imageFiles[field]!.value!, fit: BoxFit.cover),
        )
            : Center(child: Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey[600])),
      )),
    );
  }

  Widget _buildSelfiePicker(String field) {
    return GestureDetector(
      onTap: () => controller.pickImage(ImageSource.camera, field),
      child: Obx(() => Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: controller.imageFiles[field]?.value != null ? Colors.grey[300] : Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.pink, width: 2),
        ),
        child: controller.imageFiles[field]?.value != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(controller.imageFiles[field]!.value!, fit: BoxFit.cover),
        )
            : Center(child: Icon(Icons.camera_alt, size: 50, color: Colors.grey[600])),
      )),
    );
  }
}
