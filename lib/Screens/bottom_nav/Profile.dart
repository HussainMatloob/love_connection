import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Widgets/BasicinfoBottom.dart';

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
          title: Text('Profile'),
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Electrical Engineer, Masters\nEmployed, Lahore',
                        style: TextStyle(color: Colors.white, fontSize: 14),
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
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                  title: const Text('Saved Profiles'),
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
                  title: const Text('Settings'),
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
                  title: const Text('Share App'),
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
                  title: const Text('Logout'),
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
      isScrollControlled: true, // Allows the bottom sheet to expand fully
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
          child: Column(
              children: [
                Center(
                  child: Container(
                    width: Get.width * 0.75,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade700,
                      borderRadius: BorderRadius.circular(18 ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Upgrade',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SvgPicture.asset(
                          'assets/svg/premium.svg',
                          color: Colors.black,
                          width: 20,
                          height: 20,

                        ),
                      ],
                    ),
                  ),
                  ),
                const SizedBox(height: 20),

                // Informational Text
                const Text(
                  '• Boost your profile to the top of search results and get faster, handpicked matches tailored to your preferences.', style: TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                const Text(
                  '• Enjoy unlimited messages and see who liked your profile to connect with more potential matches.', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),

                // Basic Information Header
                Container(
                  width: Get.width,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.grey ,

                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Basic Information',
                          style: TextStyle(
                               fontSize: 24),
                        ),
                        Icon(Icons.edit, color: Colors.pink),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Basic Information Data
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                  },
                  children: const [
                    TableRow(
                      children: [
                        Text('Name', style: TextStyle(color: Colors.grey)),
                        Text('Marital Status',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Sara Sara',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Single',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    TableRow(
                      children: [
                        SizedBox(height: 10), // Spacer
                        SizedBox(height: 10), // Spacer
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Sect', style: TextStyle(color: Colors.grey)),
                        Text('Caste', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Sunni',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Malik',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    TableRow(
                      children: [
                        SizedBox(height: 10), // Spacer
                        SizedBox(height: 10), // Spacer
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Height', style: TextStyle(color: Colors.grey)),
                        Text('Date of Birth',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('5\'6"',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('01 Jan 1999',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    TableRow(
                      children: [
                        SizedBox(height: 10), // Spacer
                        SizedBox(height: 10), // Spacer
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Religion', style: TextStyle(color: Colors.grey)),
                        Text('Nationality',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Islam',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Pakistani',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Education Information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                  },
                  children: const [
                    TableRow(
                      children: [
                        Text('Education', style: TextStyle(color: Colors.grey)),
                        Text('Monthly Income',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Bachelors in Computer Science',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('\$2000',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    TableRow(
                      children: [
                        SizedBox(height: 10), // Spacer
                        SizedBox(height: 10), // Spacer
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Employment Status',
                            style: TextStyle(color: Colors.grey)),
                        Text('', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Employed',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ]),
        );
      },
    );
  }
}