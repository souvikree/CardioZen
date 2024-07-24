import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthenticationService {
  final String baseUrl = 'http://localhost:8000/api/auth'; // Adjust to your backend URL

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> register(String email, String password, String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
      }),
    );

    return response.statusCode == 201;
  }
}
