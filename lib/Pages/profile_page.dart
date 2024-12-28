import 'package:flutter/material.dart';
import 'package:okto_bloom_florist/Pages/AddressSettingPage.dart';
import 'package:okto_bloom_florist/Pages/EditProfilePage.dart';
import 'package:okto_bloom_florist/Pages/LoginPage.dart';
import 'package:okto_bloom_florist/Pages/RatingAndReviewPage.dart';
import 'package:okto_bloom_florist/Pages/SectionTitle.dart,%20OrderStatusCard.dart,%20MenuItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; // Import Clipboard package

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  // Function to launch WhatsApp Web
  Future<void> _launchWhatsAppWeb(BuildContext context) async {
    const phoneNumber = '6282288978691'; // Replace with admin's WhatsApp number
    const message = 'Halo admin, saya membutuhkan bantuan.'; // Default message

    final whatsappWebUrl = Uri.parse(
        'https://api.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}');

    try {
      if (await canLaunchUrl(whatsappWebUrl)) {
        await launchUrl(whatsappWebUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not open WhatsApp Web';
      }
    } catch (e) {
      print('Error: $e');
      _showFallbackDialog(context);
    }
  }

  // Show fallback dialog with alternative contact method
  void _showFallbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Admin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Unable to open WhatsApp. Please contact us at: 0822-8897-8691'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: 'https://api.whatsapp.com/send?phone=6282288978691'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Number copied to clipboard')),
                  );
                },
                child: const Text('Copy Number'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 69, 131),
      ),
      body: ListView(
        children: [
          // Profile Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 108, 184),
                  Color.fromARGB(255, 255, 82, 139)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: const AssetImage('lib/assets/profile.png'),
                  backgroundColor: Colors.pink.shade50,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "OKTO BLOOM",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditProfilePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor:
                              const Color.fromARGB(255, 255, 92, 192),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text("Edit Profile"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OrderStatusCard(
                  label: "Packed",
                  icon: Icons.local_shipping,
                  color: Colors.orange,
                  onTap: () {},
                ),
                OrderStatusCard(
                  label: "Shipped",
                  icon: Icons.airplanemode_active,
                  color: Colors.blue,
                  onTap: () {},
                ),
                OrderStatusCard(
                  label: "Delivered",
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                  onTap: () {},
                ),
                OrderStatusCard(
                  label: "Reviews",
                  icon: Icons.star_rate,
                  color: const Color.fromARGB(255, 255, 50, 207),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RatingAndReviewPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(thickness: 10, color: Colors.grey),
          MenuItem(
            icon: Icons.location_on,
            title: "Shipping Address",
            iconColor: const Color.fromARGB(255, 255, 153, 187),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddressSettingPage()),
              );
            },
          ),
          const Divider(),
          MenuItem(
            icon: Icons.chat,
            title: "Contact Admin via WhatsApp",
            iconColor: const Color.fromARGB(255, 102, 204, 255),
            onTap: () => _launchWhatsAppWeb(context),
          ),
          const Divider(),
          MenuItem(
            icon: Icons.logout,
            title: "Logout",
            iconColor: const Color.fromARGB(255, 255, 136, 217),
            textColor: const Color.fromARGB(255, 255, 153, 219),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('user_token'); // Remove token
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
