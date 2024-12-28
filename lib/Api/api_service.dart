import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://payapp.web.id/products.php";

  // Ambil semua produk berdasarkan pencarian
  Future<List<dynamic>> fetchProducts(String searchQuery) async {
    try {
      final url = Uri.parse('$baseUrl?search=$searchQuery');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success']) {
          return jsonData['data'];
        } else {
          throw Exception(
              jsonData['message'] ?? 'Tidak ada data produk yang ditemukan.');
        }
      } else {
        throw Exception(
            'Gagal mengambil data produk. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan saat mengambil data: $e');
    }
  }

  // Ambil detail produk berdasarkan id produk
  Future<Map<String, dynamic>> fetchProductDetail(int productId) async {
    try {
      final url = Uri.parse('$baseUrl?id=$productId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success']) {
          return jsonData['data'];
        } else {
          throw Exception(
              jsonData['message'] ?? 'Detail produk tidak ditemukan.');
        }
      } else {
        throw Exception(
            'Gagal mengambil detail produk. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan saat mengambil detail produk: $e');
    }
  }
}
