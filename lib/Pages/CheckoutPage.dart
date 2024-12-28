import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:okto_bloom_florist/Pages/AddressSettingPage.dart';
import 'package:intl/intl.dart';  // Import intl untuk format angka
import 'package:okto_bloom_florist/Pages/profile_page.dart';  // Import ProfilePage

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  final Map<String, dynamic> selectedAddress;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.selectedAddress,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Map<String, dynamic> selectedAddress;
  String selectedShippingOption = 'Standard'; // Default shipping option
  String selectedPaymentMethod = 'COD'; // Default payment method

  @override
  void initState() {
    super.initState();
    selectedAddress = widget.selectedAddress;
  }

  // Fungsi untuk memformat angka sebagai mata uang dengan pemisah ribuan
  String formatCurrency(int amount) {
    final formatter = NumberFormat("#,##0", "id_ID"); // Format Indonesia
    return formatter.format(amount);
  }

  void placeOrder() async {
    if (selectedAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a shipping address.')),
      );
      return;
    }

    final url = Uri.parse('https://payapp.web.id/checkout.php');

    // Persiapkan data untuk API
    final orderData = {
      'address': selectedAddress,
      'cartItems': widget.cartItems,
      'totalPrice': widget.totalPrice +
          (selectedShippingOption == 'Standard' ? 10000 : 20000),
      'shippingOption': selectedShippingOption,
      'paymentMethod': selectedPaymentMethod,
      'message': 'Pesanan dari aplikasi Okto Bloom',
    };

    try {
      // Lakukan POST request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          // Tampilkan dialog konfirmasi jika berhasil
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Order Confirmation'),
              content: Text(
                  'Your order has been placed successfully! Order ID: ${responseData['orderId']}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                      (route) => false, // Hapus semua rute sebelumnya
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Tampilkan pesan error jika gagal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Order failed')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to connect to the server.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 175, 244),
        elevation: 1,
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/bg.png'), // Latar belakang
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Alamat Pengiriman
              Row(
                children: [
                  const Icon(Icons.location_pin, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${selectedAddress['name'] ?? 'Nama Tidak Tersedia'} (${selectedAddress['phone'] ?? 'Nomor Tidak Tersedia'})',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedAddress['address'] ?? 'Alamat Tidak Tersedia',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final updatedAddress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddressSettingPage(),
                        ),
                      );
                      if (updatedAddress != null) {
                        setState(() {
                          selectedAddress = updatedAddress;
                        });
                      }
                    },
                  ),
                ],
              ),
              const Divider(height: 24),

              // Daftar Produk
              Expanded(
                child: ListView.builder(
                  itemCount: widget.cartItems.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = widget.cartItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                            ),
                            child: Image.network(
                              item['image_url'] ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(item['name'] ?? 'Produk'),
                          subtitle: Text(
                              'Variation: ${item['color'] ?? 'No color'}\nQuantity: ${item['quantity'] ?? 0}'),
                          trailing: Text('Rp ${formatCurrency(item['price'] ?? 0)}'),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 16),

              // Opsi Pengiriman
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Shipping Options'),
                  DropdownButton<String>(
                    value: selectedShippingOption,
                    items: const [
                      DropdownMenuItem(
                        value: 'Standard',
                        child: Text('Standard (Rp 5.000)'),
                      ),
                      DropdownMenuItem(
                        value: 'Express',
                        child: Text('Express (Rp 10.000)'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedShippingOption = value!;
                      });
                    },
                  ),
                ],
              ),
              const Divider(height: 16),

              // Metode Pembayaran
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Payment Method'),
                  DropdownButton<String>(
                    value: selectedPaymentMethod,
                    items: const [
                      DropdownMenuItem(
                        value: 'COD',
                        child: Text('COD'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                ],
              ),
              const Divider(height: 16),

              // Rincian Harga
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal:', style: TextStyle(fontSize: 16)),
                  Text(
                    'Rp ${formatCurrency(widget.totalPrice.toInt())}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Shipping Cost:', style: TextStyle(fontSize: 16)),
                  Text(
                    'Rp ${formatCurrency(selectedShippingOption == 'Standard' ? 5000 : 10000)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Order:', style: TextStyle(fontSize: 16)),
                  Text(
                    'Rp ${formatCurrency((widget.totalPrice + (selectedShippingOption == 'Standard' ? 5000 : 10000)).toInt())}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tombol Order Sekarang
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[200],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Order Now',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
