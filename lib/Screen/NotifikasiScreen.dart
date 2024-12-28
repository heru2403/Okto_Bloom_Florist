import 'package:flutter/material.dart';
import 'package:okto_bloom_florist/Pages/CartPage.dart';  // Ganti dengan path yang sesuai jika perlu
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:okto_bloom_florist/Pages/MainPage.dart'; // Import halaman MainPage

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  _NotifikasiScreenState createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  late Future<List<Notification>> notifications;

  @override
  void initState() {
    super.initState();
    notifications = fetchNotifications();
  }

  Future<List<Notification>> fetchNotifications() async {
    final response = await http.get(Uri.parse('https://payapp.web.id/notifications.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print(data);  // Log data untuk debugging
      return data.map((json) => Notification.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Ketika back button ditekan, arahkan ke MainPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),  // Ganti dengan halaman MainPage Anda
        );
        return false;  // Menghentikan aksi default tombol back
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Notifikasi',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Notification>>(
          future: notifications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada notifikasi tersedia'));
            }

            List<Notification> notifications = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                // Pilih ikon berdasarkan jenis notifikasi
                IconData notificationIcon = Icons.notification_important; // Default icon
                Color iconColor = Colors.blue; // Default color

                // Contoh logika untuk memilih ikon berdasarkan title atau jenis notifikasi
                if (notification.title?.contains('New Product') ?? false) {
                  notificationIcon = Icons.new_releases;
                  iconColor = Colors.green;
                } else if (notification.title?.contains('Holiday Discount') ?? false) {
                  notificationIcon = Icons.discount;
                  iconColor = Colors.red;
                }

                return _buildNotificationItem(
                  context,
                  icon: notificationIcon,
                  iconColor: iconColor,
                  title: notification.title ?? 'No Title',
                  message: notification.message ?? 'Tidak ada pesan',
                  date: notification.createdAt ?? 'Unknown Date',
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context,
      {required IconData icon,
      required Color iconColor,
      required String title,
      required String message,
      required String date}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis, // To ensure the message doesn't overflow
                    maxLines: 2, // Limit the number of lines for message
                  ),
                  const SizedBox(height: 8),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Notification {
  final String? title;
  final String? message;  // Field message sesuai dengan database
  final String? createdAt;

  Notification({
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      title: json['title'],
      message: json['message'],  // Mengambil message dari JSON
      createdAt: json['created_at'],
    );
  }
}
