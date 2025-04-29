import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
      height: 537.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Center(
              child: Text(
                'Basic Info',
                style: GoogleFonts.outfit(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Personal Section
            Text(
              'Personal',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.pink,
              ),
            ),
            SizedBox(height: 10.h),
            _buildInfoRow('Name', personalInfo['name'] ?? '', 'Marital Status',
                personalInfo['maritalStatus'] ?? ''),
            SizedBox(height: 10.h),

            _buildInfoRow('Sect', personalInfo['sect'] ?? '', 'Caste',
                personalInfo['caste'] ?? ''),
            SizedBox(height: 10.h),

            _buildInfoRow('Height', personalInfo['height'] ?? '',
                'Date of Birth', personalInfo['dob'] ?? ''),
            SizedBox(height: 10.h),

            _buildInfoRow('Religion', personalInfo['religion'] ?? '',
                'Nationality', personalInfo['nationality'] ?? ''),
            SizedBox(height: 20.h),
            // Education and Employment Section
            Text(
              'Education and Employment',
              style: GoogleFonts.outfit(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: Colors.pink,
              ),
            ),
            SizedBox(height: 10.h),
            _buildSingleInfoRow('Education', educationInfo['education'] ?? ''),
            SizedBox(height: 10.h),

            _buildSingleInfoRow(
                'Monthly Income', educationInfo['monthlyIncome'] ?? ''),
            SizedBox(height: 10.h),

            _buildSingleInfoRow(
                'Employment Status', educationInfo['employmentStatus'] ?? ''),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  String formatDate(String dob) {
    // Parse the original date string
    DateTime parsedDate = DateTime.parse(dob);

    // Format the date to the desired format
    String formattedDate = DateFormat('MMMM d, yyyy').format(parsedDate);

    return formattedDate;
  }

  Widget _buildInfoRow(
      String label1, String value1, String label2, String value2) {
    return Container(
      padding: EdgeInsets.all(8.r),
      // Responsive height
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r), // Responsive border radius
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 16.w, vertical: 8.h), // Responsive padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label1,
                    style: GoogleFonts.outfit(
                      color: Colors.grey,
                      fontSize: 14.sp, // Responsive font size
                    ),
                  ),
                  SizedBox(height: 4.h), // Responsive spacing
                  Text(
                    value1,
                    style: GoogleFonts.outfit(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.w), // Responsive spacing between columns
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label2,
                    style: GoogleFonts.outfit(
                      color: Colors.grey,
                      fontSize: 14.sp, // Responsive font size
                    ),
                  ),
                  SizedBox(height: 4.h), // Responsive spacing
                  Text(
                    value2,
                    style: GoogleFonts.outfit(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
            Text(label,
                style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16)),
            SizedBox(height: 5.h),
            Text(value,
                style: GoogleFonts.outfit(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
