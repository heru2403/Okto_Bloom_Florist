import 'package:flutter/material.dart';
import 'package:okto_bloom_florist/Screen/onboarding_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Set SplashScreen as the initial screen
    );
  }
}

// SplashScreen
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menambahkan Future.delayed untuk menunggu 3 detik sebelum navigasi
    Future.delayed(const Duration(seconds: 3), () {
      print('Splash screen selesai, pindah ke OnboardingScreen');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const OnboardingScreen()), // Navigate to OnboardingScreen after the delay
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'lib/assets/logo.png', // Make sure the logo path is correct
        ),
      ),
    );
  }
}
