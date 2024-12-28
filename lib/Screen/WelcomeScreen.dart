import 'package:flutter/material.dart';
import 'package:okto_bloom_florist/Pages/LoginPage.dart';
import 'package:okto_bloom_florist/Pages/RegisterPage.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Logo
              Positioned(
                left: 25,
                top: 20,
                child: Image.asset(
                  'lib/assets/logo.png', // Menggunakan aset lokal
                  width: 99,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              // Deskripsi - posisi sedikit dinaikkan
              const Positioned(
                left: 50,
                right: 50,
                top: 125, // Mengubah posisi top untuk menaikkan deskripsi
                child: Text(
                  'Mari jelajahi berbagai pilihan bunga dan karangan untuk setiap perayaan atau kejutan tak terduga.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.8,
                  ),
                ),
              ),
              // Gambar bunga
              Positioned(
                left: 20,
                right: 20,
                top: 225,
                child: Image.asset(
                  'lib/assets/welcome.png', // Menggunakan aset lokal
                  width: 371,
                  height: 432,
                  fit: BoxFit.cover,
                ),
              ),
              // Tombol Masuk
              Positioned(
                left: 54,
                right: 54,
                top: 655,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-0.1, -1.0),
                      end: Alignment(0.1, 1.0),
                      colors: [Color(0xFFBBAACC), Color(0xFFC40B71)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Arahkan ke halaman LoginPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoginPage()), // Pastikan const digunakan
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor:
                          Colors.transparent, // Transparan untuk gradien
                      shadowColor: Colors.transparent, // Hilangkan bayangan
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              // Tombol Daftar
              Positioned(
                left: 54,
                right: 54,
                top: 720,
                child: OutlinedButton(
                  onPressed: () {
                    // Arahkan ke halaman RegisterPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    side: const BorderSide(color: Colors.black54),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      color: Color(0xFFF698B0),
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Indicator
              Positioned(
                left: 159,
                top: 867,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildIndicator(Colors.grey.shade300),
                    const SizedBox(width: 10),
                    buildIndicator(Colors.grey.shade400),
                    const SizedBox(width: 10),
                    buildIndicator(Colors.grey.shade400),
                    const SizedBox(width: 10),
                    buildIndicator(const Color(0xFFD00178)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(Color color) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
