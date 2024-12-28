import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: const Color.fromARGB(255, 255, 178, 204),
      ),
      body: FutureBuilder(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading orders"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders found"));
          } else {
            final orders = snapshot.data as List<Order>;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text(order.productName),
                  subtitle: Text('Status: ${order.status}'),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Order>> _fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final orderData = prefs.getStringList('orders');

    if (orderData != null) {
      return orderData.map((e) => Order.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}

class Order {
  final String productName;
  final String status;

  Order({required this.productName, required this.status});

  factory Order.fromJson(String jsonString) {
    final data = jsonDecode(jsonString);
    return Order(
      productName: data['productName'],
      status: data['status'],
    );
  }
}
