import 'package:flutter/material.dart';
import 'package:okto_bloom_florist/Pages/RatingPage.dart';

class RatingAndReviewPage extends StatefulWidget {
  const RatingAndReviewPage({super.key});

  @override
  _RatingAndReviewPageState createState() => _RatingAndReviewPageState();
}

class _RatingAndReviewPageState extends State<RatingAndReviewPage> {
  int _rating = 0; // Track the selected rating
  final TextEditingController _reviewController = TextEditingController(); // Review text input

  // Mock image URLs (Replace with real images or upload functionality)
  final List<String> _imageUrls = [
    'https://via.placeholder.com/100',
    'https://via.placeholder.com/100'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating dan Ulasan'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title for rating section
            const Text(
              'Nilai Produk',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Rating Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),

            // Text Field for Review
            const Text(
              'Bagikan penilaianmu dan bantu pengguna lain membuat pilihan yang baik!',
              style: TextStyle(
                color: Color(0xFF959AA0),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // User review input
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Tulis ulasan Anda...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            const SizedBox(height: 16),

            // Submit button
            ElevatedButton(
              onPressed: () {
                // Navigate to RatingPage with the review data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RatingPage(
                      imageUrls: _imageUrls, // Pass images (mock data)
                      rating: _rating,
                      reviewText: _reviewController.text, product: const {},
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Kirim Ulasan'),
            ),
          ],
        ),
      ),
    );
  }
}

