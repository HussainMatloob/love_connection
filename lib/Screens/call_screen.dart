import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:love_connection/Screens/empty_screen_message.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CutomEmptyScreenMessage(
              icon: Icon(
                Icons.build_circle_outlined, // 👈 or use Icons.call_outlined
                size: 80.sp,
                color: Colors.grey,
              ),
              headText: "Call Screen Under Development",
              subtext:
                  "This feature is currently being developed.\nPlease check back soon!",
            ),
          ],
        ),
      ),
    );
  }
}
