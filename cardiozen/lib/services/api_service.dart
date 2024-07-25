import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:8000/api/predict'; // Adjust to your backend URL

  Future<String> getPrediction(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['prediction'] ?? 'No prediction available';
    } else {
      throw Exception('Failed to get prediction');
    }
  }
}
