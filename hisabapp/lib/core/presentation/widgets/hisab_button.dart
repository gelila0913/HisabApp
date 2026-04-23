import 'package:flutter/material.dart';
import '../theme/app_color.dart';

class HisabButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;          // Parameter for Width
  final double height;         // Parameter for Height
  final Color backgroundColor; // Parameter for Color
  final Color textColor;       // Parameter for Text Color

  const HisabButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 251,                  // Default Figma Width
    this.height = 54,                 // Default Figma Height
    this.backgroundColor = AppColor.primaryYellow, // Default Color
    this.textColor = AppColor.black,   // Default Text Color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,   // Uses the width parameter
      height: height, // Uses the height parameter
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}