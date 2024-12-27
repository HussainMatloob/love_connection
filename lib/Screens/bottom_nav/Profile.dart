import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Widgets/FormWidgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile', style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 22),),
          centerTitle: true,
          // add menu button on action
          actions: [
            IconButton(
              onPressed: () {
                print('Menu Clicked');
                showCustomDialog(context);
              },
              icon: Icon(Icons.menu),
            ),
          ],
        ),
        body: Column(
          children: [
            // Header Section
            Stack(
              children: [
                // Background Image
                Container(
                  width: Get.width,
                  height: Get.height * 0.83,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/PROFILE.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Profile Details
                Positioned(
                  bottom: Get.height * 0.05,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Haider - 27',
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Electrical Engineer, Masters\nEmployed, Lahore',
                        style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: Get.width * 0.1,
                  left: Get.width * 0.1,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.primaryDelta! < -10) {
                        // Trigger the bottom sheet to open on swipe up
                        showBasicInfoBottomSheet(context);
                      }
                    },
                    child: Container(
                      width: Get.width * 0.6,
                      height: Get.height * 0.04,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Line above the text
                          Container(
                            width: 50, // Line width of 50
                            height: 2, // Line thickness
                            color: Colors.black, // Line color
                          ),
                          SizedBox(height: 5),
                          // Space between the line and the text
                          // Text below the line
                          Text(
                            'Basic Info',
                            style: GoogleFonts.outfit(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final overlay = Overlay
        .of(context)
        .context
        .findRenderObject() as RenderBox;
    final position = button.localToGlobal(Offset.zero, ancestor: overlay);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          insetPadding: EdgeInsets.only(top: Get.height * 0.07),
          alignment: Alignment.topRight,
          child: Container(
            width: Get.width * 0.2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    // Adjust size of the circular avatar
                    backgroundColor: Colors.pinkAccent.shade100,
                    // Pink background color
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white, // White icon color for contrast
                    ),
                  ),
                  title:  Text('Saved Profiles', style: GoogleFonts.outfit(fontWeight: FontWeight.w300,fontSize: 12) ,),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16,),
                  onTap: () {
                    // Your action here
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    // Adjust size of the circular avatar
                    backgroundColor: Colors.pinkAccent.shade100,
                    // Pink background color
                    child: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white, // White icon color for contrast
                    ),
                  ),
                  title:  Text('Settings', style: GoogleFonts.outfit(fontWeight: FontWeight.w300,fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16,),
                  onTap: () {
                    // Your action here
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    // Adjust size of the circular avatar
                    backgroundColor: Colors.pinkAccent.shade100,
                    // Pink background color
                    child: const Icon(
                      Icons.share_outlined,
                      color: Colors.white, // White icon color for contrast
                    ),
                  ),
                  title:  Text('Share App', style: GoogleFonts.outfit(fontWeight: FontWeight.w300,fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16,),
                  onTap: () {
                    // Your action here
                  },
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    // Adjust size of the circular avatar
                    backgroundColor: Colors.pinkAccent.shade100,
                    // Pink background color
                    child: const Icon(
                      Icons.logout,
                      color: Colors
                          .white, // White icon color to contrast with the pink background
                    ),
                  ),
                  title:  Text('Logout', style: GoogleFonts.outfit(fontWeight: FontWeight.w300,fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16,),
                  onTap: () {
                    // Your logout logic here
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showBasicInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75, // Adjust height as needed
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Upgrade Button
                  const SizedBox(height: 10),
                  Center(
                    child: InkWell(
                      onTap: () {
                        // Your action here
                        Navigator.pop(context); // Close the bottom sheet
                        FormWidgets().showUpgradeDialog(context);
                      },
                      child: Container(
                        width: Get.width * 0.6,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade600,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text(
                              'Upgrade',
                              style: GoogleFonts.outfit(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              'assets/svg/premium.svg',
                              color: Colors.black,
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Informational Text
                  FormWidgets().buildInfoRow(
                    context,
                    "Boost your profile to the top of search results and get faster,\n handpicked matches tailored to your preferences.",
                  ),
                  const SizedBox(height: 10),
                  FormWidgets().buildInfoRow(
                    context,
                    "Enjoy unlimited messages and see who liked your profile\n to connect with more potential matches.",
                  ),
                  const SizedBox(height: 20),

                  // Basic Information Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                              'Basic Information',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Icon(Icons.edit, color: Colors.pink),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Basic Information Data Rows
                        FormWidgets().buildBasicInfoRow('Name', 'Sara Sara'),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow('Marital Status', 'Single'),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow('Sect', 'Sunni'),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow('Caste', 'Malik'),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow('Height', '5\'6"'),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow('Date of Birth', '01 Jan 1999'),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow('Religion', 'Islam'),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow('Nationality', 'Pakistani'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Education Information Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child:  Text(
                      'Education Information',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        FormWidgets().buildBasicInfoRow('Education', 'Bachelors in Computer Science'),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow('Monthly Income', '\$2000'),
                        const SizedBox(height: 10),
                        FormWidgets().buildBasicInfoRow('Employment Status', 'Employed'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}