import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:love_connection/Screens/empty_screen_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
                Icons
                    .message_outlined, // You can also try Icons.chat_bubble_outline
                size: 80.sp,
                color: Colors.grey,
              ),
              headText: "Messages Screen Under Development",
              subtext: "Messaging feature is coming soon.\nStay tuned!",
            ),
          ],
        ),
      ),
    );
  }
}
