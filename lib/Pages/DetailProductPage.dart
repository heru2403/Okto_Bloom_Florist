import 'dart:math';
import 'package:flutter/material.dart';
import 'package:okto_bloom_florist/Pages/AddToCartPage.dart';
import 'package:okto_bloom_florist/Pages/CartPage.dart';
import 'package:okto_bloom_florist/Pages/RatingPage.dart'; // Impor halaman rating dan ulasan

class DetailProductPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const DetailProductPage({
    super.key,
    required this.product, required String productName, required String productImage, required String productPrice, required String productColor,
  });

  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  final int _selectedIndex = 0;
  String? _selectedColor;

  // Menambahkan fungsi untuk menghasilkan warna acak
  Color _getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256), // R
      random.nextInt(256), // G
      random.nextInt(256), // B
      1.0, // Opacity
    );
  }

  // Parsing warna dan memberikan warna acak jika tidak valid
  Color _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return _getRandomColor();
    }
    try {
      return Color(int.parse(colorString, radix: 16)).withOpacity(1.0);
    } catch (e) {
      return _getRandomColor();
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartPage()),
      );
    }
  }

  void _onPopupMenuSelected(String value) {
    switch (value) {
      case 'Share':
        break;
      case 'View Cart':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartPage()),
        );
        break;
      case 'Settings':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: _onPopupMenuSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Share', child: Text('Share')),
              const PopupMenuItem(value: 'View Cart', child: Text('View Cart')),
              const PopupMenuItem(value: 'Settings', child: Text('Settings')),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.product['name'] ?? 'Nama Produk',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: widget.product['image_url'] != null
                          ? Image.network(
                              widget.product['image_url'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported,
                                      size: 100),
                            )
                          : const Icon(Icons.image_not_supported, size: 100),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PRICE',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp ${widget.product['price'] ?? 0}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "COLOR",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            for (var color in widget.product['colors'] ??
                                ['#ff0000', '#00ff00', '#0000ff', '#ffa500'])
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = color;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _parseColor(color),
                                    border: Border.all(
                                      color: _selectedColor == color
                                          ? Colors.black
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddToCartPage(product: widget.product),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF698B0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Beli dengan Harga\nRp ${widget.product['price']}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RatingPage(
                          imageUrls: [widget.product['image_url']], rating: 5, reviewText: '', product: const {}, // Pass product images
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Penilaian dan Ulasan Produk (205)',
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
        ],
      ),
    );
  }
}

