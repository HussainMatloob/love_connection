import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoaderDialog {
  static void showLoaderDialog({
    required BuildContext context,
    required String lottieFilePath,
    required String description,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Blurred Background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.pink.withOpacity(0.3), // Transparent pink overlay
              ),
            ),
            // Dialog Content
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lottie Animation
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Lottie.asset(lottieFilePath),
                    ),
                    const SizedBox(height: 16),
                    // Description Text
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void hideLoaderDialog(BuildContext context) {
    Navigator.of(context).pop(); // Close the dialog
  }
}
