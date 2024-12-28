import 'package:flutter/material.dart';
import 'package:okto_bloom_florist/Screen/WelcomeScreen.dart';
 // Import the WelcomeScreen

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0; // Current page tracker
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index; // Update page index
                  });
                  // Navigate to WelcomeScreen when the last slide (3rd slide) is reached
                  if (index == 2) {
                    Future.delayed(const Duration(milliseconds: 3000), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomeScreen()),
                      );
                    });
                  }
                },
                children: [
                  // First Onboarding Page
                  _buildOnboardingPage(
                    "lib/assets/onboard1.png", // First image path
                    'Temukan karangan bunga terbaik untuk setiap momen spesial Anda.',
                  ),
                  // Second Onboarding Page
                  _buildOnboardingPage(
                    "lib/assets/onboard2.png", // Second image path
                    'Pilih dari koleksi bunga segar dan rangkaian indah yang dirancang untuk mengungkapkan perasaan Anda.',
                  ),
                  // Third Onboarding Page
                  _buildOnboardingPage(
                    "lib/assets/onboard3.png", // Third image path
                    'Dengan Okto Bloom Florist, kemudahan memesan bunga hanya sejauh satu ketukan.',
                  ),
                ],
              ),
            ),
            // Dots Indicator and navigation
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  // Changed from 4 to 3
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to respective page when a dot is tapped
                        _pageController.jumpToPage(index);
                      },
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFFD00178) // Active dot color
                              : const Color(0xFFD5D5D5), // Inactive dot color
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build the onboarding page widget
  Widget _buildOnboardingPage(String imagePath, String text) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        // Gradient Overlay
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 310,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.white],
              ),
            ),
          ),
        ),
        // Text Content - Centered
        Positioned(
          top: 150,
          left: 20,
          right: 20,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
