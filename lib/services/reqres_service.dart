import 'dart:convert';
import 'package:http/http.dart' as http;

class ReqresService {
  static const String _baseUrl = 'https://reqres.in/api';

  // Register using ReqRes API
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Registrasi gagal'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal: ${e.toString()}'};
    }
  }

  // Login using ReqRes API
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'token': data['token']};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Login gagal'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal: ${e.toString()}'};
    }
  }

  // Get user list (for demo)
  static Future<List<Map<String, dynamic>>> getUsers({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users?page=$page'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
