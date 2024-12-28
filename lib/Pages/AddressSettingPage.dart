import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddressSettingPage extends StatefulWidget {
  const AddressSettingPage({super.key});

  @override
  State<AddressSettingPage> createState() => _AddressSettingPageState();
}

class _AddressSettingPageState extends State<AddressSettingPage> {
  List<Map<String, dynamic>> addresses = [];
  int? selectedAddressId; // Selected address ID
  final apiUrl = 'https://payapp.web.id/address.php';

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  // Fetch addresses from API
  Future<void> _fetchAddresses() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List) {
          setState(() {
            addresses = responseData.map((address) {
              return {
                'id': int.tryParse(address['id'].toString()) ?? 0, // Ensure 'id' is an integer
                'name': address['name'],
                'phone': address['phone'],
                'address': address['address'],
              };
            }).toList();
          });
        }
      } else {
        print("Failed to fetch addresses: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching addresses: $e");
    }
  }

  // Display dialog for adding/editing address
  void _showAddressDialog({int? id, String? name, String? phone, String? address}) {
    final nameController = TextEditingController(text: name);
    final phoneController = TextEditingController(text: phone);
    final addressController = TextEditingController(text: address);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(id == null ? 'Add New Address' : 'Edit Address'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (id == null) {
                  _addAddressToApi(
                    nameController.text,
                    phoneController.text,
                    addressController.text,
                  );
                } else {
                  _editAddress(
                    id,
                    nameController.text,
                    phoneController.text,
                    addressController.text,
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Add new address to API
  Future<void> _addAddressToApi(String name, String phone, String address) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'phone': phone,
          'address': address,
        }),
      );

      if (response.statusCode == 200) {
        _fetchAddresses(); // Reload address list
      } else {
        print("Failed to add address: ${response.statusCode}");
      }
    } catch (e) {
      print("Error adding address: $e");
    }
  }

  // Edit existing address
  Future<void> _editAddress(int id, String name, String phone, String address) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl?id=$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'phone': phone,
          'address': address,
        }),
      );

      if (response.statusCode == 200) {
        _fetchAddresses(); // Reload address list
      } else {
        print("Failed to edit address: ${response.statusCode}");
      }
    } catch (e) {
      print("Error editing address: $e");
    }
  }

  // Delete address
  Future<void> _deleteAddress(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl?id=$id'));
      if (response.statusCode == 200) {
        _fetchAddresses(); // Reload address list
      } else {
        print("Failed to delete address: ${response.statusCode}");
      }
    } catch (e) {
      print("Error deleting address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Addresses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Address List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return AddressCard(
                    name: address['name']! ?? 'Name Not Available',
                    phone: address['phone']! ?? 'Phone Not Available',
                    address: address['address']! ?? 'Address Not Available',
                    isSelected: selectedAddressId == address['id'],
                    onEdit: () {
                      _showAddressDialog(
                        id: address['id'],
                        name: address['name'],
                        phone: address['phone'],
                        address: address['address'],
                      );
                    },
                    onDelete: () {
                      _deleteAddress(address['id']);
                    },
                    onSelect: () {
                      setState(() {
                        selectedAddressId = address['id'];
                      });
                      Navigator.pop(context, address);  // Return selected address to CheckoutPage
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showAddressDialog(),
              child: const Text('Add New Address'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final bool isSelected;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSelect;

  const AddressCard({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    required this.isSelected,
    required this.onEdit,
    required this.onDelete,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onSelect, // Select address when clicked
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(phone),
                    const SizedBox(height: 4),
                    Text(address),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
