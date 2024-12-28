import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddToCartPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const AddToCartPage({
    super.key,
    required this.product,
  });

  @override
  _AddToCartPageState createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  String? _selectedColor;
  int _quantity = 1;
  final String apiUrl =
      'https://payapp.web.id/cart.php'; // Update with your API URL

  // Daftar warna dasar yang sering digunakan untuk florist
  final List<Color> _floristColors = [
    Colors.red, // Merah
    Colors.pink, // Pink
    Colors.yellow, // Kuning
    Colors.orange, // Oranye
    Colors.white, // Putih
    Colors.purple, // Ungu
  ];

  // Mapping warna ke nama atau kode hexadecimal
  final Map<Color, String> _colorMap = {
    Colors.red: 'red', // Nama warna
    Colors.pink: 'pink',
    Colors.yellow: 'yellow',
    Colors.orange: 'orange',
    Colors.white: 'white',
    Colors.purple: 'purple',
  };

  // Fungsi untuk menambahkan ke keranjang dengan API
  Future<void> _addToCart() async {
    if (_selectedColor == null) {
      // Show an error if color is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih warna produk terlebih dahulu.')),
      );
      return;
    }

    // Set up the request body
    final Map<String, dynamic> requestBody = {
      'user_id': 1, // Replace with the actual user_id
      'product_id': widget.product['id'],
      'quantity': _quantity,
      'color': _selectedColor, // Menyimpan nama warna atau kode hex
    };

    try {
      // Send POST request to the API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Produk berhasil ditambahkan ke keranjang')),
          );
        } else {
          // Handle error (API failure)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Error')),
          );
        }
      } else {
        // Handle server error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghubungi server')),
        );
      }
    } catch (error) {
      // Handle connection or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan, coba lagi')),
      );
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
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Nama produk di atas gambar utama
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product['name'] ?? 'Produk Tidak Diketahui',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Gambar utama di luar CardView
            Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: widget.product['image_url'] != null
                        ? Image.network(
                            widget.product['image_url'],
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image_not_supported, size: 100),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar di dalam CardView di kiri atas
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: widget.product['image_url'] != null
                                    ? Image.network(
                                        widget.product['image_url'],
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.image_not_supported,
                                        size: 50),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rp ${widget.product['price'] ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Stok: ${widget.product['stock'] ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "COLOR",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    // Loop untuk menampilkan pilihan warna
                                    for (var color in _floristColors)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // Simpan nama warna menggunakan map
                                            _selectedColor = _colorMap[color];
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color,
                                            border: Border.all(
                                              color: _selectedColor ==
                                                      _colorMap[color]
                                                  ? Colors.black
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Pilihan Jumlah di bawah gambar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Jumlah",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (_quantity > 1) _quantity--;
                                    });
                                  },
                                ),
                                Text(
                                  '$_quantity',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      _quantity++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Tombol Add to Cart
                        GestureDetector(
                          onTap: _addToCart,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF698B0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Add to cart',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.shopping_bag, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


