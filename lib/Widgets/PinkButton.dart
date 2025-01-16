import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PinkButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const PinkButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8), // Padding for consistency
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.pink[400], // Button color
            borderRadius: BorderRadius.circular(40), // Rounded corners
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.outfit(
              color: Colors.white, // White text color
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
