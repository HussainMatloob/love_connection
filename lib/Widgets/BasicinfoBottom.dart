import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BasicInfoBottomSheet extends StatelessWidget {
  final Map<String, String> personalInfo;
  final Map<String, String> educationInfo;

  const BasicInfoBottomSheet({
    Key? key,
    required this.personalInfo,
    required this.educationInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Center(
            child: Text(
              'Basic Info',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Personal Section
          Text(
            'Personal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          SizedBox(height: 10),
          _buildInfoRow('Name', personalInfo['name'] ?? '', 'Marital Status', personalInfo['maritalStatus'] ?? ''),
          SizedBox(height: 10),

          _buildInfoRow('Sect', personalInfo['sect'] ?? '', 'Caste', personalInfo['caste'] ?? ''),
          SizedBox(height: 10),

          _buildInfoRow('Height', personalInfo['height'] ?? '', 'Date of Birth', personalInfo['dob'] ?? ''),
          SizedBox(height: 10),

          _buildInfoRow('Religion', personalInfo['religion'] ?? '', 'Nationality', personalInfo['nationality'] ?? ''),
          SizedBox(height: 20),
          // Education and Employment Section
          Text(
            'Education and Employment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          SizedBox(height: 10),
          _buildSingleInfoRow('Education', educationInfo['education'] ?? ''),
          SizedBox(height: 10),

          _buildSingleInfoRow('Monthly Income', educationInfo['monthlyIncome'] ?? ''),
          SizedBox(height: 10),

          _buildSingleInfoRow('Employment Status', educationInfo['employmentStatus'] ?? ''),
          SizedBox(height: 10),

        ],
      ),
    );
  }

  Widget _buildInfoRow(String label1, String value1, String label2, String value2) {
    return Container(
      width: Get.width ,
      height: Get.height * 0.08,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(Get.width * 0.02),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label1, style: TextStyle(color: Colors.grey, fontSize: 16)),
                  SizedBox(height: 5),
                  Text(value1, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(width: Get.width * 0.18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label2, style: TextStyle(color: Colors.grey, fontSize: 16)),
                  SizedBox(height: 5),
                  Text(value2, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleInfoRow(String label, String value) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(Get.width * 0.02),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.grey, fontSize: 16)),
            SizedBox(height: 5),
            Text(value, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
