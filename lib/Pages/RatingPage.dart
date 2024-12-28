import 'package:flutter/material.dart';

class RatingPage extends StatelessWidget {
  final List<String> imageUrls; // Image URLs passed from RatingAndReviewPage
  final int rating; // Rating passed from RatingAndReviewPage
  final String reviewText; // Review text passed from RatingAndReviewPage

  const RatingPage({
    Key? key,
    required this.imageUrls,
    required this.rating,
    required this.reviewText, required Map<String, dynamic> product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 169, 245),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ulasan Produk',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildReview(
            username: 'd889putri',
            rating: rating,
            comment: reviewText,
            variant: 'Pink,merah',
            aesthetics: 'Bagus',
            freshness: 'okee',
            imageUrls: imageUrls,
          ),
        ],
      ),
    );
  }

  Widget _buildReview({
    required String username,
    required int rating,
    required String comment,
    required String variant,
    required String aesthetics,
    required String freshness,
    required List<String> imageUrls,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                    size: 20,
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                'Varian: $variant',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                'Estetika: $aesthetics',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                'Kesegaran: $freshness',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(
                comment,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: imageUrls
                    .map((url) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              url,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
