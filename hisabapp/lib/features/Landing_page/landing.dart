import 'package:flutter/material.dart';
import 'package:hisabapp/core/presentation/theme/app_colors.dart'; 

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top spacing
            const SizedBox(height: 40),
            
            // --- Logo Image Section ---
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo 1: Top logo (jpg)
                  Image.asset(
                    'assets/images/logo2.png',
                    width: 140, 
                    height: 140,
                    fit: BoxFit.contain,
                  ),
                  
                  const SizedBox(height: 8),

                  // Logo 2: Bottom icon (png with white background removed using blend mode)
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.modulate, // Helps filter out the white background
                    ),
                    child: Image.asset(
                      'assets/images/logo1.jpg',
                      width: 110, 
                      height: 110,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // --- Title Section ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Welcome to HisabApp',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMain,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // --- Action Button ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    print('Get Started tapped!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryYellow, 
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      color: AppColors.textMain,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}