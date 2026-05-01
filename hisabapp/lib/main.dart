import 'package:flutter/material.dart';
// Make sure to import your WelcomeScreen file correctly based on its location
import 'features/Landing_page/landing.dart'; 

void main() {
  runApp(const HisabApp());
}

class HisabApp extends StatelessWidget {
  const HisabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HisabApp',
      debugShowCheckedModeBanner: false, // Hides the debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter', // Optional: Use your design font family here
      ),
      // This tells Flutter to show your WelcomeScreen first
      home: const WelcomeScreen(), 
    );
  }
}