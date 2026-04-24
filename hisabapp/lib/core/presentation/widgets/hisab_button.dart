import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HisabButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final bool showPlusIcon;

  const HisabButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 251,
    this.height = 54,
    this.backgroundColor = AppColors.primaryYellow,
    this.textColor = AppColors.textMain,
    this.showPlusIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showPlusIcon) ...[
              Icon(
                Icons.add, 
                size: 28, 
                color: textColor,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- TESTING BLOCK ---
// This now only shows the "Add Cost" version as you requested
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true), 
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: HisabButton(
            text: "Add Cost",
            onPressed: () => print("Add Cost Clicked!"),
          ),
        ),
      ),
    ),
  );
}