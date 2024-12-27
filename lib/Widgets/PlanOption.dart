import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlanOption extends StatefulWidget {
  final String badge;
  final String plan;
  final String price;
  final String perWeek;
  final bool isPopular;
  final int index; // Add index to identify each plan

  PlanOption({
    required this.badge,
    required this.plan,
    required this.price,
    required this.perWeek,
    this.isPopular = false,
    required this.index, // Pass index to the widget
  });

  @override
  _PlanOptionState createState() => _PlanOptionState();
}

class _PlanOptionState extends State<PlanOption> {
  bool isSelected = false; // Track the selection state

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSelected = !isSelected; // Toggle the selected state on tap
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.isPopular
                ? Colors.transparent
                : Colors.black.withOpacity(0.1), // Transparent background for non-popular cards
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.yellow : (widget.isPopular ? Colors.yellow : Colors.grey), // Change border to yellow when selected
              width: 2, // Set border width
            ),
          ),
          child: Column(
            children: [
              if (widget.badge.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade700, // Yellow background for Save option
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.yellow), // Yellow border
                  ),
                  child: Text(
                    widget.badge,
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const SizedBox(height: 5),
              Text(
                widget.plan,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.price,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.perWeek,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight:FontWeight.w400
                ),
              ),
              if (widget.isPopular) const SizedBox(height: 10),
              if (widget.isPopular)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child:  Text(
                      "POPULAR",
                      style: GoogleFonts.roboto(
                        color: Colors.yellow,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}